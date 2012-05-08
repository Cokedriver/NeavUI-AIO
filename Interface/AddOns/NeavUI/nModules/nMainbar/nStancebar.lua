local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

ShapeshiftBarFrame:SetFrameStrata('HIGH')

ShapeshiftBarFrame:SetScale(C['nMainbar'].stanceBar.scale)
ShapeshiftBarFrame:SetAlpha(C['nMainbar'].stanceBar.alpha)


if (C['nMainbar'].stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

