local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

if (not C['mainbar'].MainMenuBar.skinButton) then
    return
end

local _G, pairs, unpack = _G, pairs, unpack
local path = 'Interface\\AddOns\\NeavUI\\Media\\'

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if (sbut) then
        return true
    else
        return false
    end
end

local function UpdateVehicleButton()
    for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
        local hotkey = _G['VehicleMenuBarActionButton'..i..'HotKey']
        if (C['mainbar'].button.showVehicleKeybinds) then
            hotkey:SetFont(C['mainbar'].button.hotkeyFont, C['mainbar'].button.hotkeyFontsize + 3, 'OUTLINE')
            hotkey:SetVertexColor(C['mainbar'].color.HotKeyText[1], C['mainbar'].color.HotKeyText[2], C['mainbar'].color.HotKeyText[3])
        else
            hotkey:Hide()
        end
    end
end

hooksecurefunc('PetActionBar_Update', function()
    for _, name in pairs({
        'PetActionButton',
        'PossessButton',    
        'ShapeshiftButton', 
    }) do
        for i = 1, 12 do
            local button = _G[name..i]
            if (button) then
                button:SetNormalTexture(path..'MainbarNormal')

                if (not InCombatLockdown()) then
                    local cooldown = _G[name..i..'Cooldown']
                    cooldown:ClearAllPoints()
                    cooldown:SetPoint('TOPRIGHT', button, -2, -2)
                    cooldown:SetPoint('BOTTOMLEFT', button, 1, 1)
                    -- cooldown:SetDrawEdge(true)
                end

                if (not button.Shadow) then
                    local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
                    normal:ClearAllPoints()
                    normal:SetPoint('TOPRIGHT', button, 1.5, 1.5)
                    normal:SetPoint('BOTTOMLEFT', button, -1.5, -1.5)
                    normal:SetVertexColor(C['mainbar'].color.Normal[1], C['mainbar'].color.Normal[2], C['mainbar'].color.Normal[3], 1)

                    local icon = _G[name..i..'Icon']
                    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
                    icon:SetPoint('TOPRIGHT', button, 1, 1)
                    icon:SetPoint('BOTTOMLEFT', button, -1, -1)

                    local flash = _G[name..i..'Flash']
                    flash:SetTexture(flashtex)

                    button:SetCheckedTexture(path..'MainbarChecked')
                    button:GetCheckedTexture():SetAllPoints(normal)
                    -- button:GetCheckedTexture():SetDrawLayer('OVERLAY')

                    button:SetPushedTexture(path..'MainbarPushed')
                    button:GetPushedTexture():SetAllPoints(normal)
                    -- button:GetPushedTexture():SetDrawLayer('OVERLAY')

                    button:SetHighlightTexture(path..'MainbarHighlight')
                    button:GetHighlightTexture():SetAllPoints(normal)

                    local buttonBg = _G[name..i..'FloatingBG']
                    if (buttonBg) then
                        buttonBg:ClearAllPoints()
                        buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                        buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                        buttonBg:SetTexture(path..'MainbarShadow')
                        buttonBg:SetVertexColor(0, 0, 0, 1)
                        button.Shadow = true
                    else
                        button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                        button.Shadow:SetParent(button)  
                        button.Shadow:SetPoint('TOPRIGHT', normal, 4, 4)
                        button.Shadow:SetPoint('BOTTOMLEFT', normal, -4, -4)
                        button.Shadow:SetTexture(path..'MainbarShadow')
                        button.Shadow:SetVertexColor(0, 0, 0, 1)
                    end
                end
            end
        end
    end
end)

hooksecurefunc('ActionButton_Update', function(self)
    if (IsSpecificButton(self, 'MultiCast')) then
        for _, icon in pairs({
            self:GetName(),
            'MultiCastRecallSpellButton',
            'MultiCastSummonSpellButton',
        }) do
            local button = _G[icon]
            button:SetNormalTexture(nil)

            if (not button.Shadow) then
                local icon = _G[self:GetName()..'Icon']
                icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

                button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                button.Shadow:SetParent(button)  
                button.Shadow:SetPoint('TOPRIGHT', button, 4.5, 4.5)
                button.Shadow:SetPoint('BOTTOMLEFT', button, -4.5, -4.5)
                button.Shadow:SetTexture(path..'MainbarShadow')
                button.Shadow:SetVertexColor(0, 0, 0, 0.85)
            end
        end
    elseif (not IsSpecificButton(self, 'ExtraActionButton')) then
        local button = _G[self:GetName()]

        --[[
            -- no 'macr...'

        local macroname = _G[self:GetName()..'Name']
        if (macroname) then
            if (C['mainbar'].button.showMacronames) then
                if (macroname:GetText()) then
                    macroname:SetText(macroname:GetText():sub(1, 6))
                end
            end
        end
        --]]

        if (not button.Background) then
            local normal = _G[self:GetName()..'NormalTexture']
            if (normal) then
                normal:ClearAllPoints()
                normal:SetPoint('TOPRIGHT', button, 1, 1)
                normal:SetPoint('BOTTOMLEFT', button, -1, -1)
                normal:SetVertexColor(C['mainbar'].color.Normal[1], C['mainbar'].color.Normal[2], C['mainbar'].color.Normal[3], 1)
                -- normal:SetDrawLayer('ARTWORK')
            end

            button:SetNormalTexture(path..'MainbarNormal')

            button:SetCheckedTexture(path..'MainbarChecked')
            button:GetCheckedTexture():SetAllPoints(normal)

            button:SetPushedTexture(path..'MainbarPushed')
            button:GetPushedTexture():SetAllPoints(normal)

            button:SetHighlightTexture(path..'MainbarHighlight')
            button:GetHighlightTexture():SetAllPoints(normal)

            local icon = _G[self:GetName()..'Icon']
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            -- icon:SetPoint('TOPRIGHT', button, -1, -1)
            -- icon:SetPoint('BOTTOMLEFT', button, 1, 1)
            -- icon:SetDrawLayer('BORDER')

            local border = _G[self:GetName()..'Border']
            if (border) then
                border:SetAllPoints(normal)
                -- border:SetDrawLayer('OVERLAY')
                border:SetTexture(path..'MainbarHighlight')
                border:SetVertexColor(unpack(C['mainbar'].color.IsEquipped))
            end

            local count = _G[self:GetName()..'Count']
            if (count) then
                count:SetPoint('BOTTOMRIGHT', button, 0, 1)
                count:SetFont(C['mainbar'].button.countFont, C['mainbar'].button.countFontsize, 'OUTLINE')
                count:SetVertexColor(C['mainbar'].color.CountText[1], C['mainbar'].color.CountText[2], C['mainbar'].color.CountText[3], 1)
            end

            local macroname = _G[self:GetName()..'Name']
            if (macroname) then
                if (not C['mainbar'].button.showMacronames) then
                    macroname:SetAlpha(0)
                else
                    -- macroname:SetDrawLayer('OVERLAY')
                    macroname:SetWidth(button:GetWidth() + 15)
                    macroname:SetFont(C['mainbar'].button.macronameFont, C['mainbar'].button.macronameFontsize, 'OUTLINE')
                    macroname:SetVertexColor(unpack(C['mainbar'].color.MacroText))
                end
            end

            local buttonBg = _G[self:GetName()..'FloatingBG']
            if (buttonBg) then
                buttonBg:ClearAllPoints()
                buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                buttonBg:SetTexture(path..'MainbarShadow')
                buttonBg:SetVertexColor(0, 0, 0, 1)
            end

            button.Background = button:CreateTexture(nil, 'BACKGROUND', nil, -8)
            button.Background:SetTexture(path..'MainbarBackground')
            button.Background:SetPoint('TOPRIGHT', button, 14, 12)
            button.Background:SetPoint('BOTTOMLEFT', button, -14, -16)
        end

        if (not InCombatLockdown()) then
            local cooldown = _G[self:GetName()..'Cooldown']
            cooldown:ClearAllPoints()
            cooldown:SetPoint('TOPRIGHT', button, -2, -2.5)
            cooldown:SetPoint('BOTTOMLEFT', button, 2, 2)
            -- cooldown:SetDrawEdge(true)
        end

        local border = _G[self:GetName()..'Border']
        if (border) then
            if (IsEquippedAction(self.action)) then
                _G[self:GetName()..'Border']:SetAlpha(1)
            else
                _G[self:GetName()..'Border']:SetAlpha(0)
            end
        end
    end
end)

hooksecurefunc('ActionButton_ShowGrid', function(self)
    local normal = _G[self:GetName()..'NormalTexture']
    if (normal) then
        normal:SetVertexColor(C['mainbar'].color.Normal[1], C['mainbar'].color.Normal[2], C['mainbar'].color.Normal[3], 1) 
    end
end)

hooksecurefunc('ActionButton_UpdateUsable', function(self)
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end  

    local normal = _G[self:GetName()..'NormalTexture']
    if (normal) then
        normal:SetVertexColor(C['mainbar'].color.Normal[1], C['mainbar'].color.Normal[2], C['mainbar'].color.Normal[3], 1) 
    end

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if (isUsable) then
        _G[self:GetName()..'Icon']:SetVertexColor(1, 1, 1)
    elseif (notEnoughMana) then
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(C['mainbar'].color.OutOfMana))
    else
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(C['mainbar'].color.NotUsable))
    end
end)

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local hotkey = _G[self:GetName()..'HotKey']

    if (not IsSpecificButton(self, 'VehicleMenuBarActionButton')) then
        if (C['mainbar'].button.showKeybinds) then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, 0, -3)
            -- hotkey:SetDrawLayer('OVERLAY')
            hotkey:SetFont(C['mainbar'].button.hotkeyFont, C['mainbar'].button.hotkeyFontsize, 'OUTLINE')
            hotkey:SetVertexColor(C['mainbar'].color.HotKeyText[1], C['mainbar'].color.HotKeyText[2], C['mainbar'].color.HotKeyText[3])
        else
            hotkey:Hide()    
        end
    else
        UpdateVehicleButton()
    end
end)

function ActionButton_OnUpdate(self, elapsed)
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end     

    if (ActionButton_IsFlashing(self)) then
        local flashtime = self.flashtime
        flashtime = flashtime - elapsed

        if (flashtime <= 0) then
            local overtime = - flashtime
            if (overtime >= ATTACK_BUTTON_FLASH_TIME) then
                overtime = 0
            end

            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = _G[self:GetName()..'Flash']
            if (flashTexture:IsShown()) then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        self.flashtime = flashtime
    end

    local rangeTimer = self.rangeTimer
    if (rangeTimer) then
        rangeTimer = rangeTimer - elapsed
        if (rangeTimer <= 0.1) then
            local isInRange = false
            if (ActionHasRange(self.action) and IsActionInRange(self.action) == 0) then
                _G[self:GetName()..'Icon']:SetVertexColor(unpack(C['mainbar'].color.OutOfRange))
                isInRange = true
            end

            if (self.isInRange ~= isInRange) then
                self.isInRange = isInRange
                ActionButton_UpdateUsable(self)
            end

            rangeTimer = TOOLTIP_UPDATE_TIME
        end

        self.rangeTimer = rangeTimer
    end
end

local f = CreateFrame('Frame', MainMenuBar)
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
    if (IsAddOnLoaded('tullaRange')) then
        if (not tullaRange) then
            return
        end

        function tullaRange.SetButtonColor(button, colorType)
            if (button.tullaRangeColor ~= colorType) then
                button.tullaRangeColor = colorType

                local r, g, b = tullaRange:GetColor(colorType)

                local icon =  _G[button:GetName()..'Icon']
                icon:SetVertexColor(r, g, b)
            end
        end
    end
end)