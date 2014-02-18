local N, C, DB = unpack(select(2, ...)) -- Import:  B - function; C - config; DB - Database

if C['nCore'].quest.enable ~= true then return end

--[[

	All Credit for Quest.lua goes to nightcracker.
	ncQuest = http://www.wowinterface.com/downloads/info14972-ncQuest.html.
	Edited by Cokedriver.
	
]]

-- add quest level in quest guide
local function questlevel()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", questlevel)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", questlevel)

local QuestFrame = CreateFrame("Frame")

local function MostValueable()
	local bestp, besti = 0
	for i=1,GetNumQuestChoices() do
		local link, name, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
		local price = link and select(11, GetItemInfo(link))
		if not price then
			return
		elseif (price * (qty or 1)) > bestp then
			bestp, besti = (price * (qty or 1)), i
		end
	end
	if besti then
		local btn = _G["QuestInfoItem"..besti]
		if (btn.type == "choice") then
			btn:GetScript("OnClick")(btn)
		end
	end
end


if C['nCore'].quest.autocomplete == true then
	QuestFrame:SetScript("OnEvent", function(self, event, ...)	
		if (event == "QUEST_DETAIL") then
			AcceptQuest()
			CompleteQuest()
		elseif (event == "QUEST_COMPLETE") then
			if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
				GetQuestReward()
			else
				MostValueable()
			end
		elseif (event == "QUEST_ACCEPT_CONFIRM") then
			ConfirmAcceptQuest()
		end
	end)
else
	QuestFrame:SetScript("OnEvent", function(self, event, ...)
		if (event == "QUEST_COMPLETE") then
			if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
				GetQuestReward()
			else
				MostValueable()
			end
		end
	end)
end	
	
QuestFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")    
QuestFrame:RegisterEvent("QUEST_DETAIL")
QuestFrame:RegisterEvent("QUEST_COMPLETE")

local timeout = CreateFrame("Frame")
timeout:Hide()

local f = LibStub("tekShiner").new(QuestRewardScrollChildFrame)
f:Hide()


f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("QUEST_ITEM_UPDATE")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
f:SetScript("OnEvent", function(self, ...)
	self:Hide()
	local bestp, besti = 0
	for i=1,GetNumQuestChoices() do
		local link, name, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
		if not link then
			timeout:Show()
			return
		end
		local price = link and select(11, GetItemInfo(link))
		if not price then return
		elseif (price * (qty or 1)) > bestp then bestp, besti = (price * (qty or 1)), i end
	end

	if besti then
		self:ClearAllPoints()
		self:SetAllPoints("QuestInfoItem"..besti.."IconTexture")
		self:Show()
	end
end)


local elapsed
timeout:SetScript("OnShow", function() elapsed = 0 end)
timeout:SetScript("OnHide", function() f:GetScript("OnEvent")(f) end)
timeout:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < 1 then return end
	self:Hide()
end)

if QuestInfoItem1:IsVisible() then f:GetScript("OnEvent")(f) end