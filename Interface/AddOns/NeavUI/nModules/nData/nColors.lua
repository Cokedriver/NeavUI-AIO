local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Colors.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

---------------------------------------------------
-- Color system for Data Created by Hydra 
---------------------------------------------------
if C['nMedia'].classcolor ~= true then
	local r, g, b = C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b
	hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
	hexb = "|r"
else
	hexa = ("|cff%.2x%.2x%.2x"):format(N.ccolor.r * 255, N.ccolor.g * 255, N.ccolor.b * 255)
	hexb = "|r"
end


