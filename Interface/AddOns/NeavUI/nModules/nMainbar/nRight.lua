local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

MultiBarRight:SetAlpha(C['nMainbar'].multiBarRight.alpha)
MultiBarRight:SetScale(C['nMainbar'].scale)

if (C['nMainbar'].multiBarRight.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarRightButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        self:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, 6)
    end)
else
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -6, (MultiBarRight:GetHeight() / 2))
end