local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

ShapeshiftBarFrame:SetFrameStrata('HIGH')

ShapeshiftBarFrame:SetScale(C['mainbar'].stanceBar.scale)
ShapeshiftBarFrame:SetAlpha(C['mainbar'].stanceBar.alpha)


if (C['mainbar'].stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

