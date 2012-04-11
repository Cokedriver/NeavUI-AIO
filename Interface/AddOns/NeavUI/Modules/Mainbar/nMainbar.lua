local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end

if (C['mainbar'].MainMenuBar.hideGryphons) then
    MainMenuBarLeftEndCap:SetTexCoord(0, 0, 0, 0)
    MainMenuBarRightEndCap:SetTexCoord(0, 0, 0, 0)
end

MainMenuBar:SetScale(C['mainbar'].MainMenuBar.scale)
VehicleMenuBar:SetScale(C['mainbar'].vehicleBar.scale)