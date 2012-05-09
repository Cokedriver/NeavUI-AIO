local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nUnitframes'].enable ~= true then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "NeavUI was unable to locate oUF install.")

local function UpdateHealth(Health, unit, cur, max)
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end

    Health.Value:SetText(N.GetHealthText(unit, cur, max))

    local self = Health:GetParent()
    if (self.Name.Bg) then
        self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
    end
end

local function UpdatePower(Power, unit, cur, max)
    if (UnitIsDead(unit)) then
        Power:SetValue(0)
    end

    Power.Value:SetText(N.GetPowerText(unit, cur, max))
end

local function CreateBossLayout(self, unit)
    self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)

    self:SetFrameStrata('MEDIUM')

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)

        -- texture

    self.Texture = self.Health:CreateTexture(nil, 'ARTWORK')
    self.Texture:SetSize(250, 129)
    self.Texture:SetPoint('CENTER', self, 31, -24)
    self.Texture:SetTexture('Interface\\TargetingFrame\\UI-UnitFrame-Boss')

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture', 'BORDER')
    self.Health:SetSize(115, 8)
    self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -43)

    self.Health:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
    self.Health.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint('CENTER', self.Health)

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture', 'BORDER')
    self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -4)
    self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -4)
    self.Power:SetHeight(self.Health:GetHeight())

    self.Power:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Power:SetBackdropColor(0, 0, 0, 0.55)

    self.Power.PostUpdate = UpdatePower
    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.colorPower = true

        -- power text

    self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
    self.Power.Value:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint('CENTER', self.Power)

        -- name

    self.Name = self.Health:CreateFontString(nil, 'ARTWORK')
    self.Name:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalBigSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH('CENTER')
    self.Name:SetSize(110, 10)
    self.Name:SetPoint('BOTTOM', self.Health, 'TOP', 0, 6)

    self:Tag(self.Name, '[name]')

        -- colored name background

    self.Name.Bg = self.Health:CreateTexture(nil, 'BACKGROUND')
    self.Name.Bg:SetHeight(18)
    self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
    self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
    self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
    self.Name.Bg:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\nameBackground')

        -- level

    self.Level = self.Health:CreateFontString(nil, 'ARTWORK')
    self.Level:SetFont(C['nMedia'].font, 16, 'OUTLINE')
    self.Level:SetShadowOffset(0, 0)
    self.Level:SetPoint('CENTER', self.Texture, 24, -2)

    self:Tag(self.Level, '[level]')

        -- raidicons

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.RaidIcon:SetPoint('CENTER', self, 'TOPRIGHT', -9, -5)
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
    self.RaidIcon:SetSize(26, 26)

        -- threat glow textures

    self.ThreatGlow = self:CreateTexture(nil, 'OVERLAY')
    self.ThreatGlow:SetAlpha(0)
    self.ThreatGlow:SetSize(241, 100)
    self.ThreatGlow:SetPoint('TOPRIGHT', self.Texture, -11, 3)
    self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-UnitFrame-Boss-Flash')
    self.ThreatGlow:SetTexCoord(0.0, 0.945, 0.0, 0.73125)

    self.Buffs = CreateFrame('Frame', nil, self)
    self.Buffs.size = 30
    self.Buffs:SetHeight(self.Buffs.size * 3)
    self.Buffs:SetWidth(self.Buffs.size * 5)
    self.Buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 3, -6)
    self.Buffs.initialAnchor = 'TOPLEFT'
    self.Buffs['growth-x'] = 'RIGHT'
    self.Buffs['growth-y'] = 'DOWN'
    self.Buffs.numBuffs = 8
    self.Buffs.spacing = 4.5

    self.Buffs.customColor = {1, 0, 0}

    self.Buffs.PostCreateIcon = N.UpdateAuraIcons
    self.Buffs.PostUpdateIcon = N.PostUpdateIcon

    self:SetSize(132, 46)
    self:SetScale(C['nUnitframes'].units.boss.scale)

    if (C['nUnitframes'].units.boss.castbar.show) then  
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
        self.Castbar:SetSize(150, 18)
        self.Castbar:SetStatusBarColor(C['nUnitframes'].units.boss.castbar.color.r, C['nUnitframes'].units.boss.castbar.color.g, C['nUnitframes'].units.boss.castbar.color.b)
        self.Castbar:SetPoint('BOTTOM', self, 'TOP', 10, 13)

        self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Bg:SetAllPoints(self.Castbar)
        self.Castbar.Bg:SetVertexColor(C['nUnitframes'].units.boss.castbar.color.r*0.3, C['nUnitframes'].units.boss.castbar.color.g*0.3, C['nUnitframes'].units.boss.castbar.color.b*0.3, 0.8)

        self.Castbar:CreateBeautyBorder(12)
        self.Castbar:SetBeautyBorderPadding(3)
		self.Castbar:SetBeautyBorderTexture('white')
		if C['nMedia'].border == "Default" then
			self.Castbar:SetBeautyBorderColor(0.38, 0.38, 0.38)		
		elseif C['nMedia'].border == "Classcolor" then
			self.Castbar:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
		elseif C['nMedia'].border == "Custom" then
			self.Castbar:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
		end		

        N.CreateCastbarStrings(self, true)

        self.Castbar.CustomDelayText = N.CustomDelayText
        self.Castbar.CustomTimeText = N.CustomTimeText
    end

    return self
end

oUF:RegisterStyle('oUF_Neav_Boss', CreateBossLayout)
oUF:Factory(function(self)
    oUF:SetActiveStyle('oUF_Neav_Boss')

    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = self:Spawn('boss'..i, 'oUF_Neav_BossFrame'..i)

        if (i == 1) then
            boss[i]:SetPoint(C['nUnitframes'].units.boss.position.selfAnchor , C['nUnitframes'].units.boss.position.frameParent , C['nUnitframes'].units.boss.position.relAnchor , C['nUnitframes'].units.boss.position.offSetX , C['nUnitframes'].units.boss.position.offSetY)
        else
            boss[i]:SetPoint('TOPLEFT', boss[i-1], 'BOTTOMLEFT', 0, (C['nUnitframes'].units.boss.castbar.show and -40) or -10)
        end
    end
end)