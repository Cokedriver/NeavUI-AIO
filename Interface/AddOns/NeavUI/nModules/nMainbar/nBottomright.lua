local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

MultiBarBottomRight:SetAlpha(C['nMainbar'].multiBarBottomRight.alpha)

if (C['nMainbar'].multiBarBottomRight.orderVertical) then
    for i = 2, 12 do
        button = _G['MultiBarBottomRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['MultiBarBottomRightButton'..(i - 1)], 'BOTTOM', 0, -6)
    end

    MultiBarBottomRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        
        if (C['nMainbar'].multiBarBottomRight.verticalPosition == 'RIGHT') then
            self:SetPoint('TOPRIGHT', MultiBarLeftButton1, 'TOPLEFT', -6, 0)
        else
            self:SetPoint('TOPLEFT', UIParent, 'LEFT', 6, (MultiBarBottomRight:GetWidth() / 2))
        end
    end)
end