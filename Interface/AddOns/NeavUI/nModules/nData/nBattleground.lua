local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Battleground.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

if C['nData'].battleground == true then 

	--Map IDs
	local WSG = 443
	local TP = 626
	local AV = 401
	local SOTA = 512
	local IOC = 540
	local EOTS = 482
	local TBFG = 736
	local AB = 461

	local bgframe = BattleGroundPanel
	bgframe:SetScript('OnEnter', function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if ( name ) then
				if ( name == UnitName('player') ) then
					GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
					GameTooltip:ClearLines()
					GameTooltip:SetPoint('BOTTOM', self, 'TOP', 0, 1)
					GameTooltip:ClearLines()
					GameTooltip:AddLine("Stats for : "..hexa..name..hexb)
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine("Killing Blows:", killingBlows,1,1,1)
					GameTooltip:AddDoubleLine("Honorable Kills:", honorableKills,1,1,1)
					GameTooltip:AddDoubleLine("Deaths:", deaths,1,1,1)
					GameTooltip:AddDoubleLine("Honor Gained:", format('%d', honorGained),1,1,1)
					GameTooltip:AddDoubleLine("Damage Done:", damageDone,1,1,1)
					GameTooltip:AddDoubleLine("Healing Done:", healingDone,1,1,1)
					--Add extra statistics to watch based on what BG you are in.
					if curmapid == WSG or curmapid == TP then 
						GameTooltip:AddDoubleLine("Flags Captured:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Flags Returned:",GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == EOTS then
						GameTooltip:AddDoubleLine("Flags Captured:",GetBattlefieldStatData(i, 1),1,1,1)
					elseif curmapid == AV then
						GameTooltip:AddDoubleLine("Graveyards Assaulted:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Graveyards Defended:",GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine("Towers Assaulted:",GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine("Towers Defended:",GetBattlefieldStatData(i, 4),1,1,1)
					elseif curmapid == SOTA then
						GameTooltip:AddDoubleLine("Demolishers Destroyed:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Gates Destroyed:",GetBattlefieldStatData(i, 2),1,1,1)
					elseif curmapid == IOC or curmapid == TBFG or curmapid == AB then
						GameTooltip:AddDoubleLine("Bases Assaulted:",GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine("Bases Defended:",GetBattlefieldStatData(i, 2),1,1,1)
					end					
					GameTooltip:Show()
				end
			end
		end
	end) 
	bgframe:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

	local Stat = CreateFrame('Frame')
	Stat:EnableMouse(true)

	local Text1  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text1:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	Text1:SetPoint('LEFT', BattleGroundPanel, 30, 0)
	Text1:SetHeight(DataPanel:GetHeight())

	local Text2  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text2:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	Text2:SetPoint('CENTER', BattleGroundPanel, 0, 0)
	Text2:SetHeight(DataPanel:GetHeight())

	local Text3  = BattleGroundPanel:CreateFontString(nil, 'OVERLAY')
	Text3:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	Text3:SetPoint('RIGHT', BattleGroundPanel, -30, 0)
	Text3:SetHeight(DataPanel:GetHeight())

	local int = 2
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local dmgtxt
			RequestBattlefieldScoreData()
			local numScores = GetNumBattlefieldScores()
			for i=1, numScores do
				local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
				if healingDone > damageDone then
					dmgtxt = ("Healing : "..hexa..healingDone..hexb)
				else
					dmgtxt = ("Damage : "..hexa..damageDone..hexb)
				end
				if ( name ) then
					if ( name == myname ) then
						Text2:SetText("Honor : "..hexa..format('%d', honorGained)..hexb)
						Text1:SetText(dmgtxt)
						Text3:SetText("Killing Blows : "..hexa..killingBlows..hexb)
					end   
				end
			end 
			int  = 0
		end
	end

	--hide text when not in an bg
	local function OnEvent(self, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == 'pvp') then			
				bgframe:Show()
				PanelLeft:Hide()
			else
				Text1:SetText('')
				Text2:SetText('')
				Text3:SetText('')
				bgframe:Hide()
				PanelLeft:Show()
			end
		end
	end

	Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
	Stat:SetScript('OnEvent', OnEvent)
	Stat:SetScript('OnUpdate', Update)
	Update(Stat, 10)
end