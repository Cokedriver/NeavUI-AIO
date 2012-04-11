local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end

local function GetNumShapeSlots()
    local _, class = UnitClass('Player')
    
    if (class == 'DEATHKNIGHT' or class == 'WARRIOR') then
        return 3
    elseif (class == 'ROGUE' or class == 'PRIEST') then
        return 1
    else
        return NUM_SHAPESHIFT_SLOTS
    end
end

    -- mouseover function

local function EnableMouseOver(self, bar, min, max, alpha)
    local minAlpha = 0

    for i = min, max do
        local button = _G[self..i]
        
        local f = CreateFrame('Frame', bar, bar)
        f:SetFrameStrata('LOW')
        f:SetFrameLevel(1)
        f:EnableMouse()
        f:SetPoint('TOPLEFT', self..min, -5, 5)
        f:SetPoint('BOTTOMRIGHT', self..max, 5, 5)

        bar:SetAlpha(minAlpha)

        f:SetScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)

        f:SetScript('OnLeave', function() 
            if (not MouseIsOver(button)) then
                bar:SetAlpha(minAlpha)
            end
        end)

        button:HookScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)

        button:HookScript('OnLeave', function() 
            if (not MouseIsOver(bar)) then
                bar:SetAlpha(minAlpha)
            end
        end)
    end
end

if (C['mainbar'].multiBarLeft.mouseover) then
    EnableMouseOver('MultiBarLeftButton', MultiBarLeft, 1, 12, C['mainbar'].multiBarLeft.alpha)
end

if (C['mainbar'].multiBarRight.mouseover) then
    EnableMouseOver('MultiBarRightButton', MultiBarRight, 1, 12, C['mainbar'].multiBarRight.alpha)
end

if (C['mainbar'].multiBarBottomLeft.mouseover) then
    EnableMouseOver('MultiBarBottomLeftButton', MultiBarBottomLeft, 1, 12, C['mainbar'].multiBarBottomLeft.alpha)
end

if (C['mainbar'].multiBarBottomRight.mouseover) then
    EnableMouseOver('MultiBarBottomRightButton', MultiBarBottomRight, 1, 12, C['mainbar'].multiBarBottomRight.alpha)
end

if (C['mainbar'].petBar.mouseover) then
    EnableMouseOver('PetActionButton', PetActionBarFrame, 1, 10, C['mainbar'].petBar.alpha)
end

if (C['mainbar'].stanceBar.mouseover) then
    EnableMouseOver('ShapeshiftButton', ShapeshiftBarFrame, 1, GetNumShapeSlots(), C['mainbar'].stanceBar.alpha)
end