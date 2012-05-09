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
if C['nMedia'].border == "Default" then
	hexa = ("|cff%.2x%.2x%.2x"):format(0.38 * 255, 0.38 * 255, 0.38 * 255)
	hexb = "|r"	
elseif C['nMedia'].border == "Classcolor" then
	hexa = ("|cff%.2x%.2x%.2x"):format(N.ccolor.r * 255, N.ccolor.g * 255, N.ccolor.b * 255)
	hexb = "|r"
elseif C['nMedia'].border == "Custom" then
	hexa = ("|cff%.2x%.2x%.2x"):format(C['nMedia'].color.r * 255, C['nMedia'].color.g * 255, C['nMedia'].color.b * 255)
	hexb = "|r"		
end	