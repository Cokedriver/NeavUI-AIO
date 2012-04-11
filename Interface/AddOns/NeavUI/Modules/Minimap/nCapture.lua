local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['minimap'].enable ~= true then return end

hooksecurefunc('UIParent_ManageFramePositions', function()
    if (NUM_EXTENDED_UI_FRAMES) then
        for i = 1, NUM_EXTENDED_UI_FRAMES do
            local bar = _G['WorldStateCaptureBar'..i]

            if (bar and bar:IsVisible()) then
                bar:ClearAllPoints()
                bar:SetScale(0.9333334)

                if (i == 1) then
                    bar:SetPoint('TOP', Minimap, 'BOTTOM', 0, C['minimap'].tab.showBelowMinimap and -30 or -10)
                else
                    bar:SetPoint('TOP', _G['WorldStateCaptureBar'..(i-1)], 'BOTTOM', 0, -15)
                end
            end
        end
    end
end)