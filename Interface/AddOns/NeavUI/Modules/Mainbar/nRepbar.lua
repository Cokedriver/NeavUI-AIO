local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end
 
    -- reputation bar mouseover text

ReputationWatchStatusBarText:SetFont(C['media'].font, C['mainbar'].repBar.fontsize, 'THINOUTLINE')
ReputationWatchStatusBarText:SetShadowOffset(0, 0)

if (C['mainbar'].repBar.mouseover) then
    ReputationWatchStatusBarText:SetAlpha(0)

    ReputationWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 1)
    end)

    ReputationWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 0) 
    end)
else
    ReputationWatchStatusBarText:Show()
    ReputationWatchStatusBarText.Hide = function() end
end