--[[
@title Camera WiFi Control through Toshiba Flashair
@chdk_version 1.3
 Author: Jens Heilig
 based on ideas from Phuoc Can HUA (bigboss97)
 2016-08-11
 
 This script receives commands from polling the contents of a
 directory (WDIR). The *filenames* found in this directory are interpreted
 as commands.
 After execution of the command (see list "cmdlist" in this script)
 (or if a command is unknown) the file is erased.
 Commands can have parameters, embedded in the filename and separated by underscores
 (actually whitespace, but underscore is most practical in a filename).
 Parameters are positional (i.e. a parameter is identified by it's position), they
 cannot be named.
--]]

WDIR = "A/WIFICTRL"
DATADIR = WDIR .. "/" .. "data"
STATDIR = WDIR .. "/" .. "stat"
STATFILE = STATDIR .. "/stats.txt"

-- list of available commands understood by this script
cmdlist = {
	["ZOOMIN"]= function(params) click("zoom_in") reportStats(500) end,
	["ZOOMOUT"]= function(params) click("zoom_out") reportStats(500) end,
	["SHOOT"]= function(params) multiShoot(params[2], params[3]) reportStats(1000) end,
	["STATS"]= function(params)  reportStats(0) end,
}

stats={}

-- Write a map to file fname for another LUA script to read back via "dofile()"
function writeMap(m, fname)
	local f = io.open(fname,"w" )
	if f == nil then print("no stat:"..fname) return end
	--f:write( string.format( html,100*get_zoom()/ZOOMMAX, os.date('%m'), lastCnt, lastCnt))
  for k,v in pairs(m) do
    local t = { }
    t[1] = 'props["'
    t[#t+1] = tostring(k)
    t[#t+1] = '"]="'
    t[#t+1] = tostring(v)
    t[#t+1] = '"'
    f:write(table.concat(t,""))
  end
	f:close()
end

-- returns a LUA map of various camera stats
function getStats()
  s = {}
  s["Last Image"] = "IMG_"..get_exp_count()
  s["Free Space on SD"] = get_free_disk_space()
  s["Remaining jpg Images"] = get_jpg_count()
  s["Battery Voltage"] = get_vbatt()
  s["Zoom"] = get_zoom()
  return s
end

-- reports camera stats via file exchange to flashair script
function reportStats(t)
  local s=getStats()
  writeMap(s, STATFILE)
  if (t > 0) then
    sleep (t)
    reportStats(0)
  end
end

-- clears all files in a directory
function clearDir(d)
  files = os.listdir(d)
  count = table.getn(files)
  for i=1, count do
    os.remove(d .. "/" .. files[i])
  end	
end

-- splits a string with separators in tokens
function splitStr(str)
  local s={}
  local i
  for i in string.gmatch(str,"%w+") do
    table.insert(s, i)
  end
  return s
end

-- take n pictures with interval time ival
function multiShoot(n, ival)
  local i
  n=tonumber(n)
  ival = tonumber (ival)
  if (n == nil or n < 0) then n=1 end
  for i = 1,n do
    shoot()
    if (ival and (ival ~= 0)) then
      sleep(ival)
    end
  end
end
      

---------------------------------------------------------
-- Clean (or create, if it does not exist yet) data and stat directory before start
print("Activate Flashair WiFi and load http://flashair/wifictrl/index.html")
if os.stat(DATADIR)==nil then os.mkdir(DATADIR) end
if os.stat(STATDIR)==nil then os.mkdir(STATDIR) end

clearDir(DATADIR)
clearDir(STATDIR)

repeat
	wait_click(100)
	if is_key("set") then
		break
	else
		files = os.listdir(DATADIR)
		count = table.getn(files)
		for i = 1, count do
		  local cmd = splitStr(files[i])
			if (cmdlist[string.upper(cmd[1])]) then cmdlist[string.upper(cmd[1])](cmd) end
			os.remove(DATADIR .. "/" .. files[i])
		end
	end
until (false)
