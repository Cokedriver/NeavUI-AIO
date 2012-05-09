local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

local L = setmetatable({}, { __index = function(t,k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end })

--Constants
local m = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")));

N.scale = function(v) return m * floor(v/m+.5) end;
N.dummy = function() return end
N.toc = select(4, GetBuildInfo())
N.myname, _ = UnitName("player")
N.myrealm = GetRealmName()
_, N.myclass = UnitClass("player")
N.version = GetAddOnMetadata("NeavUI", "Version")
N.patch = GetBuildInfo()
N.level = UnitLevel("player")
N.locale = GetLocale()
N.resolution = GetCurrentResolution()
N.getscreenresolution = select(N.resolution, GetScreenResolutions())
N.getscreenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
N.getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"))
N.ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
N.regions = {['TOPLEFT'] = L['TOPLEFT'], ['TOP'] = L['TOP'], ['TOPRIGHT'] = L['TOPRIGHT'], ['LEFT'] = L['LEFT'], ['CENTER'] = L['CENTER'], ['RIGHT'] = L['RIGHT'], ['BOTTOMLEFT'] = L['BOTTOMLEFT'], ['BOTTOM'] = L['BOTTOM'], ['BOTTOMRIGHT'] = L['BOTTOMRIGHT']}
N.healthTag = {['$cur'] = L['$cur'], ['$max'] = L['$max'], ['$deficit'] = L['$deficit'], ['$perc'] = L['$perc'], ['$smartperc'] = L['$smartperc'], ['$smartcolorperc'] = L['$smartcolorperc'], ['$colorperc'] = L['$colorperc']}
N.healthFormat = {['$cur/$max'] = L['$cur/$max'], ['$cur-$max'] = L['$cur-$max']}
N.style = {['NORMAL'] = L['NORMAL'], ['RARE'] = L['RARE'], ['ELITE'] = L['ELITE'], ['CUSTOM'] = L['CUSTOM']}
N.LorR = {['LEFT'] = L['LEFT'], ['RIGHT'] = L['RIGHT']}
N.type = {['type1'] = L['type1'], ['type2'] = L['type2'], ['type3'] = L['type3'], ['type4'] = L['type4'], ['type5'] = L['type5'], ['type6'] = L['type6'], ['type7'] = L['type7'], ['type8'] = L['type8'], ['type9'] = L['type9'], ['type0'] = L['type0'], ['mousebutton1'] = L['mousebutton1'], ['mousebutton2'] = L['mousebutton2'], ['mousebutton3'] = L['mousebutton3'], ['mousebutton4'] = L['mousebutton4'], ['mousebutton5'] = L['mousebutton5']}
N.orientation = {['VERTICAL'] = L['VERTICAL'], ['HORIZONTAL'] = L['HORIZONTAL']}
N.border = {['Blizzard'] = L['Blizzard'], ['Neav'] = L['Neav']}
N.bordercolor = {['Default'] = L['Default'], ['Classcolor'] = L['Classcolor'], ['Custom'] = L['Custom']}

--Check Player's Role
local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true
	else
		resilience = false
	end
	if ((N.myclass == "PALADIN" and tree == 2) or 
	(N.myclass == "WARRIOR" and tree == 3) or 
	(N.myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(N.myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		N.Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (N.myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or N.myclass == "ROGUE" or N.myclass == "HUNTER" or (N.myclass == "SHAMAN" and tree == 2) then
			N.Role = "Melee"
		else
			N.Role = "Caster"
		end
	end
end	
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()

N.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH('LEFT')
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

N.SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Pulse")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

N.Flash = function(self, duration)
	if not self.anim then
		N.SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:SetLooping("REPEAT")
	self.anim:Play()
end

N.SFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

-- Greeting
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(self,event,...) 
	if type(NeavDBPerCharacter) ~= "number" then
		NeavDBPerCharacter = 1
		ChatFrame1:AddMessage('Welcome to Azeroth '..N.myname..". I do believe this is the first time we've met. Nice to meet you! You're using |cff00B4FFNeavUI v"..N.version..'|r.')
	else
		if NeavDBPerCharacter == 1 then
			ChatFrame1:AddMessage('Welcome to Azeroth '..N.myname..". How nice to see you again. You're using |cff00B4FFNeavUI v"..N.version..'|r.')
		else
			ChatFrame1:AddMessage('Welcome to Azeroth '..N.myname..". How nice to see you again. You're using |cff00B4FFNeavUI v"..N.version..'|r.')
		end
		NeavDBPerCharacter = NeavDBPerCharacter + 1
	end
end)

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "NeavUI was unable to locate oUF install.")


local floor = floor
local select = select
local tonumber = tonumber

local modf = math.modf
local fmod = math.fmod
local floot = math.floor
local gsub = string.gsub
local format = string.format

local GetTime = GetTime
local day, hour, minute = 86400, 3600, 60

local function FormatValue(value)
    if (value >= 1e6) then
        return tonumber(format('%.1f', value/1e6))..'m'
    elseif (value >= 1e3) then
        return tonumber(format('%.1f', value/1e3))..'k'
    else
        return value
    end
end

local function DeficitValue(value)
    if (value == 0) then
        return ''
    else
        return '-'..FormatValue(value)
    end
end

N.cUnit = function(unit)
    if (unit:match('vehicle')) then
        return 'player'
    elseif (unit:match('party%d')) then
        return 'party'
    elseif (unit:match('arena%d')) then
        return 'arena'
    elseif (unit:match('boss%d')) then
        return 'boss'
    else
        return unit
    end
end

N.FormatTime = function(time)
    if (time >= day) then
        return format('%dd', floor(time/day + 0.5))
    elseif (time>= hour) then
        return format('%dh', floor(time/hour + 0.5))
    elseif (time >= minute) then
        return format('%dm', floor(time/minute + 0.5))
    end

    return format('%d', fmod(time, minute))
end

local function GetUnitStatus(unit)
    if (UnitIsDead(unit)) then 
        return DEAD
    elseif (UnitIsGhost(unit)) then
        return 'Ghost' 
    elseif (not UnitIsConnected(unit)) then
        return PLAYER_OFFLINE
    else
        return ''
    end
end

local function GetFormattedText(text, cur, max, alt)
    local perc = (cur/max)*100

    if (alt) then
        text = gsub(text, '$alt', ((alt > 0) and format('%s', FormatValue(alt)) or ''))
    end

    local r, g, b = oUF.ColorGradient(cur/max, unpack(oUF.smoothGradient or oUF.colors.smooth))
    text = gsub(text, '$cur', format('%s', (cur > 0 and FormatValue(cur)) or ''))
    text = gsub(text, '$max', format('%s', FormatValue(max)))
    text = gsub(text, '$deficit', format('%s', DeficitValue(max-cur)))
    text = gsub(text, '$perc', format('%d', perc)..'%%')
    text = gsub(text, '$smartperc', format('%d', perc))
    text = gsub(text, '$smartcolorperc', format('|cff%02x%02x%02x%d|r', r*255, g*255, b*255, perc))
    text = gsub(text, '$colorperc', format('|cff%02x%02x%02x%d', r*255, g*255, b*255, perc)..'%%|r')

    return text
end

N.GetHealthText = function(unit, cur, max)
    local uconf = C['nUnitframes'].units[N.cUnit(unit)]

    if (not cur) then
        cur = UnitHealth(unit)
        max = UnitHealthMax(unit)
    end

    local healthString
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        healthString = GetUnitStatus(unit)
    elseif ((cur == max) and uconf and uconf.healthTagFull)then
        healthString = GetFormattedText(uconf.healthTagFull, cur, max)
    elseif (uconf and uconf.healthTag) then
        healthString = GetFormattedText(uconf.healthTag, cur, max)
    else
        if (cur == max) then
            healthString = FormatValue(cur)
        else
            healthString = FormatValue(cur)..'/'..FormatValue(max)
        end
    end

    return healthString
end

N.GetPowerText = function(unit, cur, max)
    local uconf = C['nUnitframes'].units[N.cUnit(unit)]

    if (not cur) then
        max = UnitPower(unit)
        cur = UnitPowerMax(unit)
    end

    local alt = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local powerType = UnitPowerType(unit)

    local powerString
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        powerString = ''
    elseif (max == 0) then
        powerString = ''
    elseif (not UnitHasMana(unit) or powerType ~= 0 or UnitHasVehicleUI(unit) and uconf and uconf.powerTagNoMana) then
        powerString = GetFormattedText(uconf.powerTagNoMana, cur, max, alt)
    elseif ((cur == max) and uconf and uconf.powerTagFull)then
        powerString = GetFormattedText(uconf.powerTagFull, cur, max, alt)
    elseif (uconf and uconf.powerTag) then
        powerString = GetFormattedText(uconf.powerTag, cur, max, alt)
        
    else
        if (cur == max) then
            powerString = FormatValue(cur)
        else
            powerString = FormatValue(cur)..'/'..FormatValue(max)
        end
    end

    return powerString
end

N.MultiCheck = function(what, ...)
    for i = 1, select('#', ...) do
        if (what == select(i, ...)) then 
            return true 
        end
    end

    return false
end

N.utf8sub = function(string, index)
    local bytes = string:len()
    if (bytes <= index) then
        return string
    else
        local length, currentIndex = 0, 1

        while currentIndex <= bytes do
            length = length + 1
            local char = string:byte(currentIndex)

            if (char > 240) then
                currentIndex = currentIndex + 4
            elseif (char > 225) then
                currentIndex = currentIndex + 3
            elseif (char > 192) then
                currentIndex = currentIndex + 2
            else
                currentIndex = currentIndex + 1
            end

            if (length == index) then
                break
            end
        end

        if (length == index and currentIndex <= bytes) then
            return string:sub(1, currentIndex - 1)
        else
            return string
        end
    end
end

local flashObjects = {}
local f = CreateFrame('Frame')

local function Flash_OnUpdate(self, elapsed)
    local frame
    local index = #flashObjects

    while flashObjects[index] do
        frame = flashObjects[index]
        frame.flashTimer = frame.flashTimer + elapsed

        local flashTime = frame.flashTimer
        local alpha

        flashTime = flashTime%(frame.fadeInTime + frame.fadeOutTime + (frame.flashInHoldTime or 0) + (frame.flashOutHoldTime or 0))

        if (flashTime < frame.fadeInTime) then
            alpha = flashTime/frame.fadeInTime
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)) then
            alpha = 1
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)+frame.fadeOutTime) then
            alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0))/frame.fadeOutTime);
        else
            alpha = 0
        end

        frame:SetAlpha(alpha + (frame.minAlpha and frame.minAlpha or 0))

        index = index - 1
    end

    if (#flashObjects == 0) then
        self:SetScript('OnUpdate', nil)
    end
end

N.IsFlashing = function(frame)
    for index, value in pairs(flashObjects) do
        if (value == frame) then
            return 1
        end
    end

    return nil
end

N.StopFlash = function(frame)
    tDeleteItem(flashObjects, frame)
    frame.flashTimer = nil
    frame:SetAlpha(0)
end

N.StartFlash = function(frame, fadeInTime, fadeOutTime, flashInHoldTime, flashOutHoldTime)
    if (frame) then
        local index = 1
        while flashObjects[index] do
            if (flashObjects[index] == frame) then
                return
            end

            index = index + 1
        end

        frame.flashTimer = 0 
        frame.fadeInTime = fadeInTime
        frame.fadeOutTime = fadeOutTime
        frame.flashInHoldTime = flashInHoldTime
        frame.flashOutHoldTime = flashOutHoldTime

        tinsert(flashObjects, frame)

        f:SetScript('OnUpdate', Flash_OnUpdate)
    end
end

function N.ColorBorder(self, ...)
    local texture, r, g, b, s = ...
    self:SetBeautyBorderTexture(texture)
    self:SetBeautyBorderColor(r, g, b)
end

function N.CustomTimeText(self, duration)
    self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
end

function N.CustomDelayText(self, duration)
    self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
end

function N.CreateCastbarStrings(self, size)
    self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')

    if (size) then
        self.Castbar.Time:SetFont(C['nMedia'].font, 21)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -2, 0)  
    else
        self.Castbar.Time:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -5, 0)  
    end

    self.Castbar.Time:SetShadowOffset(1, -1)
    self.Castbar.Time:SetHeight(10)
    self.Castbar.Time:SetJustifyH('RIGHT')
    self.Castbar.Time:SetParent(self.Castbar)

    self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
    self.Castbar.Text:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
    self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)  

    if (size) then
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -7, 0)
    else
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -4, 0)
    end

    self.Castbar.Text:SetShadowOffset(1, -1)
    self.Castbar.Text:SetHeight(10)
    self.Castbar.Text:SetJustifyH('LEFT')
    self.Castbar.Text:SetParent(self.Castbar)  
end

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local function ExactTime(time)
    return format('%.1f', time), (time * 100 - floor(time * 100))/100
end

local function IsMine(unit)
    if (unit == 'player' or unit == 'vehicle' or unit == 'pet') then
        return true
    else
        return false
    end
end

N.UpdateAuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if (self.elapsed < 0.1) then 
        return 
    end

    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        if (timeLeft <= 5 and IsMine(self.owner)) then
            self.remaining:SetText('|cffff0000'..ExactTime(timeLeft)..'|r')
            if (not self.ignoreSize) then
                self.remaining:SetFont(C['nMedia'].font, 12, 'THINOUTLINE')
            end
        else
            self.remaining:SetText(N.FormatTime(timeLeft))
            if (not self.ignoreSize) then
                self.remaining:SetFont(C['nMedia'].font, 8, 'THINOUTLINE')
            end
        end
    end
end

N.PostUpdateIcon = function(icons, unit, icon, index, offset)
    icon:SetAlpha(1)

    if (icon.isStealable) then
        if (icon.Shadow) then
            icon.Shadow:SetVertexColor(1, 1, 0, 1)
        end
    else
        if (icon.Shadow) then
            icon.Shadow:SetVertexColor(0, 0, 0, 1)
        end
    end

    if (C['nUnitframes'].units.target.colorPlayerDebuffsOnly) then
        if (unit == 'target') then 
            if (icon.debuff) then
                if (not IsMine(icon.owner)) then
                    -- icon.overlay:SetVertexColor(0.45, 0.45, 0.45)
                    icon.icon:SetDesaturated(true)
                    icon:SetAlpha(0.55)
                else
                    icon.icon:SetDesaturated(false)
                    icon:SetAlpha(1)
                end
            end
        end
    end

    if (icon.remaining) then
        if (unit == 'target' and icon.debuff and not IsMine(icon.owner) and (not UnitIsFriend('player', unit) and UnitCanAttack(unit, 'player') and not UnitPlayerControlled(unit)) and not C['nUnitframes'].units.target.showAllTimers ) then
            if (icon.remaining:IsShown()) then
                icon.remaining:Hide()
            end

            icon:SetScript('OnUpdate', nil)
        else
            local _, _, _, _, _, duration, expirationTime = UnitAura(unit, index, icon.filter)
            if (duration and duration > 0) then
                if (not icon.remaining:IsShown()) then
                    icon.remaining:Show()
                end
            else
                if (icon.remaining:IsShown()) then
                    icon.remaining:Hide()
                end
            end

            icon.duration = duration
            icon.expires = expirationTime
            icon:SetScript('OnUpdate', N.UpdateAuraTimer)
        end
    end
end

N.UpdateAuraIcons = function(auras, button)
    if (not button.Shadow) then
        local size = button:GetSize()

        button:SetFrameLevel(1)

        button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        button.icon:ClearAllPoints()
        button.icon:SetPoint('CENTER', button)
        button.icon:SetSize(size, size)

        button.overlay:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\borderBackground')
        button.overlay:SetTexCoord(0, 1, 0, 1)
        button.overlay:ClearAllPoints()
        button.overlay:SetPoint('TOPRIGHT', button.icon, 1.35, 1.35)
        button.overlay:SetPoint('BOTTOMLEFT', button.icon, -1.35, -1.35)

        button.count:SetFont(C['nMedia'].font, 11, 'THINOUTLINE')
        button.count:SetShadowOffset(0, 0)
        button.count:ClearAllPoints()
        button.count:SetPoint('BOTTOMRIGHT', button.icon, 2, 0)

        if (C['nUnitframes'].show.disableCooldown) then
            button.cd:SetReverse()
            button.cd:SetDrawEdge(true)
            button.cd:ClearAllPoints()
            button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
            button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)
        else
            auras.disableCooldown = true
            -- button.cd.noOCC = true

            button.remaining = button:CreateFontString(nil, 'OVERLAY')
            button.remaining:SetFont(C['nMedia'].font, 8, 'THINOUTLINE')
            button.remaining:SetShadowOffset(0, 0)
            button.remaining:SetPoint('TOP', button.icon, 0, 2)
        end

        if (not button.Shadow) then
            button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
            button.Shadow:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
            button.Shadow:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
            button.Shadow:SetTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\borderBackground')
            button.Shadow:SetVertexColor(0, 0, 0, 1)
        end

        button.overlay.Hide = function(self)
            self:SetVertexColor(0.5, 0.5, 0.5, 1)
        end
    end
end



INTERFACE_ACTION_BLOCKED = ''

SlashCmdList['RELOADUI'] = function()
    ReloadUI()
end
SLASH_RELOADUI1 = '/rl'

SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
 
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
f:SetScript('OnEvent', function(_, event, ...)
    if (event == 'PLAYER_LOGIN') then
        SetCVar('ScreenshotQuality', 10)
    end

    if (event == 'ACTIVE_TALENT_GROUP_CHANGED') then
        LoadAddOn('Blizzard_GlyphUI')
    end
end)


-- Error Message Ignore List
UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
UIErrorsFrame:SetTimeVisible(1)
UIErrorsFrame:SetFadeDuration(0.75)

local ignoreList = {
    [ERR_SPELL_COOLDOWN] = true,
    [ERR_ABILITY_COOLDOWN] = true,

    [OUT_OF_ENERGY] = true,

    [SPELL_FAILED_NO_COMBO_POINTS] = true,

    [SPELL_FAILED_MOVING] = true,
    [ERR_NO_ATTACK_TARGET] = true,
    [SPELL_FAILED_SPELL_IN_PROGRESS] = true,

    [ERR_NO_ATTACK_TARGET] = true,
    [ERR_INVALID_ATTACK_TARGET] = true,
    [SPELL_FAILED_BAD_TARGETS] = true,
}

local event = CreateFrame('Frame')
event:SetScript('OnEvent', function(self, event, error)
    if (not ignoreList[error]) then
        UIErrorsFrame:AddMessage(error, 1, .1, .1)
    end
end)

event:RegisterEvent('UI_ERROR_MESSAGE')
