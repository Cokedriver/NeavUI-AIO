local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nUnitframes'].enable ~= true then return end

local function UpdateCastbarColor(self, unit, config)
    if (self.interrupt) then
        N.ColorBorder(self, 'white', config.interruptColor.r, config.interruptColor.g, config.interruptColor.b)

        if (self.IconOverlay) then
            N.ColorBorder(self.IconOverlay, 'white', config.interruptColor.r, config.interruptColor.g, config.interruptColor.b)
        end
    else
        N.ColorBorder(self, 'default', 1, 1, 1, 0)

        if (self.IconOverlay) then
            N.ColorBorder(self.IconOverlay, 'default', 1, 1, 1, 0)
        end
    end
end

    -- Create the castbars

function N.CreateCastbars(self, unit)
    local config = C['nUnitframes'].units[N.cUnit(unit)].castbar

    if (N.MultiCheck(unit, 'player', 'target', 'focus', 'pet') and config and config.show) then 
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
        self.Castbar:SetScale(config.scale)
        self.Castbar:SetSize(config.width, config.height)
        self.Castbar:SetStatusBarColor(unpack(config.color))  
        
        if (unit == 'focus') then
            self.Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 25)
        else
            self.Castbar:SetPoint(config.position.selfAnchor , config.position.frameParent , config.position.relAnchor , config.position.offSetX , config.position.offSetY )
        end

        self.Castbar.Background = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Background:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Background:SetAllPoints(self.Castbar)
        self.Castbar.Background:SetVertexColor(config.color.r * 0.3, config.color.g * 0.3, config.color.b * 0.3, 0.8)

        if (unit == 'player') then
            local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

            if (config.classcolor) then
                self.Castbar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
                self.Castbar.Background:SetVertexColor(playerColor.r * 0.3, playerColor.g * 0.3, playerColor.b * 0.3, 0.8)
            end

            if (config.showSafezone) then
                self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER') 
                self.Castbar.SafeZone:SetTexture(config.safezoneColor.r, config.safezoneColor.g, config.safezoneColor.b)
            end

            if (config.showLatency) then
                self.Castbar.Latency = self.Castbar:CreateFontString(nil, 'OVERLAY')
                self.Castbar.Latency:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end

        self.Castbar:CreateBeautyBorder(12)
        self.Castbar:SetBeautyBorderPadding(2.66)
		self.Castbar:SetBeautyBorderTexture('white')
		if C['nMedia'].border == "Default" then
			self.Castbar:SetBeautyBorderColor(0.38, 0.38, 0.38)		
		elseif C['nMedia'].border == "Classcolor" then
			self.Castbar:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
		elseif C['nMedia'].border == "Custom" then
			self.Castbar:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
		end	

        N.CreateCastbarStrings(self)

        if (config.icon.show) then
            self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
            self.Castbar.Icon:SetSize(config.height + 2, config.height + 2)
            self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if (config.icon.position == 'LEFT') then
                self.Castbar.Icon:SetPoint('RIGHT', self.Castbar, 'LEFT', (config.icon.positionOutside and -8) or 0, 0)
            else
                self.Castbar.Icon:SetPoint('LEFT', self.Castbar, 'RIGHT', (config.icon.positionOutside and 8) or 0, 0)
            end

            if (config.icon.positionOutside) then
                self.Castbar.IconOverlay = CreateFrame('Frame', nil, self.Castbar)
                self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
                self.Castbar.IconOverlay:CreateBeautyBorder(12)
                self.Castbar.IconOverlay:SetBeautyBorderPadding(2)
				self.Castbar.IconOverlay:SetBeautyBorderTexture('white')
				if C['nMedia'].border == "Default" then
					self.Castbar.IconOverlay:SetBeautyBorderColor(0.38, 0.38, 0.38)		
				elseif C['nMedia'].border == "Classcolor" then
					self.Castbar.IconOverlay:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
				elseif C['nMedia'].border == "Custom" then
					self.Castbar.IconOverlay:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
				end					
            else
                if (config.icon.position == 'LEFT') then
                    self.Castbar:SetBeautyBorderPadding(4 + config.height, 3, 3, 3, 4 + config.height, 3, 3, 3, 3)
                else
                    self.Castbar:SetBeautyBorderPadding(3, 3, 4 + config.height, 3, 3, 3, 4 + config.height, 3, 3)
                end
            end
        end

            -- Interrupt indicator

        self.Castbar.PostCastStart = function(self, unit)
            if (unit == 'player') then
                if (self.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint('RIGHT', self, 'BOTTOMRIGHT', -1, -2) 
                    self.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end

            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(self, unit, config)
            end

                -- Hide some special spells like waterbold or firebold (pets) because it gets really spammy

            if (C['nUnitframes'].units.pet.castbar.ignoreSpells) then
                if (unit == 'pet') then
                    self:SetAlpha(1)

                    for _, spellID in pairs(C['nUnitframes'].units.pet.castbar.ignoreList) do
                        if (UnitCastingInfo('pet') == GetSpellInfo(spellID)) then
                            self:SetAlpha(0)
                        end
                    end
                end
            end
        end

        self.Castbar.PostChannelStart = function(self, unit)
            if (unit == 'player') then
                if (self.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint('LEFT', self, 'BOTTOMLEFT', 1, -2)
                    self.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end

            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(self, unit, config)
            end

            if (C['nUnitframes'].units.pet.castbar.ignoreSpells) then
                if (unit == 'pet' and self:GetAlpha() == 0) then
                    self:SetAlpha(1)
                end
            end
        end
        
        self.Castbar.PostCastInterruptible = UpdateCastbarColor
        self.Castbar.PostCastNotInterruptible = UpdateCastbarColor
        
        self.Castbar.CustomDelayText = N.CustomDelayText
        self.Castbar.CustomTimeText = N.CustomTimeText
    end
end

    -- Mirror timers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G['MirrorTimer'..i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetSize(220, 18)
    
    bar:CreateBeautyBorder(12)
    bar:SetBeautyBorderPadding(3)
	bar:SetBeautyBorderTexture('white')
	if C['nMedia'].border == "Default" then
		bar:SetBeautyBorderColor(0.38, 0.38, 0.38)		
	elseif C['nMedia'].border == "Classcolor" then
		bar:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
	elseif C['nMedia'].border == "Custom" then
		bar:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
	end	

    if (i > 1) then
        local p1, p2, p3, p4, p5 = bar:GetPoint()
        bar:SetPoint(p1, p2, p3, p4, p5 - 15)
    end

    local statusbar = _G['MirrorTimer'..i..'StatusBar']
    statusbar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')
    statusbar:SetAllPoints(bar)

    local backdrop = select(1, bar:GetRegions())
    backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
    backdrop:SetVertexColor(0, 0, 0, 0.5)
    backdrop:SetAllPoints(bar)

    local border = _G['MirrorTimer'..i..'Border']
    border:Hide()

    local text = _G['MirrorTimer'..i..'Text']
    text:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
    text:ClearAllPoints()
    text:SetPoint('CENTER', bar)
end

    -- Battleground timer

local f = CreateFrame('Frame')
f:RegisterEvent('START_TIMER')
f:SetScript('OnEvent', function(self, event)
    for _, b in pairs(TimerTracker.timerList) do
        if (not b['bar'].beautyBorder) then
            local bar = b['bar']
            bar:SetScale(1.132)
            bar:SetSize(220, 18)

            for i = 1, select('#', bar:GetRegions()) do
                local region = select(i, bar:GetRegions())

                if (region and region:GetObjectType() == 'Texture') then
                    region:SetTexture(nil)
                end

                if (region and region:GetObjectType() == 'FontString') then
                    region:ClearAllPoints()
                    region:SetPoint('CENTER', bar)
                    region:SetFont(C['nMedia'].font, C['nUnitframes'].font.normalSize)
                end
            end

            bar:CreateBeautyBorder(12)
            bar:SetBeautyBorderPadding(3)
			bar:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				bar:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				bar:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				bar:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end	
            bar:SetStatusBarTexture('Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture')

            local backdrop = select(1, bar:GetRegions())
            backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
            backdrop:SetVertexColor(0, 0, 0, 0.5)
            backdrop:SetAllPoints(bar)
        end
    end
end)