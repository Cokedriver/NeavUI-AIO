local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

StanceBarFrame:SetFrameStrata('HIGH')

StanceBarFrame:SetScale(C['nMainbar'].stanceBar.scale)
StanceBarFrame:SetAlpha(C['nMainbar'].stanceBar.alpha)

if (C['nMainbar'].stanceBar.hide) then
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G['StanceButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

