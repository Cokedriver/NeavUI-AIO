local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

SlashCmdList['GM'] = function()
    ToggleHelpFrame() 
end

SLASH_GM1 = '/gm'
SLASH_GM2 = '/ticket'
SLASH_GM3 = '/gamemaster'