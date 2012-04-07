local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

MultiBarBottomRight:SetAlpha(C['mainbar'].multiBarBottomRight.alpha)

if (C['mainbar'].multiBarBottomRight.orderVertical) then
    for i = 2, 12 do
        button = _G['MultiBarBottomRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['MultiBarBottomRightButton'..(i - 1)], 'BOTTOM', 0, -6)
    end

    MultiBarBottomRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        
        if (C['mainbar'].multiBarBottomRight.verticalPosition == 'RIGHT') then
            self:SetPoint('TOPRIGHT', MultiBarLeftButton1, 'TOPLEFT', -6, 0)
        else
            self:SetPoint('TOPLEFT', UIParent, 'LEFT', 6, (MultiBarBottomRight:GetWidth() / 2))
        end
    end)
end