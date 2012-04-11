----------------------------------------------------------------------------
-- This Module loads new user settings if NeavUI_Config is loaded
----------------------------------------------------------------------------
local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--Convert default database
for group,options in pairs(DB) do
	if not C[group] then C[group] = {} end
	for option, value in pairs(options) do
		C[group][option] = value
	end
end

if IsAddOnLoaded("NeavUI_Config") then
	local NeavUIConfig = LibStub("AceAddon-3.0"):GetAddon("NeavUIConfig")
	NeavUIConfig:Load()

	--Load settings from NeavUIConfig database
	for group, options in pairs(NeavUIConfig.db.profile) do
		if C[group] then
			for option, value in pairs(options) do
				C[group][option] = value
			end
		end
	end
		
	N.SavePath = NeavUIConfig.db.profile
end




