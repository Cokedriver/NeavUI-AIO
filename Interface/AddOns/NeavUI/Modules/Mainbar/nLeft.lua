local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end

MultiBarLeft:SetAlpha(C['mainbar'].multiBarLeft.alpha)
MultiBarLeft:SetScale(C['mainbar'].MainMenuBar.scale)

MultiBarLeft:SetParent(UIParent)

if (C['mainbar'].multiBarLeft.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarLeftButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarLeftButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarLeftButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()

        if (not C['mainbar'].MainMenuBar.shortBar) then
            self:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)
        else
            if (C['mainbar'].multiBarRight.orderHorizontal) then
                self:SetPoint('BOTTOMLEFT', MultiBarRightButton1, 'TOPLEFT', 0, 6)
            else
                self:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, 6)
            end
            
        end
    end)
else
    if (C['mainbar'].multiBarRight.orderHorizontal) then
        MultiBarLeftButton1:ClearAllPoints()
        MultiBarLeftButton1:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -6, (MultiBarLeft:GetHeight() / 2))
    else
        MultiBarLeftButton1:ClearAllPoints() 
        MultiBarLeftButton1:SetPoint('TOPRIGHT', MultiBarRightButton1, 'TOPLEFT', -6, 0)
    end
end