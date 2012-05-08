local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

    -- experience bar mouseover text

MainMenuBarExpText:SetFont(C['nMedia'].font, C['nMainbar'].expBar.fontsize, 'THINOUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

if (C['nMainbar'].expBar.mouseover) then
    MainMenuBarExpText:SetAlpha(0)
    
    MainMenuExpBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
    end)

    MainMenuExpBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
    end)
else
    MainMenuBarExpText:Show()
    MainMenuBarExpText.Hide = function() end
end