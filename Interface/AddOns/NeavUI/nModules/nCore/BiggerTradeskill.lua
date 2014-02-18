local N, C, DB = unpack(select(2, ...)) -- Import:  B - function; C - config; DB - Database

---------------------------------------
-- Bigger Trade Skill UI
---------------------------------------
-- Credit for BTSUI goes to Robsato for his Bigger Tradeskill UI addon.
-- You can find the original addon at http://www.wowinterface.com/downloads/info20508-BiggerTradeskillUI.html
-- Edited by Cokedriver

if C["nCore"].btsw ~= true then return end

local addonName, BTSW = ...

TRADE_SKILLS_DISPLAYED = 25


-- Add skill buttons if needed
for i=1, TRADE_SKILLS_DISPLAYED do
	if (not _G["TradeSkillSkill"..i]) then
		-- Create a new button
		local newSkillButton = CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillSkill1:GetParent(), "TradeSkillSkillButtonTemplate")
		newSkillButton:SetPoint("TOPLEFT", _G["TradeSkillSkill"..(i-1)], "BOTTOMLEFT")
	end
end   


-- Resize the main window
TradeSkillFrame:SetWidth(550)
TradeSkillFrame:SetHeight(525)

-- Hide Horizontal bar in the default UI
TradeSkillHorizontalBarLeft:Hide()

-- Move skillbar
TradeSkillRankFrame:ClearAllPoints()
TradeSkillRankFrame:SetPoint("TOPRIGHT", TradeSkillRankFrame:GetParent(), "TOPRIGHT", -37, -33)

-- Setup search box
TradeSkillFrameSearchBox:ClearAllPoints()
TradeSkillFrameSearchBox:SetPoint("TOPLEFT", TradeSkillFrameSearchBox:GetParent(), "TOPLEFT", 75, -56)
TradeSkillFrameSearchBox:SetPoint("RIGHT", TradeSkillRankFrame, "LEFT", -8, 0)

-- Add a clear button to the searchbox like all other search boxes have
local clearButton = CreateFrame("Button", "TradeSkillFrameSearchBoxClearButton", TradeSkillFrameSearchBox)
clearButton:SetWidth(17)
clearButton:SetHeight(17)
clearButton:SetPoint("RIGHT", TradeSkillFrameSearchBox, "RIGHT", -3, 0)
clearButton:SetScript("OnEnter", function(self) self.texture:SetAlpha(1.0) end)
clearButton:SetScript("OnLeave", function(self) self.texture:SetAlpha(0.5) end)
clearButton:SetScript("OnMouseDown", function(self) 
		if self:IsEnabled() then
			self.texture:SetPoint("TOPLEFT", 1, -1);
		end
	end)
clearButton:SetScript("OnMouseUp", function(self) self.texture:SetPoint("TOPLEFT", 0, 0) end)
clearButton:SetScript("OnClick", function(self) 
		PlaySound("igMainMenuOptionCheckBoxOn")
		local editBox = self:GetParent()
		if editBox.clearFunc then
			editBox.clearFunc(editBox)
		end

		editBox:SetText("")
		if not editBox:HasFocus() then
			editBox:GetScript("OnEditFocusLost")(editBox)
		end
		editBox:ClearFocus()
	end)

local clearButtonTexture = clearButton:CreateTexture("BTSWClearButton", "ARTWORK")
clearButtonTexture:SetTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
clearButtonTexture:SetPoint("TOPLEFT", TradeSkillFrameSearchBoxClearButton, "TOPLEFT", 0, 0)
clearButtonTexture:SetWidth(17)
clearButtonTexture:SetHeight(17)

clearButton.texture = clearButtonTexture


function BTSW.ShowClearButtonWhenNeeded(self)
	local text = self:GetText();
	if (text == SEARCH) then
		if self:HasFocus() then self:SetText("") end
		TradeSkillFrameSearchBoxClearButton:Hide()
	else
		TradeSkillFrameSearchBoxClearButton:Show()
	end 
end

-- Hooks for updating the visibility of the clear button
TradeSkillFrameSearchBox:HookScript("OnEditFocusLost", BTSW.ShowClearButtonWhenNeeded)
TradeSkillFrameSearchBox:HookScript("OnTextChanged", BTSW.ShowClearButtonWhenNeeded)
TradeSkillFrameSearchBox:HookScript("OnEditFocusGained", BTSW.ShowClearButtonWhenNeeded)


-- Blizzard FilterButton
TradeSkillFilterButton:Hide()

-- Mats filter
if (not BTSWHaveMatsCheck) then
	CreateFrame("CheckButton", "BTSWHaveMatsCheck", TradeSkillFrame, "UICheckButtonTemplate ")
end 

BTSWHaveMatsCheck:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 66, -29)
BTSWHaveMatsCheck:SetWidth(24)
BTSWHaveMatsCheck:SetHeight(24)
BTSWHaveMatsCheckText:SetText(CRAFT_IS_MAKEABLE)
BTSWHaveMatsCheckText:SetWidth(80)
BTSWHaveMatsCheckText:SetJustifyH("LEFT")
BTSWHaveMatsCheck:SetHitRectInsets(0, -1 * BTSWHaveMatsCheckText:GetWidth() , 0, 0) -- Increase click area so text is also clickable

BTSWHaveMatsCheck:SetScript("OnClick", function(self)
	TradeSkillFrame.filterTbl.hasMaterials = not TradeSkillFrame.filterTbl.hasMaterials
	TradeSkillOnlyShowMakeable(TradeSkillFrame.filterTbl.hasMaterials)
	TradeSkillUpdateFilterBar()
end)   

function BTSW.TradeSkillOnlyShowMakeable(show)
	BTSWHaveMatsCheck:SetChecked(show)
end

-- Skillup filter
if (not BTSWOnlySkillupCheck) then
	CreateFrame("CheckButton", "BTSWOnlySkillupCheck", TradeSkillFrame, "UICheckButtonTemplate")
end 

BTSWOnlySkillupCheck:SetPoint("LEFT", BTSWHaveMatsCheck, "RIGHT", 80, 0)
BTSWOnlySkillupCheck:SetWidth(24)
BTSWOnlySkillupCheck:SetHeight(24)
BTSWOnlySkillupCheckText:SetText(TRADESKILL_FILTER_HAS_SKILL_UP)
BTSWOnlySkillupCheckText:SetWidth(80)
BTSWOnlySkillupCheckText:SetJustifyH("LEFT")
BTSWOnlySkillupCheck:SetHitRectInsets(0, -1 * BTSWOnlySkillupCheckText:GetWidth() , 0, 0) -- Increase click area so text is also clickable

BTSWOnlySkillupCheck:SetScript("OnClick", function(self)
	  TradeSkillFrame.filterTbl.hasSkillUp = not TradeSkillFrame.filterTbl.hasSkillUp
	  TradeSkillOnlyShowSkillUps(TradeSkillFrame.filterTbl.hasSkillUp)
	  TradeSkillUpdateFilterBar()
end)

function BTSW.TradeSkillOnlyShowSkillUps(show)
	BTSWOnlySkillupCheck:SetChecked(show)
end

-- Subclass filter
if not BTSWSubClassFilterDropDown then
   CreateFrame("Button", "BTSWSubClassFilterDropDown", TradeSkillFrame, "UIDropDownMenuTemplate")
end

BTSWSubClassFilterDropDown:ClearAllPoints()
BTSWSubClassFilterDropDown:SetPoint("TOPLEFT", TradeSkillRankFrame, "BOTTOMLEFT", -20, -4)
BTSWSubClassFilterDropDown:Show()
BTSWSubClassFilterDropDownButton:SetHitRectInsets(-110, 0, 0, 0) -- To make Text part of combobox clickable

UIDropDownMenu_SetWidth(BTSWSubClassFilterDropDown, 115); -- Need to set the width explicitly so text will be truncated correctly

-- Slot filter
if not BTSWSlotFilterDropDown then
   CreateFrame("Button", "BTSWSlotFilterDropDown", TradeSkillFrame, "UIDropDownMenuTemplate")
end

BTSWSlotFilterDropDown:ClearAllPoints()
BTSWSlotFilterDropDown:SetPoint("TOP", BTSWSubClassFilterDropDown, "TOP")
BTSWSlotFilterDropDown:SetPoint("RIGHT", TradeSkillFrame, "RIGHT", 9, 0)
BTSWSlotFilterDropDown:Show()
BTSWSlotFilterDropDownButton:SetHitRectInsets(-110, 0, 0, 0) -- To make Text part of combobox clickable

UIDropDownMenu_SetWidth(BTSWSlotFilterDropDown, 115); -- Need to set the width explicitly so text will be truncated correctly

-- Add a vertical bar between the recipelist and the details pane
-- Usually the scrollbar will be over it, but when there is no scrollbar this one shows and looks better
if (not BTSWVerticalBarTop) then
   BTSWVerticalBarTop = TradeSkillFrame:CreateTexture("BTSWVerticalBarTop", "BACKGROUND")
end
BTSWVerticalBarTop:SetTexture("Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar")
BTSWVerticalBarTop:SetTexCoord(0, 0.1875, 0, 1.0) 
BTSWVerticalBarTop:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame, "TOPLEFT", -7, 0)
BTSWVerticalBarTop:SetWidth(8)
BTSWVerticalBarTop:SetHeight(128)

if (not BTSWVerticalBarMiddle) then
   BTSWVerticalBarMiddle = TradeSkillFrame:CreateTexture("BTSWVerticalBarMiddle", "BACKGROUND")
end
BTSWVerticalBarMiddle:SetTexture("Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar")
BTSWVerticalBarMiddle:SetTexCoord(0.421875, 0.5625, 0, 1.0) 
BTSWVerticalBarMiddle:SetPoint("TOPLEFT", BTSWVerticalBarTop, "BOTTOMLEFT", 0, 0)
BTSWVerticalBarMiddle:SetWidth(7)
BTSWVerticalBarMiddle:SetHeight(159)

if (not BTSWVerticalBarBottom) then
   BTSWVerticalBarBottom = TradeSkillFrame:CreateTexture("BTSWVerticalBarBottom", "BACKGROUND")
end
BTSWVerticalBarBottom:SetTexture("Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar")
BTSWVerticalBarBottom:SetTexCoord(0.8125, 1, 0, 1.0) 
BTSWVerticalBarBottom:SetPoint("TOPLEFT", BTSWVerticalBarMiddle, "BOTTOMLEFT", 0, 0)
BTSWVerticalBarBottom:SetWidth(8)
BTSWVerticalBarBottom:SetHeight(128)

-- Detail frame with the ingredients
TradeSkillDetailScrollFrame:ClearAllPoints()
TradeSkillDetailScrollFrame:SetPoint("RIGHT", TradeSkillFrame, "RIGHT", -31, 0)
TradeSkillDetailScrollFrame:SetPoint("LEFT", TradeSkillFrame, "RIGHT", -218, 0)
TradeSkillDetailScrollFrame:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -86)
TradeSkillDetailScrollFrame:SetPoint("BOTTOM", TradeSkillFrame, "BOTTOM", 0, 30)

-- Re-anchor icons, text and stuff
TradeSkillDetailHeaderLeft:SetPoint("TOPLEFT", TradeSkillDetailScrollChildFrame, "TOPLEFT", 3, -5)
TradeSkillDetailHeaderLeft:SetWidth(140)
TradeSkillDetailHeaderLeft:SetTexCoord(0, 0.56, 0, 1)
TradeSkillDetailHeaderLeft:Show()

TradeSkillSkillIcon:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "TOPLEFT", 8, -6)

TradeSkillSkillName:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "TOPLEFT", 50, -4)
TradeSkillSkillName:SetPoint("RIGHT", TradeSkillDetailScrollFrame, "RIGHT", -5, 0)
TradeSkillSkillName:SetHeight(40)

-- Description and requirements swapped places cause it looks better.
-- Note that the anchors get reset when the recipe detail display is updated
-- So need to reapply this when that happens (hook TradeSkillFrame_SetSelection)
-- The values in the hook function are leading when they are different from here
TradeSkillDescription:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "BOTTOMLEFT", 5, 5)
TradeSkillDescription:SetWidth(180)  -- Set a width that matches the real width for the autosizing 
									 -- to work. Smaller widths seem to add height, bigger widths 
									 -- will cut off the text instead of expanding the textheight

-- Recolor label so it looks better
TradeSkillRequirementLabel:SetTextColor(TradeSkillReagentLabel:GetTextColor())
TradeSkillRequirementLabel:SetShadowColor(TradeSkillReagentLabel:GetShadowColor())
TradeSkillRequirementLabel:SetPoint("TOPLEFT", TradeSkillDescription, "BOTTOMLEFT", 0, -15)
TradeSkillRequirementText:SetPoint("TOPLEFT", TradeSkillRequirementLabel, "BOTTOMLEFT", 0, 0)

TradeSkillReagentLabel:SetPoint("TOPLEFT", TradeSkillRequirementText, "BOTTOMLEFT", 0, -15)

-- Reposition reagent buttons
_G["TradeSkillReagent1"]:SetPoint("RIGHT", TradeSkillDetailScrollFrame, "RIGHT")
for i=2, MAX_TRADE_SKILL_REAGENTS do
   local reagentButton = _G["TradeSkillReagent"..i]
   
   reagentButton:ClearAllPoints()
   reagentButton:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-1)], "BOTTOMLEFT", 0, -3)
   reagentButton:SetPoint("RIGHT", TradeSkillDetailScrollFrame, "RIGHT")
end

-- Background for reagents/detailarea
-- Note that the background is also needed to hide a part of the original
-- horizontal bar that I can't figure out how to hide.
local detailBackground = TradeSkillDetailScrollFrame:CreateTexture("BTSWTexDetailBackground","BACKGROUND")
detailBackground:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame)
detailBackground:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -10, 29)
detailBackground:SetTexCoord(0, 0.2, 0, 1)  -- Mess with TexCoords so the texture does not look too compressed/stretched
detailBackground:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
--detailBackground:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment")
--detailBackground:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble")


-- Scrollbar of the recipe list
TradeSkillListScrollFrame:ClearAllPoints()
TradeSkillListScrollFrame:SetPoint("TOPRIGHT", TradeSkillDetailScrollFrame, "TOPLEFT", -28, 0)
TradeSkillListScrollFrame:SetPoint("BOTTOMRIGHT", TradeSkillDetailScrollFrame, "BOTTOMLEFT", -28, 0)

if (not BTSWTradeSkillListScrollBarMiddle) then
   -- Use horrible random name for texture. When using a proper name like BTSWTradeSkillListScrollBarMiddle
   -- the top and bottom parts of the scrollbar disappear
   BTSWTradeSkillListScrollBarMiddle = TradeSkillListScrollFrame:CreateTexture("BTSW_kjfeowjpfa", "BACKGROUND")
end
BTSWTradeSkillListScrollBarMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
BTSWTradeSkillListScrollBarMiddle:SetTexCoord(0, 0.45, 0.1640625, 1)
BTSWTradeSkillListScrollBarMiddle:SetPoint("TOPRIGHT", TradeSkillListScrollFrame, "TOPRIGHT", 27, -110)
BTSWTradeSkillListScrollBarMiddle:SetPoint("BOTTOMRIGHT", TradeSkillListScrollFrame, "BOTTOMRIGHT", 27, 120)
BTSWTradeSkillListScrollBarMiddle:SetWidth(29)

-- Scrollbar of the recipe details list
if (not BTSWDetailScrollBarMiddle) then
   -- Use horrible random name for texture. When using a proper name like BTSWTradeSkillListScrollBarMiddle
   -- the top and bottom parts of the scrollbar disappear
   BTSWDetailScrollBarMiddle = TradeSkillDetailScrollFrame:CreateTexture("BTSW_afiepipnp", "BACKGROUND")
   -- Additional blackish background for in the scrollbar, just because it looks better
   BTSWDetailScrollBarMiddleBackground = TradeSkillDetailScrollFrame:CreateTexture("BTSWMiddle2Background", "BACKGROUND")
end
BTSWDetailScrollBarMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
BTSWDetailScrollBarMiddle:SetTexCoord(0, 0.44, 0.1640625, 1)
BTSWDetailScrollBarMiddle:SetPoint("TOPRIGHT", TradeSkillDetailScrollFrame, "TOPRIGHT", 28, -110)
BTSWDetailScrollBarMiddle:SetPoint("BOTTOMRIGHT", TradeSkillDetailScrollFrame, "BOTTOMRIGHT", 28, 120)
BTSWDetailScrollBarMiddle:SetWidth(29)
BTSWDetailScrollBarMiddle:SetParent(TradeSkillDetailScrollFrameScrollBar)  -- Reparent to make it hide properly

BTSWDetailScrollBarMiddleBackground:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble")
BTSWDetailScrollBarMiddleBackground:SetAllPoints(TradeSkillDetailScrollFrameScrollBar)
BTSWDetailScrollBarMiddleBackground:SetParent(TradeSkillDetailScrollFrameScrollBar)  -- Reparent to make it hide properly
BTSWDetailScrollBarMiddleBackground:SetTexCoord(0, 0.2, 0, 1)

-- Reposition Create all button, decrement, and editbox.
-- The others are already at the right place
TradeSkillCreateAllButton:ClearAllPoints()
TradeSkillCreateAllButton:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMLEFT", 216, 4)



-- Functions for dropdowns, these are based on the old (3.3.5 patch) Blizzard code
-- Changes are mostly updates to use TradeSkillSetFilter to get the new Filterbar working

function BTSW.TradeSkillInvSlotDropDown_Initialize()
	BTSW.TradeSkillFilterFrame_LoadInvSlots(GetTradeSkillSubClassFilteredSlots(0));
end


function BTSW.TradeSkillFilterFrame_LoadInvSlots(...)
	local allChecked = GetTradeSkillInvSlotFilter(0);
	local filterCount = select("#", ...);

	local info = UIDropDownMenu_CreateInfo();

	info.text = ALL_INVENTORY_SLOTS;
	info.func = BTSW.TradeSkillInvSlotDropDownButton_OnClick;
	info.checked = allChecked;

	UIDropDownMenu_AddButton(info);

	local checked;
	for i=1, filterCount, 1 do
		if ( allChecked and filterCount > 1 ) then
			UIDropDownMenu_SetText(BTSWSlotFilterDropDown, ALL_INVENTORY_SLOTS);
		else
			checked = GetTradeSkillInvSlotFilter(i);
			if ( checked ) then
				UIDropDownMenu_SetText(BTSWSlotFilterDropDown, select(i, ...));
			end
		end

		info.text = select(i, ...);
		info.func = BTSW.TradeSkillInvSlotDropDownButton_OnClick;
		info.checked = checked;

		UIDropDownMenu_AddButton(info);
	end
end


function BTSW.TradeSkillFilterFrame_InvSlotName(...)
	for i=1, select("#", ...), 1 do
		if ( GetTradeSkillInvSlotFilter(i) ) then
			return select(i, ...);
		end
	end
end


function BTSW.TradeSkillInvSlotDropDownButton_OnClick(self)
	local selectedId = self:GetID()
	local selectedName = self:GetText()

	UIDropDownMenu_SetSelectedID(BTSWSlotFilterDropDown, selectedId);

	-- The other dropdown goes back to the "All xxx" option
	UIDropDownMenu_SetSelectedID(BTSWSubClassFilterDropDown, 1);
	UIDropDownMenu_SetText(BTSWSubClassFilterDropDown, ALL_SUBCLASSES);

	BTSW.TradeSkillSetFilter(0, selectedId-1, "", selectedName)
end


function BTSW.TradeSkillSetFilter(selectedSubclassId, selectedSlotId, selectedSubclassName, selectedSlotName, subclassCategory)
--print(selectedSubclassId, "-", selectedSlotId, "-", selectedSubclassName, "-", selectedSlotName, "-", subclassCategory)
	TradeSkillSetFilter(selectedSubclassId, selectedSlotId, selectedSubclassName, selectedSlotName, subclassCategory)
end


function BTSW.TradeSkillSubClassDropDown_Initialize()
	BTSW.TradeSkillFilterFrame_LoadSubClasses(GetTradeSkillSubClasses());
end


function BTSW.TradeSkillFilterFrame_LoadSubClasses(...)
	local selectedID = UIDropDownMenu_GetSelectedID(BTSWSubClassFilterDropDown);
	local numSubClasses = select("#", ...);
	local allChecked = GetTradeSkillSubClasses(0);

	-- the first button in the list is going to be an "all subclasses" button
	local info = UIDropDownMenu_CreateInfo();
	info.text = ALL_SUBCLASSES;
	info.func = BTSW.TradeSkillSubClassDropDownButton_OnClick;
	info.checked = allChecked and (selectedID == nil or selectedID == 1);
	info.value = 0;
	UIDropDownMenu_AddButton(info);
	if ( info.checked ) then
		UIDropDownMenu_SetText(BTSWSubClassFilterDropDown, ALL_SUBCLASSES);
	end

	-- Add buttons for each subclass
	local checked;

	for i=1, select("#", ...), 1 do
		-- if there are no filters then don't check any individual subclasses
		if (allChecked) then
			checked = nil;
		else
			checked = GetTradeSkillSubClasses(i);
			if ( checked ) then
				UIDropDownMenu_SetText(BTSWSubClassFilterDropDown, select(i, ...));
			end
		end
		info.text = select(i, ...);
		info.func = BTSW.TradeSkillSubClassDropDownButton_OnClick;
		info.checked = checked;
		info.value = i;

		if (info.text) then -- The subclasses like "Everyday Cooking" that Pandaren Cuisine has returns nil on the text. Don't add those
			UIDropDownMenu_AddButton(info);
		end
	end
end


function BTSW.TradeSkillSubClassDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(BTSWSubClassFilterDropDown, self:GetID());

	-- The other dropdown goes back to the "All xxx" option
	UIDropDownMenu_SetSelectedID(BTSWSlotFilterDropDown, 1);
	UIDropDownMenu_SetText(BTSWSlotFilterDropDown, ALL_INVENTORY_SLOTS);

	BTSW.TradeSkillSetFilter(self.value, 0, self:GetText(), "", 0)
end


-- This is needed to detect switching between professions and resetting the slot/subclass filters
-- so that no invalid values are selected (for example Plate on the Firstaid profession when switching from BS)
-- Also taken from the old code btw
function BTSW.TradeSkillFrame_Update()
	local name, rank, maxRank = GetTradeSkillLine();
			
	if ( BTSW.CURRENT_TRADESKILL ~= name ) then
--		StopTradeSkillRepeat();

		if ( BTSW.CURRENT_TRADESKILL ~= "" ) then
			-- To fix problem with switching between two tradeskills
			UIDropDownMenu_Initialize(BTSWSlotFilterDropDown, BTSW.TradeSkillInvSlotDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(BTSWSlotFilterDropDown, 1);

			UIDropDownMenu_Initialize(BTSWSubClassFilterDropDown, BTSW.TradeSkillSubClassDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(BTSWSubClassFilterDropDown, 1);
		end
		BTSW.CURRENT_TRADESKILL = name;
	end
end


-- Controls get reanchored in the TradeSkillFrame_SetSelection function
-- Basically reanchor everything in the detail frame to my liking
function BTSW.TradeSkillFrame_SetSelection()

	local anchorTo = TradeSkillDetailHeaderLeft
	local anchorOffsetX = 5
	local anchorOffsetY = 5

	-- Add Auctionator AH button on the left side so people with small screens can still see it while at the AH
	-- since the BiggerTradeSkillUI can be partly offscreen then
	if (Auctionator_Search) then
		Auctionator_Search:ClearAllPoints()
		Auctionator_Search:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, 10)

		anchorTo = Auctionator_Search
		anchorOffsetX = 0
		anchorOffsetY = -10
	end

	-- Cooldown
	if (TradeSkillSkillCooldown:GetText()) then
		TradeSkillSkillCooldown:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY+5) -- +5 looks better

		anchorTo = TradeSkillSkillCooldown
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Description
	if (strlen(TradeSkillDescription:GetText()) <= 2) then  -- <= 2 because there is the text " " in it when empty
		TradeSkillDescription:Hide()
	else
		TradeSkillDescription:Show()
		TradeSkillDescription:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)

		anchorTo = TradeSkillDescription
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Requirements
	if (TradeSkillRequirementText:GetText()) then
		TradeSkillRequirementLabel:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)

		anchorTo = TradeSkillRequirementText
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Reagents
	TradeSkillReagentLabel:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)
end


-- Hook functions
hooksecurefunc("TradeSkillFrame_Update", BTSW.TradeSkillFrame_Update)
hooksecurefunc("TradeSkillFrame_SetSelection", BTSW.TradeSkillFrame_SetSelection)
hooksecurefunc("TradeSkillOnlyShowMakeable", BTSW.TradeSkillOnlyShowMakeable)
hooksecurefunc("TradeSkillOnlyShowSkillUps", BTSW.TradeSkillOnlyShowSkillUps)


-- Update the filterdropdowns when the Filterbar is closed
local originalTradeSkillFilterBarExitButtonOnHideHandler = TradeSkillFilterBarExitButton:GetScript("OnHide")
TradeSkillFilterBarExitButton:SetScript("OnHide", function(...)

	if (originalTradeSkillFilterBarExitButtonOnHideHandler) then
		originalTradeSkillFilterBarExitButtonOnHideHandler(...)
	end

	UIDropDownMenu_Initialize(BTSWSlotFilterDropDown, BTSW.TradeSkillInvSlotDropDown_Initialize)
	UIDropDownMenu_SetSelectedID(BTSWSlotFilterDropDown, 1);

	UIDropDownMenu_Initialize(BTSWSubClassFilterDropDown, BTSW.TradeSkillSubClassDropDown_Initialize)
	UIDropDownMenu_SetSelectedID(BTSWSubClassFilterDropDown, 1);

end
)