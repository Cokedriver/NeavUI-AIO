----------------------------------
-- Engine to make all files communicate.

-- Credit Nightcracker
----------------------------------
 
-- including system
local addon, engine = ...
engine[1] = {} -- N, functions, constants
engine[2] = {} -- C, config
engine[3] = {} -- DB, database

NeavUI = engine --Allow other addons to use Engine

--[[
	This should be at the top of every file inside of the NeavUI AddOn:
	
	local N, C, DB = unpack(select(2, ...))

	This is how another addon imports the NeavUI engine:
	
	local N, C, DB = unpack(NeavUI)
]]

local L = setmetatable({}, { __index = function(t,k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end })

local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

N.scale = function(v) return m * floor(v/m+.5) end;
N.dummy = function() return end
N.toc = select(4, GetBuildInfo())
N.myname, _ = UnitName("player")
N.myrealm = GetRealmName()
_, N.myclass = UnitClass("player")
N.version = GetAddOnMetadata("NeavUI", "Version")
N.patch = GetBuildInfo()
N.level = UnitLevel("player")
N.locale = GetLocale()
N.resolution = GetCurrentResolution()
N.getscreenresolution = select(N.resolution, GetScreenResolutions())
N.getscreenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
N.getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"))
N.ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
N.regions = {['TOPLEFT'] = L['TOPLEFT'], ['TOP'] = L['TOP'], ['TOPRIGHT'] = L['TOPRIGHT'], ['LEFT'] = L['LEFT'], ['CENTER'] = L['CENTER'], ['RIGHT'] = L['RIGHT'], ['BOTTOMLEFT'] = L['BOTTOMLEFT'], ['BOTTOM'] = L['BOTTOM'], ['BOTTOMRIGHT'] = L['BOTTOMRIGHT']}
N.healthTag = {['$cur'] = L['$cur'], ['$max'] = L['$max'], ['$deficit'] = L['$deficit'], ['$perc'] = L['$perc'], ['$smartperc'] = L['$smartperc'], ['$smartcolorperc'] = L['$smartcolorperc'], ['$colorperc'] = L['$colorperc']}
N.healthFormat = {['$cur/$max'] = L['$cur/$max'], ['$cur-$max'] = L['$cur-$max']}
N.style = {['NORMAL'] = L['NORMAL'], ['RARE'] = L['RARE'], ['ELITE'] = L['ELITE'], ['CUSTOM'] = L['CUSTOM']}
N.LorR = {['LEFT'] = L['LEFT'], ['RIGHT'] = L['RIGHT']}
N.type = {['type1'] = L['type1'], ['type2'] = L['type2'], ['type3'] = L['type3'], ['type4'] = L['type4'], ['type5'] = L['type5'], ['type6'] = L['type6'], ['type7'] = L['type7'], ['type8'] = L['type8'], ['type9'] = L['type9'], ['type0'] = L['type0'], ['mousebutton1'] = L['mousebutton1'], ['mousebutton2'] = L['mousebutton2'], ['mousebutton3'] = L['mousebutton3'], ['mousebutton4'] = L['mousebutton4'], ['mousebutton5'] = L['mousebutton5']}
N.orientation = {['VERTICAL'] = L['VERTICAL'], ['HORIZONTAL'] = L['HORIZONTAL']}
N.panel = {['Top'] = L['Top'], ['Bottom'] = L['Bottom'], ['Shortbar'] = L['Shortbar']}
N.border = {['Blizzard'] = L['Blizzard'], ['Neav'] = L['Neav']}
N.bordercolor = {['Default'] = L['Default'], ['Classcolor'] = L['Classcolor'], ['Custom'] = L['Custom']}