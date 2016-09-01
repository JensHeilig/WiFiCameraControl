-- Author: Jens Heilig
-- based on ideas from Phuoc Can HUA (bigboss97)
-- August 2016

-- for debugging
if lfs==nil then 
  require("lfs")
  WDIR = lfs.currentdir()
else
  WDIR="/WIFICTRL"
end

DATADIR = WDIR .. "/" .. "data"
STATFILE=WDIR .. "/" .. "stat/stats.txt"
props={}


-- Decodes URL Query String Entities, e.g. '%20' becomes ' ' (space)
local function decode(s)
    s = s:gsub('+', ' ')
    s = s:gsub('\n', '')
    s = s:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

-- Transforms query string, e.g. 'cmd=get&par=whatever' into a map '{cmd = "get", par = "whatever"}'
local function parseurl(qs)
  local map = {}
  qs:gsub('([^&=]+)=([^&=]*)&?',
           function(key, val) map[decode(key)] = decode(val) end)
  return map
end

-- Creates a file in a fixed location with name given in parameter
local function writeCmdFile(cmd)
	local file = io.open(DATADIR .. "/" .. cmd, "w" )
	if file ~= nil then file:close() end
end

-- Tests if a file "fpath" exists, returns true/false
function fileExists(fpath)
  if type(fpath)~="string" then return false end
  attr = lfs.attributes(fpath)
  if attr ~= nil and attr.mode == "file" then
    return true
  else
    return false
  end
end

-- Tests if a directory "path" exists, returns true/false
function dirExists(path)
  if type(path)~="string" then return false end
  attr = lfs.attributes(path)
  if attr ~= nil and attr.mode == "directory" then
    return true
  else
    return false
  end
end

-- Prints a JSON AJAX response including http headers
function replyJSON(s)
  print ("HTTP/1.1 200 OK")
  print ("Content-Type: application/json")
  print ("")
  print(s)
end

-- reads a properties file containing key-value-pairs (written by the corresponding CHDK script)
-- sets default properties if file does not exist
function readCHDKStatus(fname)
  if fileExists(fname) then
    props={}
    dofile(fname)
  else
    props = {}
    --props["Last Image"] = 12345
  end
end

-- converts a LUA map to a JSON array of name/value pairs
function JSONencode(m)
  local t = { }
  t[1]="["
  for k,v in pairs(m) do
      t[#t+1] = '{ "name":"'
      t[#t+1] = tostring(k)
      t[#t+1] = '","value":"'
      t[#t+1] = tostring(v)
      t[#t+1] = '"},'
  end
  t[#t] = '"}]' -- replaces trailing comma with ']'
  return table.concat(t,"")
end

------------------------------------------------------------

args={...}
if dirExists(DATADIR) == false then
  lfs.mkdir(DATADIR)
end
t = parseurl(args[1])
cmd=t["cmd"]
par=t["par"]
if cmd=="get" then
  readCHDKStatus(STATFILE)
  replyJSON (JSONencode(props))
elseif cmd=="set" and par ~= nil then
  writeCmdFile(par)
  readCHDKStatus(STATFILE)
  replyJSON (JSONencode(props))
end
