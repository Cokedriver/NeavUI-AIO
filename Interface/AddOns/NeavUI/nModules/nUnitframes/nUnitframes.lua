local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nUnitframes'].enable ~= true then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "NeavUI was unable to locate oUF install.")


local playerClass = select(2, UnitClass('player'))
local charTexPath = 'Interface\\CharacterFrame\\'
local tarTexPath = 'Interface\\TargetingFrame\\'
local texPath = tarTexPath..'UI-TargetingFrame'

local texTable = {
    ['elite'] = texPath..'-Elite',
    ['rareelite'] = texPath..'-Rare-Elite',
    ['rare'] = texPath..'-Rare',
    ['worldboss'] = texPath..'-Elite',
    ['normal'] = texPath,
}

local tabCoordTable = {
    [1] = {0.1875, 0.53125, 0, 1},
    [2] = {0.53125, 0.71875, 0, 1},
    [3] = {0, 0.1875, 0, 1},
}

local function CreateDropDown(self)
    local dropdown = _G[string.format('%sFrameDropDown', string.gsub(self.unit, '(.)', string.upper, 1))]

    if (dropdown) then
        ToggleDropDownMenu(1, nil, dropdown, 'cursor')
    elseif (self.unit:match('party')) then
        ToggleDropDownMenu(1, nil, _G[format('PartyMemberFrame%dDropDown', self.id)], 'cursor')
    else
        FriendsDropDown.unit = self.unit
        FriendsDropDown.id = self.id
        FriendsDropDown.initialize = RaidFrameDropDown_Initialize
        ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
    end
end

UnitPopupMenus['MOVE_PLAYER_FRAME'] = { 
    'UNLOCK_PLAYER_FRAME', 
    'LOCK_PLAYER_FRAME', 
    'RESET_PLAYER_FRAME_POSITION'
}

local __pa = CreateFrame('Frame', 'oUF_Neav_Player_Anchor', UIParent)
__pa:SetSize(1, 1)
__pa:SetPoint(C['nUnitframes'].units.player.position.selfAnchor , C['nUnitframes'].units.player.position.frameParent, C['nUnitframes'].units.player.position.offSetX , C['nUnitframes'].units.player.position.offSetY )
__pa:SetMovable(true)
__pa:SetUserPlaced(true)
__pa:SetClampedToScreen(true)

PLAYER_FRAME_UNLOCKED = false
function PlayerFrame_SetLocked(locked)
    PLAYER_FRAME_UNLOCKED = not locked

    if (locked) then
        if (oUF_Neav_Player) then
            oUF_Neav_Player:RegisterForDrag() 
        end
    else
        if (oUF_Neav_Player) then
            oUF_Neav_Player:RegisterForDrag('LeftButton') 
        end
    end
end

function PlayerFrame_ResetUserPlacedPosition()
    if (oUF_Neav_Player) then
        __pa:ClearAllPoints()
        __pa:SetPoint(C['nUnitframes'].units.player.position.selfAnchor , C['nUnitframes'].units.player.position.frameParent, C['nUnitframes'].units.player.position.offSetX , C['nUnitframes'].units.player.position.offSetY )
        PlayerFrame_SetLocked(true)
    end
end

UnitPopupMenus['MOVE_TARGET_FRAME'] = { 
    'UNLOCK_TARGET_FRAME', 
    'LOCK_TARGET_FRAME', 
    'RESET_TARGET_FRAME_POSITION'
}

local __ta = CreateFrame('Frame', 'oUF_Neav_Target_Anchor', UIParent)
__ta:SetSize(1, 1)
__ta:SetPoint(C['nUnitframes'].units.target.position.selfAnchor , C['nUnitframes'].units.target.position.frameParent, C['nUnitframes'].units.target.position.offSetX , C['nUnitframes'].units.target.position.offSetY )
__ta:SetMovable(true)
__ta:SetUserPlaced(true)
__ta:SetClampedToScreen(true)

TARGET_FRAME_UNLOCKED = false
function TargetFrame_SetLocked(locked)
    TARGET_FRAME_UNLOCKED = not locked

    if (locked) then
        if (oUF_Neav_Target) then
            oUF_Neav_Target:RegisterForDrag() 
        end
    else
        if (oUF_Neav_Target) then
            oUF_Neav_Target:RegisterForDrag('LeftButton') 
        end
    end
end

function TargetFrame_ResetUserPlacedPosition()
    if (oUF_Neav_Target) then
        __ta:ClearAllPoints()
        __ta:SetPoint(C['nUnitframes'].units.target.position.selfAnchor , C['nUnitframes'].units.target.position.frameParent, C['nUnitframes'].units.target.position.offSetX , C['nUnitframes'].units.target.position.offSetY )
        TargetFrame_SetLocked(true)
    end
end

UnitPopupMenus['FOCUS'] = { 
    'LOCK_FOCUS_FRAME', 
    'UNLOCK_FOCUS_FRAME', 
    'RAID_TARGET_ICON', 
    'CANCEL' 
}
local __fa = CreateFrame('Frame', 'oUF_Neav_Focus_Anchor', UIParent)
__fa:SetSize(1, 1)
__fa:SetPoint('LEFT', 30, 0)
__fa:SetMovable(true)
__fa:SetUserPlaced(true)
__fa:SetClampedToScreen(true)

local function CreateFocusButton(self)
    self.FTarget = CreateFrame('BUTTON', nil, self, 'SecureActionButtonTemplate')
    self.FTarget:EnableMouse(true)
    self.FTarget:RegisterForClicks('AnyUp')
    self.FTarget:SetAttribute('type', 'macro')
    self.FTarget:SetAttribute('macrotext', '/focus [button:1]\n/clearfocus [button:2]')
    self.FTarget:SetSize(self.T[1]:GetWidth() + 30, self.T[1]:GetHeight() + 2)
    self.FTarget:SetPoint('TOPLEFT', self, (self.T[1]:GetWidth()/5), 17)

    self.FTarget:SetScript('OnMouseDown', function()
        self.T[4]:SetPoint('BOTTOM', self.T[1], -1, 1)
    end)

    self.FTarget:SetScript('OnMouseUp', function()
        self.T[4]:SetPoint('BOTTOM', self.T[1], 0, 2)
    end)

    self.FTarget:SetScript('OnLeave', function()
        self.T:FadeOut(0)
    end)

    self.FTarget:SetScript('OnEnter', function()
        self.T:FadeIn(0.5, 1)
    end)

    self:HookScript('OnLeave', function()
        self.T:FadeOut(0)
    end)

    self:HookScript('OnEnter', function()
        self.T:FadeIn(0.5, 0.65)
    end)
end

local function UpdateThreat(self)
    local _, status, scaledPercent, _, _ = UnitDetailedThreatSituation('player', 'target')

    if (scaledPercent) then
        local red, green, blue = GetThreatStatusColor(status)
        self.NumericalThreat.bg:SetStatusBarColor(red, green, blue)
        self.NumericalThreat.value:SetText(math.ceil(scaledPercent)..'%')
        if (not self.NumericalThreat:IsVisible()) then
            self.NumericalThreat:Show()
        end
    else
        if (self.NumericalThreat:IsVisible()) then
            self.NumericalThreat:Hide()
        end
    end
end

local function PlayerToVehicleTexture(self, event, unit)
    self.Texture:SetSize(240, 121)
    self.Texture:SetPoint('CENTER', self, 0, -8)
    self.Texture:SetTexCoord(0, 1, 0, 1)

    if (UnitVehicleSkin('player') == 'Natural') then
        self.Health:SetSize(103, 9)
        self.Health:SetPoint('TOPLEFT', self.Texture, 100, -54)
        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame-Organic')
    else
        self.Health:SetSize(100, 9)
        self.Health:SetPoint('TOPLEFT', self.Texture, 103, -54)
        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame')
    end

    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 52, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 23, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 23, -12)
    end

    if (self.PvP) then
        self.PvP:SetPoint('TOPLEFT', self.Texture, 3, -28)
    end

    self.Name:SetWidth(100)
    self.Name:SetPoint('CENTER', self.Texture, 30, 23)
    self.Name.Bg:Hide()

    self.Level:Hide()
    self.ThreatGlow:Hide()
    self.LFDRole:SetAlpha(0)

    self.Leader:SetPoint('TOPLEFT', self.Texture, 23, -14)
    self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 74, -14)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -5)
    self.T[1]:SetPoint('BOTTOM', self.Name, 'TOP', 0, 8)
	
	securecall('PlayerFrame_ShowVehicleTexture')
end

local function VehicleToPlayerTexture(self, event, unit)
    self.Health:SetSize(119, 12)
    self.Health:SetPoint('TOPLEFT', self.Texture, 107, -41)

    self.Texture:SetSize(232, 100)
    self.Texture:SetPoint('CENTER', self, -20, -7)
    self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)

    if (C['nUnitframes'].units.player.style == 'NORMAL') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame')
    elseif (C['nUnitframes'].units.player.style == 'RARE') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame-Rare')
    elseif (C['nUnitframes'].units.player.style == 'ELITE') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame-Elite')
    elseif (C['nUnitframes'].units.player.style == 'CUSTOM') then
        self.Texture:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\customFrameTexture')
    end

    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 49, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 42, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 42, -12)
    end

    if (self.PvP) then
        self.PvP:SetPoint('TOPLEFT', self.Texture, 18, -20)
    end

    self.Name:SetWidth(110)
    self.Name:SetPoint('CENTER', self.Texture, 50, 19)
    self.Name.Bg:Show()

    self.Level:Show()
    self.ThreatGlow:Show()
    self.LFDRole:SetAlpha(1)

    self.Leader:SetPoint('TOPLEFT', self.Portrait, 3, 2)
    self.MasterLooter:SetPoint('TOPRIGHT', self.Portrait, -3, 3)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.T[1]:SetPoint('BOTTOM', self.Name.Bg, 'TOP', -1, 0)
	
	securecall('PlayerFrame_HideVehicleTexture')
end

local function CreateTab(self, text)
    self.T = {}

    for i = 1, 3 do
        self.T[i] = self:CreateTexture(nil, 'BACKGROUND')
        self.T[i]:SetTexture(charTexPath..'UI-CharacterFrame-GroupIndicator')
        self.T[i]:SetTexCoord(unpack(tabCoordTable[i]))
        self.T[i]:SetSize(24, 18)
        self.T[i]:SetAlpha(0.5)
    end

    self.T[1]:SetPoint('BOTTOM', self.Name.Bg, 'TOP', 0, 1)
    self.T[2]:SetPoint('LEFT', self.T[1], 'RIGHT')
    self.T[3]:SetPoint('RIGHT', self.T[1], 'LEFT')

    self.T[4] = self:CreateFontString(nil, 'OVERLAY')
    self.T[4]:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize - 1)
    self.T[4]:SetShadowOffset(1, -1)
    self.T[4]:SetPoint('BOTTOM', self.T[1], 0, 2)
    self.T[4]:SetAlpha(0.5)

    self.T.Text = function(_, text)
        self.T[4]:SetText(text)
        self.T[1]:SetWidth(self.T[4]:GetWidth() > 50 and (self.T[4]:GetWidth() - 6) or self.T[4]:GetWidth())
    end

    self.T.FadeIn = function(_, alpha, alpha2)
        for i = 1, 3 do
            securecall('UIFrameFadeIn', self.T[i], 0.15, self.T[i]:GetAlpha(), alpha)
            securecall('UIFrameFadeIn', self.T[4], 0.15, self.T[4]:GetAlpha(), alpha2 or alpha)
        end
    end

    self.T.FadeOut = function(_, alpha, alpha2)
        for i = 1, 3 do
            securecall('UIFrameFadeOut', self.T[i], 0.15, self.T[i]:GetAlpha(), alpha)
            securecall('UIFrameFadeOut', self.T[4], 0.15, self.T[4]:GetAlpha(), alpha2 or alpha)
        end
    end

    self.T:Text(text)
end

local function UpdateFlashStatus(self)
    if (UnitHasVehicleUI('player') or UnitIsDeadOrGhost('player')) then
        N.StopFlash(self.StatusFlash)
        return
    end

    if (UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.1, 0.1, 1)

        if (not N.IsFlashing(self.StatusFlash)) then
            N.StartFlash(self.StatusFlash, 0.5, 0.5, 0.1, 0.1)
        end
    elseif (IsResting() and not UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.88, 0.25, 1)

        if (not N.IsFlashing(self.StatusFlash)) then
            N.StartFlash(self.StatusFlash, 0.5, 0.5, 0.1, 0.1)
        end
    else
        N.StopFlash(self.StatusFlash)
    end
end

local function CheckVehicleStatus(self, event, unit)
    if (UnitHasVehicleUI('player')) then
        PlayerToVehicleTexture(self, event, unit)
    else
        VehicleToPlayerTexture(self, event, unit)
    end

    if (self.StatusFlash) then
        UpdateFlashStatus(self)
    end
end

    -- Update target and focus texture

local function UpdateClassPortraits(self, unit)
    local _, unitClass = UnitClass(unit)
    if (unitClass and UnitIsPlayer(unit)) then
        self:SetTexture(tarTexPath..'UI-Classes-Circles')
        self:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]))
    else
        self:SetTexCoord(0, 1, 0, 1)
    end
end

local function EnableMouseOver(self)
    self.Health.Value:Hide()

    if (self.Power and self.Power.Value) then
        self.Power.Value:Hide()
    end

    if (self.DruidMana and self.DruidMana.Value) then
        self.DruidMana.Value:Hide()
    end

    self:HookScript('OnEnter', function(self)
        self.Health.Value:Show()

        if (self.Power and self.Power.Value) then
            self.Power.Value:Show()
        end

        if (self.DruidMana and self.DruidMana.Value) then
            self.DruidMana.Value:Show()
        end
    end)

    self:HookScript('OnLeave', function(self)
        self.Health.Value:Hide()

        if (self.Power and self.Power.Value) then
            self.Power.Value:Hide()
        end

        if (self.DruidMana and self.DruidMana.Value) then
            self.DruidMana.Value:Hide()
        end
    end)
end

local function UpdatePortraitColor(self, unit, min, max)
    if (not UnitIsConnected(unit)) then
        self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
    elseif (UnitIsDead(unit)) then
        self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
    elseif (UnitIsGhost(unit)) then
        self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
    elseif (max == 0 or min/max * 100 < 25) then
        if (UnitIsPlayer(unit)) then
            if (unit ~= 'player') then
                self.Portrait:SetVertexColor(1, 0, 0, 0.7)
            end
        end
    else
        self.Portrait:SetVertexColor(1, 1, 1, 1)
    end
end

local function UpdateHealth(Health, unit, cur, max)
    local self = Health:GetParent()
    if (not self.Portrait.Bg) then
        UpdatePortraitColor(self, unit, cur, max)
    end

    if (self.Portrait.Bg) then
        self.Portrait.Bg:SetVertexColor(UnitSelectionColor(unit))
    end

    if (unit == 'target' or unit == 'focus') then
        if (self.Name.Bg) then
            self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
        end
    end

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end

    Health.Value:SetText(N.GetHealthText(unit, cur, max))
end

local function UpdatePower(Power, unit, cur, max)
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
    end

    Power.Value:SetText(N.GetPowerText(unit, cur, max))
end

local function CreateUnitLayout(self, unit)
    self.IsMainFrame = N.MultiCheck(unit, 'player', 'target', 'focus')
    self.IsTargetFrame = N.MultiCheck(unit, 'targettarget', 'focustarget')
    self.IsPartyFrame = unit:match('party')

    if (self.IsTargetFrame) then
        self:SetFrameLevel(30)
    end

    self:RegisterForClicks('AnyUp')
    self.menu = CreateDropDown
    self:SetAttribute('*type2', 'menu')

    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)

    if (C['nUnitframes'].units.focus.enableFocusToggleKeybind) then
        if (unit == 'focus') then
            self:SetAttribute(C['nUnitframes'].units.focus.focusToggleKey, 'macro')
            self:SetAttribute('macrotext', '/clearfocus')
        else
            self:SetAttribute(C['nUnitframes'].units.focus.focusToggleKey, 'focus')
        end
    end
        -- Create the castbars

    if (C['nUnitframes'].show.castbars) then
        N.CreateCastbars(self, unit)
    end

        -- Texture

    self.Texture = self:CreateTexture(nil, 'BORDER')

    if (self.IsTargetFrame) then
        self.Texture:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\customTargetTargetTexture_2')
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('CENTER', self, 16, -10)
    elseif (unit == 'pet') then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture(tarTexPath..'UI-SmallTargetingFrame')
        self.Texture.SetTexture = function() end
    elseif (unit == 'target' or unit == 'focus') then
        self.Texture:SetSize(230, 100)
        self.Texture:SetPoint('CENTER', self, 20, -7)
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame')
        self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    elseif (self.IsPartyFrame) then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture(tarTexPath..'UI-PartyFrame')
    end

        -- Healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    if (unit == 'player') then
        self.Health:SetSize(119, 12)
    elseif (unit == 'pet') then
        self.Health:SetSize(70, 9)
        self.Health:SetPoint('TOPLEFT', self.Texture, 45, -20)
    elseif (unit == 'target' or unit == 'focus') then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -41)
    elseif (self.IsTargetFrame) then
        self.Health:SetSize(46, 9)
        self.Health:SetPoint('CENTER', self, 18, 4)
    elseif (self.IsPartyFrame) then   
        self.Health:SetPoint('TOPLEFT', self.Texture, 47, -12)
        self.Health:SetSize(70, 7) 
    end

        -- Heal prediction, new healcomm

    local myBar = CreateFrame('StatusBar', nil, self)
    myBar:SetFrameLevel(self:GetFrameLevel() - 1)
    myBar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture', 'OVERLAY')
    myBar:SetStatusBarColor(0, 1, 0.3, 0.5)

    myBar.Smooth = true

    myBar:SetOrientation('HORIZONTAL')
    myBar:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT')
    myBar:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
    myBar:SetWidth(self.Health:GetWidth())

    local otherBar = CreateFrame('StatusBar', nil, self)
    otherBar:SetFrameLevel(self:GetFrameLevel() - 1)
    otherBar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture', 'OVERLAY')
    otherBar:SetStatusBarColor(0, 1, 0, 0.35)

    otherBar.Smooth = true

    otherBar:SetOrientation('HORIZONTAL')
    otherBar:SetPoint('TOPLEFT', myBar:GetStatusBarTexture(), 'TOPRIGHT')
    otherBar:SetPoint('BOTTOMLEFT', myBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
    otherBar:SetWidth(self.Health:GetWidth())

    self.HealPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        maxOverflow = 1.0,
    }
	
		-- Health text

    self.Health.Value = self:CreateFontString(nil, 'OVERLAY')
    self.Health.Value:SetShadowOffset(1, -1)

    if (self.IsTargetFrame) then
        self.Health.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize - 2)
        self.Health.Value:SetPoint('CENTER', self.Health, 'BOTTOM', -4, 1)
    else
        self.Health.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
        self.Health.Value:SetPoint('CENTER', self.Health, 1, 1)
    end

        -- Powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
    self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Power:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Power:SetBackdropColor(0, 0, 0, 0.55)

    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true
    
    if (self.IsTargetFrame) then
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', -8, 0)
        self.Power:SetHeight(self.Health:GetHeight() - 2)
    else
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, 0)
        self.Power:SetHeight(self.Health:GetHeight() - 1)
    end

        -- Power text

    if (not self.IsTargetFrame) then
        self.Power.Value = self:CreateFontString(nil, 'OVERLAY')
        self.Power.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 0)

        self.Power.PostUpdate = UpdatePower
    end

        -- Name

    self.Name = self:CreateFontString(nil, 'OVERLAY')
    self.Name:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalBigSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH('CENTER')
    self.Name:SetHeight(10)

    self:Tag(self.Name, '[name]')

    if (unit == 'pet') then
        self.Name:SetWidth(90)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 1, 4)
    elseif (unit == 'target' or unit == 'focus') then
        self.Name:SetWidth(110)
        self.Name:SetPoint('CENTER', self, 'CENTER', -30, 12)
    elseif (self.IsTargetFrame) then
        self.Name:SetWidth(65)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('TOPLEFT', self, 'CENTER', -4, -11)
    elseif (self.IsPartyFrame) then    
        self.Name:SetJustifyH('CENTER')
        self.Name:SetHeight(10)
        self.Name:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
    end

        -- Level

    if (self.IsMainFrame) then
        self.Level = self:CreateFontString(nil, 'ARTWORK')
        self.Level:SetFont(C['nMedia'].font, 17, 'THINOUTLINE')
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint('CENTER', self.Texture, (unit == 'player' and -63) or 63, -16)
        self:Tag(self.Level, '[level]')
    end

        -- Portrait

    if (C['nUnitframes'].show.threeDPortraits) then    
        self.Portrait = CreateFrame('PlayerModel', nil, self)
        self.Portrait:SetFrameStrata('BACKGROUND')

        self.Portrait.Bg = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.Portrait.Bg:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\portraitBackground')
        self.Portrait.Bg:SetParent(self.Portrait)

        if (unit == 'player') then
            self.Portrait:SetSize(50, 50)
            self.Portrait.Bg:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)

            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(50, 50)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -50, -19)

            self.Portrait.Bg:SetSize(64, 64)
            self.Portrait.Bg:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -38, -1)

            self.Portrait.Bg:SetSize(40, 40)
            self.Portrait.Bg:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 9, -8)

            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end
    else
        self.Portrait = self.Health:CreateTexture('$parentPortrait', 'BACKGROUND')

        if (unit == 'player') then
            self.Portrait:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(64, 64)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(40, 40)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end

        if (C['nUnitframes'].show.classPortraits) then
            self.Portrait.PostUpdate = UpdateClassPortraits
        end
    end

        -- Portrait timer

    if (C['nUnitframes'].show.portraitTimer) then
        self.PortraitTimer = CreateFrame('Frame', nil, self.Health)

        self.PortraitTimer.Icon = self.PortraitTimer:CreateTexture(nil, 'BACKGROUND')
        self.PortraitTimer.Icon:SetAllPoints(self.Portrait.Bg or self.Portrait)

        self.PortraitTimer.Remaining = self.PortraitTimer:CreateFontString(nil, 'OVERLAY')
        self.PortraitTimer.Remaining:SetPoint('CENTER', self.PortraitTimer.Icon) 
        self.PortraitTimer.Remaining:SetFont(C['nMedia'].font, (self.Portrait:GetWidth()/3.5), 'THINOUTLINE')
        self.PortraitTimer.Remaining:SetTextColor(1, 1, 1)
    end

        -- Pvp icons

    if (C['nUnitframes'].show.pvpicons) then
        self.PvP = self:CreateTexture(nil, 'OVERLAY')

        if (unit == 'player') then
            self.PvP:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.PvP:SetSize(50, 50)
            self.PvP:SetPoint('CENTER', self.Portrait, 'LEFT', 7, -7)
        elseif (unit == 'target' or unit == 'focus') then
            self.PvP:SetSize(64, 64)
            self.PvP:SetPoint('TOPRIGHT', self.Texture, 3, -20)
        elseif (self.IsPartyFrame) then
            self.PvP:SetSize(40, 40)
            self.PvP:SetPoint('TOPLEFT', self.Texture, -9, -10)
        end
    end

        -- Masterlooter icon

    self.MasterLooter = self:CreateTexture(nil, 'OVERLAY')
    self.MasterLooter:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.MasterLooter:SetPoint('TOPLEFT', self.Portrait, 3, 3)
    elseif (self.IsTargetFrame) then
        self.MasterLooter:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 3, -3)
    elseif (self.IsPartyFrame) then  
        self.MasterLooter:SetSize(14, 14)
        self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 29, 0)
    end

        -- Groupleader icon

    self.Leader = self:CreateTexture(nil, 'OVERLAY')
    self.Leader:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.Leader:SetPoint('TOPRIGHT', self.Portrait, -3, 2)
    elseif (self.IsTargetFrame) then
        self.Leader:SetPoint('TOPLEFT', self.Portrait, -3, 4)
    elseif (self.IsPartyFrame) then
        self.Leader:SetSize(14, 14)
        self.Leader:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 1, -1)
    end

        -- Raidicons

    self.RaidIcon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.RaidIcon:SetTexture(tarTexPath..'UI-RaidTargetingIcons')
    local s1 = (self.Portrait.Bg and self.Portrait.Bg:GetSize() / 3) or (self.Portrait:GetSize() / 3)
    self.RaidIcon:SetSize(s1, s1)

        -- Phase icon
    
    if (not IsTargetFrame) then
        self.PhaseIcon = self:CreateTexture(nil, 'OVERLAY')
        self.PhaseIcon:SetPoint('CENTER', self.Portrait, 'BOTTOM')
        
        if (self.IsMainFrame) then
            self.PhaseIcon:SetSize(26, 26)
        else
            self.PhaseIcon:SetSize(18, 18)
        end
    end

        -- Offline icons

    self.OfflineIcon = self:CreateTexture(nil, 'OVERLAY')
    self.OfflineIcon:SetPoint('TOPRIGHT', self.Portrait, 7, 7)
    self.OfflineIcon:SetPoint('BOTTOMLEFT', self.Portrait, -7, -7)

        -- Ready check icons

    if (unit == 'player' or self.IsPartyFrame) then
        self.ReadyCheck = self:CreateTexture(nil, 'OVERLAY')
        self.ReadyCheck:SetPoint('TOPRIGHT', self.Portrait, -7, -7)
        self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Portrait, 7, 7)
        self.ReadyCheck.delayTime = 2
        self.ReadyCheck.fadeTime = 0.5
    end

        -- Threat textures

    self.ThreatGlow = self:CreateTexture(nil, 'BACKGROUND')
	
	if C['nUnitframes'].units.showThreat == true then
		if (unit == 'player') then
			self.ThreatGlow:SetSize(241, 92)
			self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, 14, 0)
			self.ThreatGlow:SetTexture(tarTexPath..'UI-TargetingFrame-Flash')
			self.ThreatGlow:SetTexCoord(0.9453125, 0, 0 , 0.182)
		elseif (unit == 'pet') then
			self.ThreatGlow:SetSize(129, 64)
			self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -5, 13)
			self.ThreatGlow:SetTexture(tarTexPath..'UI-PartyFrame-Flash')
			self.ThreatGlow:SetTexCoord(0, 1, 1, 0)
		elseif (unit == 'target' or unit == 'focus') then
			self.ThreatGlow:SetSize(239, 92)
			self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -23, 0)
			self.ThreatGlow:SetTexture(tarTexPath..'UI-TargetingFrame-Flash')
			self.ThreatGlow:SetTexCoord(0, 0.9453125, 0, 0.182)
		elseif (self.IsPartyFrame) then
			self.ThreatGlow:SetSize(128, 63)
			self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -3, 4)
			self.ThreatGlow:SetTexture(tarTexPath..'UI-PartyFrame-Flash')
		end
	end

        -- Lfd role icon

    if (self.IsPartyFrame or unit == 'player' or unit == 'target') then
        self.LFDRole = self:CreateTexture(nil, 'ARTWORK')
        self.LFDRole:SetSize(20, 20)

        if (unit == 'player') then
            self.LFDRole:SetPoint('BOTTOMRIGHT', self.Portrait, -2, -3)
        elseif (unit == 'target') then
            self.LFDRole:SetPoint('TOPLEFT', self.Portrait, -10, -2)
        else
            self.LFDRole:SetPoint('BOTTOMLEFT', self.Portrait, -5, -5)
        end
    end

        -- Playerframe

    if (unit == 'player') then
        self:SetSize(175, 42)

        self.Name.Bg = self:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Name.Bg:SetVertexColor(0, 0, 0, 0.55)

            -- Warlock soulshard bar

        if (playerClass == 'WARLOCK') then
            WarlockPowerFrame:SetParent(oUF_Neav_Player)
            WarlockPowerFrame:SetScale(C['nUnitframes'].units.player.scale * 0.8)
            WarlockPowerFrame_OnLoad(WarlockPowerFrame)
            WarlockPowerFrame:SetFrameLevel(1)

            ShardBarFrame:SetScale(C['nUnitframes'].units.player.scale * 0.8)
            ShardBarFrame:ClearAllPoints()
            ShardBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, -2)

            BurningEmbersBarFrame:SetScale(C['nUnitframes'].units.player.scale * 0.8)
            BurningEmbersBarFrame:ClearAllPoints()
            BurningEmbersBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 0)

            DemonicFuryBarFrame:SetScale(C['nUnitframes'].units.player.scale * 0.8)
            DemonicFuryBarFrame:ClearAllPoints()
            DemonicFuryBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 35, 12)
        end
		
            -- Priest bar

        if (playerClass == 'PRIEST') then
            PriestBarFrame:SetParent(oUF_Neav_Player)
            PriestBarFrame_OnLoad(PriestBarFrame)
            PriestBarFrame:ClearAllPoints()
            PriestBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 33, 0)
        end		

            -- Holy power bar

        if (playerClass == 'PALADIN') then
            PaladinPowerBar:SetParent(oUF_Neav_Player)
            PaladinPowerBar:SetScale(C['nUnitframes'].units.player.scale * 0.81)
            PaladinPowerBar_OnLoad(PaladinPowerBar)
            PaladinPowerBar:ClearAllPoints()
            PaladinPowerBar:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 25, 2)
            PaladinPowerBar:Show()
        end
		
            -- Monk harmony bar

        if (playerClass == 'MONK') then
            MonkHarmonyBar:SetParent(oUF_Neav_Player)
            MonkHarmonyBar:SetScale(C['nUnitframes'].units.player.scale * 0.81)
            MonkHarmonyBar_OnLoad(MonkHarmonyBar)
            MonkHarmonyBar:ClearAllPoints()
            MonkHarmonyBar:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 18)
        end		

            -- Deathknight runebar

        if (playerClass == 'DEATHKNIGHT') then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetPoint('TOP', self.Power, 'BOTTOM', 2, -2)
            RuneFrame:SetParent(self)
        end

        if (playerClass == 'SHAMAN') then
            TotemFrame:ClearAllPoints()
            TotemFrame:SetPoint('TOP', self.Power, 'BOTTOM', -2, -0)
            TotemFrame:SetParent(oUF_Neav_Player)
            TotemFrame:SetScale(C['nUnitframes'].units.player.scale * 0.65)
            TotemFrame:Show()

            for i = 1, MAX_TOTEMS do
                _G['TotemFrameTotem'..i]:SetFrameStrata('LOW')

                _G['TotemFrameTotem'..i..'IconCooldown']:SetAlpha(0)

                _G['TotemFrameTotem'..i..'Duration']:SetParent(self)
                _G['TotemFrameTotem'..i..'Duration']:SetDrawLayer('OVERLAY')
                _G['TotemFrameTotem'..i..'Duration']:ClearAllPoints()
                _G['TotemFrameTotem'..i..'Duration']:SetPoint('BOTTOM', _G['TotemFrameTotem'..i], 0, 3)
                _G['TotemFrameTotem'..i..'Duration']:SetFont(C['nMedia'].font, 10, 'OUTLINE')
                _G['TotemFrameTotem'..i..'Duration']:SetShadowOffset(0, 0)
            end
        end

        if (playerClass == 'DRUID') then

                -- Druid eclipse bar

            EclipseBarFrame:SetParent(oUF_Neav_Player)
            EclipseBarFrame:SetScale(C['nUnitframes'].units.player.scale * 0.82)
            EclipseBar_OnLoad(EclipseBarFrame)
            EclipseBarFrame:ClearAllPoints()
            EclipseBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 3)
            EclipseBarFrame:Show()

                -- Druid mushroom timer

            TotemFrame:ClearAllPoints()
            TotemFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 50, 20)
            TotemFrame:SetParent(oUF_Neav_Player)
            TotemFrame:SetScale(C['nUnitframes'].units.player.scale * 0.65)
            TotemFrame:Show()

            for i = 1, 3 do
                _G['TotemFrameTotem'..i]:EnableMouse(false)
                _G['TotemFrameTotem'..i]:SetAlpha(0)
                _G['TotemFrameTotem'..i..'Duration']:SetParent(self)
                _G['TotemFrameTotem'..i..'Duration']:SetDrawLayer('OVERLAY')
                _G['TotemFrameTotem'..i..'Duration']:SetFont(C['nMedia'].font, 12)
                _G['TotemFrameTotem'..i..'Duration']:SetTextColor(0.3, 1, 0)
                -- _G['TotemFrameTotem'..i..'Duration']:SetTextColor(0.3, 1, 0)
                -- _G['TotemFrameTotem'..i..'Duration']:SetAlpha(0.75)
            end

            TotemFrameTotem3Duration:ClearAllPoints()
            TotemFrameTotem3Duration:SetPoint('LEFT', TotemFrameTotem2Duration, 'RIGHT', 5, 0)

            TotemFrameTotem1Duration:ClearAllPoints()
            TotemFrameTotem1Duration:SetPoint('RIGHT', TotemFrameTotem2Duration, 'LEFT', -6, 0)

                -- Druid powerbar

            self.DruidMana = CreateFrame('StatusBar', nil, self)
            self.DruidMana:SetPoint('TOP', self.Power, 'BOTTOM', 0, -1)
            self.DruidMana:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture', 'BORDER')
            self.DruidMana:SetSize(99, 9)
            self.DruidMana:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
            self.DruidMana:SetBackdropColor(0, 0, 0, 0.55)
            self.DruidMana.colorPower = true

            self.DruidMana.Value = self.DruidMana:CreateFontString(nil, 'OVERLAY')
            self.DruidMana.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
            self.DruidMana.Value:SetShadowOffset(1, -1)
            self.DruidMana.Value:SetPoint('CENTER', self.DruidMana, 0, 0.5)

            self:Tag(self.DruidMana.Value, '[druidmana]')
            
            self.DruidMana.Texture = self.DruidMana:CreateTexture(nil, 'ARTWORK')
            self.DruidMana.Texture:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\druidmanaTexture')
            self.DruidMana.Texture:SetSize(104, 28)
            self.DruidMana.Texture:SetPoint('TOP', self.Power, 'BOTTOM', 0, 6)

            local function MoveShrooms(self)
                if (EclipseBarFrame:IsVisible()) then
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -27)
                elseif (self.DruidMana:IsVisible()) then
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -15)
                else
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
                end
            end 

                -- Move the shroomtimer if the eclipsebar or druid manabar is shown

            self.DruidMana:HookScript('OnHide', function()
                MoveShrooms(self)
            end)

            self.DruidMana:HookScript('OnShow', function()
                MoveShrooms(self)
            end)

            EclipseBarFrame:SetScript('OnHide', function()
                MoveShrooms(self)
            end)

            EclipseBarFrame:SetScript('OnShow', function()
                MoveShrooms(self)
            end)

            MoveShrooms(self)
        end

            -- Raidgroup indicator

        local function UpdatePartyTab(self)
            for i = 1, MAX_RAID_MEMBERS do
                if (GetNumGroupMembers() > 0) then
                    local unitName, _, groupNumber = GetRaidRosterInfo(i)
                    if (unitName == UnitName('player')) then
                        self.T:FadeIn(0.5, 0.65)
                        self.T:Text(GROUP..' '..groupNumber)
                    end
                else
                    self.T:FadeOut(0)
                end
            end
        end

        CreateTab(self)
        UpdatePartyTab(self) 

		self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdatePartyTab)

            -- Resting/combat status flashing

        if (C['nUnitframes'].units.player.showStatusFlash) then
            self.StatusFlash = self:CreateTexture(nil, 'ARTWORK')
            self.StatusFlash:SetTexture(charTexPath..'UI-Player-Status')
            self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
            self.StatusFlash:SetBlendMode('ADD')
            self.StatusFlash:SetSize(192, 66)
            self.StatusFlash:SetPoint('TOPLEFT', self.Texture, 35, -8)
            self.StatusFlash:SetAlpha(0)

            UpdateFlashStatus(self, _, unit) 

            self:RegisterEvent('PLAYER_DEAD', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UNGHOST', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_ALIVE', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UPDATE_RESTING', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateFlashStatus)
        end

            -- Pvptimer

        if (self.PvP) then
            self.PvPTimer = self:CreateFontString(nil, 'OVERLAY')
            self.PvPTimer:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint('BOTTOM', self.PvP, 'TOP', -12, -3   )
            self.PvPTimer.frequentUpdates = 0.5
            self:Tag(self.PvPTimer, '[pvptimer]')
        end

            -- oUF_Swing support 

        if (C['nUnitframes'].units.player.showSwingTimer) then
            self.Swing = CreateFrame('Frame', nil, self)
            self.Swing:SetFrameStrata('LOW')
            -- self.Swing:SetSize(200, 7)
            self.Swing:SetHeight(7)
            self.Swing:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Swing:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Swing:Hide()

            self.Swing.texture = 'Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture'
            self.Swing.color = {0, 0.8, 1, 1}

            self.Swing.textureBG = 'Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture'
            self.Swing.colorBG = {0, 0, 0, 0.55}

            self.Swing:CreateBeautyBorder(12)
            self.Swing:SetBeautyBorderPadding(3)
			self.Swing:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				self.Swing:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				self.Swing:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				self.Swing:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end

            self.Swing.f = CreateFrame('Frame', nil, self.Swing)
            self.Swing.f:SetFrameStrata('HIGH')       

            self.Swing.Text = self.Swing.f:CreateFontString(nil, 'OVERLAY')
            self.Swing.Text:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
            self.Swing.Text:SetPoint('CENTER', self.Swing)

            self.Swing.disableMelee = false
            self.Swing.disableRanged = false
            self.Swing.hideOoc = true
        end

            -- oUF_Vengeance support 

        if (C['nUnitframes'].units.player.showVengeance) then
            self.Vengeance = CreateFrame('StatusBar', nil, self)
            self.Vengeance:SetHeight(7)
            self.Vengeance:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Vengeance:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Vengeance:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
            self.Vengeance:SetStatusBarColor(1, 0, 0)

            self.Vengeance:CreateBeautyBorder(12)
            self.Vengeance:SetBeautyBorderPadding(3)
			self.Vengeance:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				self.Vengeance:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				self.Vengeance:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				self.Vengeance:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end

            self.Vengeance.Bg = self.Vengeance:CreateTexture(nil, 'BACKGROUND')
            self.Vengeance.Bg:SetAllPoints(self.Vengeance)
            self.Vengeance.Bg:SetTexture(0, 0, 0, 0.55)

            self.Vengeance.Text = self.Vengeance:CreateFontString(nil, 'OVERLAY')
            self.Vengeance.Text:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
            self.Vengeance.Text:SetPoint('CENTER', self.Vengeance)
        end

            -- Combat text

        if (C['nUnitframes'].units.player.showCombatFeedback) then
            self.CombatFeedbackText = self:CreateFontString(nil, 'OVERLAY')
            self.CombatFeedbackText:SetFont(C['nMedia'].font, 18, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end

            -- Combat icon

        self.Combat = self:CreateTexture(nil, 'OVERLAY')
        self.Combat:SetPoint('CENTER', self.Level, 1, 0)
        self.Combat:SetSize(31, 33)

           -- Resting icon

        self.Resting = self:CreateTexture(nil, 'OVERLAY')
        self.Resting:SetPoint('CENTER', self.Level, -0.5, 0)
        self.Resting:SetSize(31, 34)

            -- Player frame vehicle/normal update

        CheckVehicleStatus(self, _, unit)

        self:RegisterEvent('UNIT_ENTERED_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITED_VEHICLE', CheckVehicleStatus)
    end

        -- Petframe

    if (unit == 'pet') then
        self:SetSize(175, 42)


        if (not C['nUnitframes'].units[N.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs.size = 20
            self.Debuffs:SetWidth(self.Debuffs.size * 4)
            self.Debuffs:SetHeight(self.Debuffs.size)
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 1, -3)
            self.Debuffs.initialAnchor = 'TOPLEFT'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs.num = 9
        end
    end

        -- Target + focusframe

    if (unit == 'target' or unit == 'focus') then
        self:SetSize(175, 42)

            -- Colored name background

        self.Name.Bg = self:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\nameBackground')

            -- Combat feedback text

        if (C['nUnitframes'].units.target.showCombatFeedback or C['nUnitframes'].units.focus.showCombatFeedback) then
            self.CombatFeedbackText = self:CreateFontString(nil, 'OVERLAY')
            self.CombatFeedbackText:SetFont(C['nMedia'].font, 18, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end

            -- Questmob icon

        self.QuestIcon = self:CreateTexture(nil, 'OVERLAY')
        self.QuestIcon:SetSize(32, 32)
        self.QuestIcon:SetPoint('CENTER', self.Health, 'TOPRIGHT', 1, 10)

        table.insert(self.__elements, function(self, _, unit)
            self.Texture:SetTexture(texTable[UnitClassification(unit)] or texTable['normal'])
        end)
    end

    if (unit == 'target') then
        CreateTab(self, SET_FOCUS)
        CreateFocusButton(self)

        self.T:FadeOut(0)

            -- combo point stuff

        if (C['nUnitframes'].units.target.showComboPoints) then

                -- owl rotater

            local h = CreateFrame('Frame', nil, self.Health)
            h:SetSize(55, 55)
            h:SetPoint('CENTER', self.Portrait.Bg or self.Portrait, 0, -0.5)
            h:SetAlpha(0.8)

            h.Texture = h:CreateTexture(nil, 'BACKGROUND')
            h.Texture:SetAllPoints(h)
            h.Texture:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\owlRotater')
            h.Texture:SetBlendMode('BLEND')
            h.Texture.minAlpha = 0.25
            h.Texture:SetAlpha(0)

            local rotate = h.Texture:CreateAnimationGroup()
            rotate:SetLooping('REPEAT')

            local path = rotate:CreateAnimation('Rotation')
            path:SetDegrees(-360)
            path:SetDuration(9)

            if (C['nUnitframes'].units.target.showComboPointsAsNumber) then
                self.ComboPoints = self:CreateFontString(nil, 'OVERLAY')
                self.ComboPoints:SetFont(DAMAGE_TEXT_FONT, 26, 'OUTLINE')
                self.ComboPoints:SetShadowOffset(0, 0)
                self.ComboPoints:SetPoint('LEFT', self.Portrait, 'RIGHT', 8, 4)
                self.ComboPoints:SetTextColor(unpack(C['nUnitframes'].units.target.numComboPointsColor))
                self:Tag(self.ComboPoints, '[combopoints]')
            else
                self.CPoints = {}

                for i = 1, 5 do
                    self.CPoints[i] = self:CreateTexture(nil, 'OVERLAY')
                    self.CPoints[i]:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\comboPoint')
                    self.CPoints[i]:SetSize(15, 15)
                end

                self.CPoints[1]:SetPoint('TOPRIGHT', self.Texture, -42, -8)
                self.CPoints[2]:SetPoint('TOP', self.CPoints[1], 'BOTTOM', 7.33, 6.66)
                self.CPoints[3]:SetPoint('TOP', self.CPoints[2], 'BOTTOM', 4.66, 4.33)
                self.CPoints[4]:SetPoint('TOP', self.CPoints[3], 'BOTTOM', 1.33 , 3.66)
                self.CPoints[5]:SetPoint('TOP', self.CPoints[4], 'BOTTOM', -1.66, 3.66)
                
                self.CPointsBG = {}
                for i = 1, 5 do
                    self.CPointsBG[i] = self:CreateTexture(nil, 'ARTWORK')
                    self.CPointsBG[i]:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\comboPointBackground')
                    self.CPointsBG[i]:SetSize(15, 15)
                    self.CPointsBG[i]:SetAllPoints(self.CPoints[i])
                    self.CPointsBG[i]:SetAlpha(0)
                end

                hooksecurefunc(self.CPoints[1], 'Show', function()
                    for i = 1, 5 do
                        securecall('UIFrameFadeIn', self.CPointsBG[i], 0.25, self.CPointsBG[i]:GetAlpha(), 0.9)
                    end
                end)

                hooksecurefunc(self.CPoints[1], 'Hide', function()
                    for i = 1, 5 do
                        self.CPointsBG[i]:SetAlpha(0)
                    end
                end)

                hooksecurefunc(self.CPoints[5], 'Show', function()
                    rotate:Play()
                    N.StartFlash(h.Texture, 0.4, 0.4, 0, 0)
                end)

                hooksecurefunc(self.CPoints[5], 'Hide', function()
                    rotate:Stop()
                    N.StopFlash(h.Texture)
                end)
            end
        end

        if (not C['nUnitframes'].units[N.cUnit(unit)].disableAura) then
            self.Auras = CreateFrame('Frame', nil, self)
            self.Auras.gap = true
            self.Auras.size = 20
            self.Auras:SetHeight(self.Auras.size * 3)
            self.Auras:SetWidth(self.Auras.size * 5)
            self.Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -5)
            self.Auras.initialAnchor = 'TOPLEFT'
            self.Auras['growth-x'] = 'RIGHT'
            self.Auras['growth-y'] = 'DOWN'
            self.Auras.numBuffs = C['nUnitframes'].units.target.numBuffs
            self.Auras.numDebuffs = C['nUnitframes'].units.target.numDebuffs
            self.Auras.spacing = 4.5
			self.Auras.customBreak = true
        end
		
        if (C['nUnitframes'].units.target.showThreatValue) then
            self.NumericalThreat = CreateFrame('Frame', nil, self)
            self.NumericalThreat:SetSize(49, 18)
            self.NumericalThreat:SetPoint('BOTTOM', self, 'TOP', 0, 0)
            self.NumericalThreat:Hide()

            self.NumericalThreat.value = self.NumericalThreat:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
            self.NumericalThreat.value:SetPoint('TOP', 0, -4)

            self.NumericalThreat.bg = CreateFrame('StatusBar', nil, self.NumericalThreat)
            self.NumericalThreat.bg:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
            self.NumericalThreat.bg:SetFrameStrata('LOW')
            self.NumericalThreat.bg:SetPoint('TOP', 0, -3)
            self.NumericalThreat.bg:SetSize(37, 14)

            self.NumericalThreat.texture = self.NumericalThreat:CreateTexture(nil, 'ARTWORK')
            self.NumericalThreat.texture:SetPoint('TOP', 0, 0)
            self.NumericalThreat.texture:SetTexture('Interface\\TargetingFrame\\NumericThreatBorder')
            self.NumericalThreat.texture:SetTexCoord(0, 0.765625, 0, 0.5625)
            self.NumericalThreat.texture:SetSize(49, 18)

            self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
            self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
            self:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateThreat)
            self:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateThreat)
            self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
        end		
    end

    if (unit == 'focus') then
        CreateTab(self, FOCUS)

        self.T[4]:SetPoint('BOTTOM', self.T[1], -4, 2)
        self.T[1]:SetWidth(self.T[4]:GetWidth() + 4)

        self.FClose = CreateFrame('Button', nil, self, 'SecureActionButtonTemplate')
        self.FClose:EnableMouse(true)
        self.FClose:RegisterForClicks('AnyUp')
        self.FClose:SetAttribute('type', 'macro')
        self.FClose:SetAttribute('macrotext', '/clearfocus')
        self.FClose:SetSize(20, 20)
        self.FClose:SetAlpha(0.65)
        self.FClose:SetPoint('TOPLEFT', self, (56 + (self.T[1]:GetWidth()/2)), 17)
        self.FClose:SetNormalTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Up')
        self.FClose:SetPushedTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Down')
        self.FClose:SetHighlightTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight')
        self.FClose:GetHighlightTexture():SetBlendMode('ADD')

        self.FClose:SetScript('OnLeave', function()
            securecall('UIFrameFadeOut', self.T[4], 0.15, self.T[4]:GetAlpha(), 0.5)
        end)

        self.FClose:SetScript('OnEnter', function()
            securecall('UIFrameFadeIn', self.T[4], 0.15, self.T[4]:GetAlpha(), 1)
        end)

        if (not C['nUnitframes'].units[N.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs.size = 26
            self.Debuffs:SetHeight(self.Debuffs.size * 3)
            self.Debuffs:SetWidth(self.Debuffs.size * 3)
            self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -5)
            self.Debuffs.initialAnchor = 'TOPLEFT'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs.num = C['nUnitframes'].units.focus.numDebuffs
            self.Debuffs.spacing = 4
        end
    end

    if (self.IsTargetFrame) then
        self:SetSize(85, 20)

        if (not C['nUnitframes'].units[N.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 7, 0)
            self.Debuffs.initialAnchor = 'LEFT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs.num = 4
        end
    end

    if (self.IsPartyFrame) then
        self:SetSize(105, 30)

        if (not C['nUnitframes'].units[N.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs:SetFrameStrata('BACKGROUND')
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 1)
            self.Debuffs.initialAnchor = 'LEFT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs.num = 3
        end
    end

        -- Mouseover text

    if (C['nUnitframes'].units[N.cUnit(unit)] and C['nUnitframes'].units[N.cUnit(unit)].mouseoverText) then
        EnableMouseOver(self)
    end

    if (self.Auras) then
        self.Auras.PostCreateIcon = N.UpdateAuraIcons
        self.Auras.PostUpdateIcon = N.PostUpdateIcon
        self.Auras.showDebuffType = true
        -- self.Auras.onlyShowPlayer = true
    elseif (self.Buffs) then
        self.Buffs.PostCreateIcon = N.UpdateAuraIcons
        self.Buffs.PostUpdateIcon = N.PostUpdateIcon
    elseif (self.Debuffs) then
        self.Debuffs.PostCreateIcon = N.UpdateAuraIcons
        self.Debuffs.PostUpdateIcon = N.PostUpdateIcon
        self.Debuffs.showDebuffType = true
        -- self.Debuffs.onlyShowPlayer = true
    end

    self:SetScale(C['nUnitframes'].units[N.cUnit(unit)] and C['nUnitframes'].units[N.cUnit(unit)].scale or 1)

        -- OOR and oUF_SpellRange settings

    if (unit == 'pet' or self.IsPartyFrame) then
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }

        self.SpellRange = true

        self.SpellRange = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
    end

    return self
end

oUF:RegisterStyle('oUF_Neav', CreateUnitLayout)
oUF:Factory(function(self)

        -- Player frame spawn

    local player = self:Spawn('player', 'oUF_Neav_Player')
    player:SetPoint('TOPLEFT', __pa)

    player:SetScript('OnDragStart', function()
        __pa:StartMoving()
    end)

    player:SetScript('OnDragStop', function()
        __pa:StopMovingOrSizing()
    end)

    player:SetScript('OnReceiveDrag', function()
        if (CursorHasItem()) then
            AutoEquipCursorItem()
        end
    end)

        -- Pet frame spawn

    local pet = self:Spawn('pet', 'oUF_Neav_Pet')
    pet:SetPoint('TOPLEFT', player, 'BOTTOMLEFT', C['nUnitframes'].units.pet.position.offSetX, C['nUnitframes'].units.pet.position.offSetY)
    
        -- Target frame spawn

    local target = self:Spawn('target', 'oUF_Neav_Target')
    target:SetPoint('TOPLEFT', __ta)
    
    target:SetScript('OnDragStart', function()
        __ta:StartMoving()
    end)

    target:SetScript('OnDragStop', function()
        __ta:StopMovingOrSizing()
    end)

    target:SetScript('OnReceiveDrag', function()
        if (CursorHasItem()) then
            AutoEquipCursorItem()
        end
    end)

        -- Targettarget frame spawn

    local targettarget = self:Spawn('targettarget', 'oUF_Neav_TargetTarget')
    targettarget:SetPoint('TOPLEFT', target, 'BOTTOMRIGHT', -78, -15)

        -- Focus frame spawn

    local focus = self:Spawn('focus', 'oUF_Neav_Focus')
    focus:SetPoint('TOPLEFT', __fa)
    focus:RegisterForDrag('LeftButton') 

    focus:SetScript('OnDragStart', function()
        FOCUS_FRAME_MOVING = false

        if (not FOCUS_FRAME_LOCKED) then
            __fa:StartMoving()
            FOCUS_FRAME_MOVING = true
        end
    end)

    focus:SetScript('OnDragStop', function()
        if (not FOCUS_FRAME_LOCKED and FOCUS_FRAME_MOVING) then
            __fa:StopMovingOrSizing()
            FOCUS_FRAME_MOVING = false
        end
    end)

        -- Focustarget frame spawn

    local focustarget = self:Spawn('focustarget', 'oUF_Neav_FocusTarget')
    focustarget:SetPoint('TOPLEFT', focus, 'BOTTOMRIGHT', -78, -15)

        -- Party frame spawn

    if (C['nUnitframes'].units.party.show) then
        local party = oUF:SpawnHeader('oUF_Neav_Party', nil, (C['nUnitframes'].units.party.hideInRaid and 'party') or 'party,raid',
            'oUF-initialConfigFunction', [[
                self:SetWidth(105)
                self:SetHeight(30)
            ]],
            'showParty', true,
            'yOffset', -30
        )
        party:SetPoint(C['nUnitframes'].units.party.position.selfAnchor, C['nUnitframes'].units.party.position.frameParent, C['nUnitframes'].units.party.position.offSetX, C['nUnitframes'].units.party.position.offSetY)
    end
end)