local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nTooltip'].enable ~= true then return end

if (not C['nTooltip'].disableFade) then
    return
end

-- GameTooltip.FadeOut = GameTooltip.Hide
GameTooltip.UpdateTime = 0
GameTooltip:HookScript('OnUpdate', function(self, elapsed)
    self.UpdateTime = self.UpdateTime + elapsed
    if (self.UpdateTime > TOOLTIP_UPDATE_TIME) then
        self.UpdateTime = 0
        if (GetMouseFocus() == WorldFrame and (not UnitExists('mouseover'))) then
            self:Hide()
        end
       end
end)