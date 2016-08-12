--[[
@title Camera WiFi Control through Toshiba Flashair
@chdk_version 1.3
 Author: Jens Heilig
 based on ideas from Phuoc Can HUA (bigboss97)
 2016-08-11
--]]

WDIR = "A/WIFICTRL"
DATADIR = WDIR .. "/" .. "data"
STATDIR = WDIR .. "/" .. "stat"
STATFILE = STATDIR .. "/stats.txt"

-- list of available commands understood by this script
actions = {
	["ZOOMIN"]= function() click("zoom_in") reportStats() end,
	["ZOOMOUT"]= function() click("zoom_out") reportStats() end,
	["SHOOT"]= function() shoot() reportStats() end,
	["STATS"]= reportStats,
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
function reportStats()
  local s=getStats()
  writeMap(s, STATFILE)
end

-- clears all files in a directory
function clearDir(d)
  files = os.listdir(d)
  count = table.getn(files)
  for i=1, count do
    os.remove(d .. "/" .. files[i])
  end	
end
---------------------------------------------------------
-- Clean (or create, if it does not exist yet) data and stat directory before start
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
			if (actions[files[i]]) then actions[files[i]]() end
			os.remove(DATADIR .. "/" .. files[i])
		end
	end
until (false)
