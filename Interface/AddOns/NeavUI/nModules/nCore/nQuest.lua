local N, C, DB = unpack(select(2, ...)) -- Import:  B - function; C - config; DB - Database

if C['nCore'].quest.enable ~= true then return end

--[[

	All Credit for Quest.lua goes to nightcracker.
	ncQuest = http://www.wowinterface.com/downloads/info14972-ncQuest.html.
	Edited by Cokedriver.
	
]]

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