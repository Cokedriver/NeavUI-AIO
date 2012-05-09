local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database


if C['nData'].enable ~= true then return end

--[[
	All Credit for Datapanel.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
]]

local DataPanel = CreateFrame('Frame', 'DataPanel', UIParent)
local PanelLeft = CreateFrame('Frame', 'PanelLeft', UIParent)
local PanelCenter = CreateFrame('Frame', 'PanelCenter', UIParent)
local PanelRight = CreateFrame('Frame', 'PanelRight', UIParent)
local BattleGroundPanel = CreateFrame('Frame', 'BattleGroundPanel', UIParent)
	
if not C['nMainbar'].MainMenuBar.shortBar then
	DataPanel:SetPoint('BOTTOM', UIParent, 0, 0)
	DataPanel:SetHeight(35)
	DataPanel:SetWidth(1200)
	DataPanel:SetFrameStrata('LOW')
	DataPanel:SetFrameLevel(0)
	DataPanel:SetBackdropColor(0, 0, 0, 1)
	
	-- Left Panel
	PanelLeft:SetPoint('LEFT', DataPanel, 5, 0)
	PanelLeft:SetHeight(35)
	PanelLeft:SetWidth(1200 / 3)
	PanelLeft:SetFrameStrata('LOW')
	PanelLeft:SetFrameLevel(1)		

	-- Center Panel
	PanelCenter:SetPoint('CENTER', DataPanel, 0, 0)
	PanelCenter:SetHeight(35)
	PanelCenter:SetWidth(1200 / 3)
	PanelCenter:SetFrameStrata('LOW')
	PanelCenter:SetFrameLevel(1)		

	-- Right panel
	PanelRight:SetPoint('RIGHT', DataPanel, -5, 0)
	PanelRight:SetHeight(35)
	PanelRight:SetWidth(1200 / 3)
	PanelRight:SetFrameStrata('LOW')
	PanelRight:SetFrameLevel(1)		

	-- Battleground Panel
	BattleGroundPanel:SetAllPoints(PanelLeft)
	BattleGroundPanel:SetFrameStrata('LOW')
	BattleGroundPanel:SetFrameLevel(1)
	
else 
	DataPanel:SetPoint('BOTTOM', UIParent, 0, 0)
	DataPanel:SetHeight(35)
	DataPanel:SetWidth(725)
	DataPanel:SetFrameStrata('LOW')
	DataPanel:SetFrameLevel(0)
	DataPanel:SetBackdropColor(0, 0, 0, 1)
	
	-- Left Panel
	PanelLeft:SetPoint('LEFT', DataPanel, 5, 0)
	PanelLeft:SetHeight(35)
	PanelLeft:SetWidth(725 / 2)
	PanelLeft:SetFrameStrata('LOW')
	PanelLeft:SetFrameLevel(1)				

	-- Right panel
	PanelRight:SetPoint('RIGHT', DataPanel, -5, 0)
	PanelRight:SetHeight(35)
	PanelRight:SetWidth(725 / 2)
	PanelRight:SetFrameStrata('LOW')
	PanelRight:SetFrameLevel(1)		

	-- Battleground Panel
	BattleGroundPanel:SetAllPoints(PanelLeft)
	BattleGroundPanel:SetFrameStrata('LOW')
	BattleGroundPanel:SetFrameLevel(1)		
	
end

if C['nData'].databorder == 'Blizzard' then
	DataPanel:SetBackdrop({
		bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
		edgeFile = "Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\UI-DialogBox-Border",
		edgeSize = 25,
		insets = {left = 9, right = 9, top = 9, bottom = 8}
	})
elseif C['nData'].databorder == 'Neav' then
	DataPanel:SetHeight(30)
	DataPanel:SetBackdrop({
		bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
		edgeSize = 25
	})		
	DataPanel:CreateBeautyBorder(12)
	DataPanel:SetBeautyBorderTexture('white')
	if C['nMedia'].border == "Default" then
		DataPanel:SetBeautyBorderColor(0.38, 0.38, 0.38)		
	elseif C['nMedia'].border == "Classcolor" then
		DataPanel:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
	elseif C['nMedia'].border == "Custom" then
		DataPanel:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
	end	
end


local bottom = function() end
if C['nData'].databorder == 'Neav' then
	MainMenuBar:ClearAllPoints() MainMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, 0) MainMenuBar.ClearAllPoints = bottom MainMenuBar.SetPoint = bottom
	VehicleMenuBar:ClearAllPoints() VehicleMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, 4) VehicleMenuBar.ClearAllPoints = bottom VehicleMenuBar.SetPoint = bottom
	PetActionBarFrame:ClearAllPoints() PetActionBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 40, 47) PetActionBarFrame.ClearAllPoints = bottom PetActionBarFrame.SetPoint = bottom	
	WorldStateAlwaysUpFrame:ClearAllPoints() WorldStateAlwaysUpFrame:SetPoint('TOP', -20, -40) WorldStateAlwaysUpFrame.ClearAllpoints = bottom WorldStateAlwaysUpFrame.Setpoint = bottom
	BuffFrame:ClearAllPoints() BuffFrame:SetPoint('TOP', MinimapCluster, -110, -15) BuffFrame.ClearAllPoints = bottom BuffFrame.SetPoint = bottom
else
	MainMenuBar:ClearAllPoints() MainMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, -3) MainMenuBar.ClearAllPoints = bottom MainMenuBar.SetPoint = bottom
	VehicleMenuBar:ClearAllPoints() VehicleMenuBar:SetPoint("BOTTOM", DataPanel, "TOP", 0, -3) VehicleMenuBar.ClearAllPoints = bottom VehicleMenuBar.SetPoint = bottom
	PetActionBarFrame:ClearAllPoints() PetActionBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 40, 47) PetActionBarFrame.ClearAllPoints = bottom PetActionBarFrame.SetPoint = bottom		
	WorldStateAlwaysUpFrame:ClearAllPoints() WorldStateAlwaysUpFrame:SetPoint('TOP', -20, -40) WorldStateAlwaysUpFrame.ClearAllpoints = bottom WorldStateAlwaysUpFrame.Setpoint = bottom
	BuffFrame:ClearAllPoints() BuffFrame:SetPoint('TOP', MinimapCluster, -110, -15) BuffFrame.ClearAllPoints = bottom BuffFrame.SetPoint = bottom
end	

-- Move the tooltip above the Actionbar
if C["nTooltip"].enable == true then
	hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
		self:SetPoint('BOTTOMRIGHT', UIParent, -95, 135)
	end)
end 

 -- Move the Bags above the Actionbar
CONTAINER_WIDTH = 192;
CONTAINER_SPACING = 5;
VISIBLE_CONTAINER_SPACING = 3;
CONTAINER_OFFSET_Y = 70;
CONTAINER_OFFSET_X = 0;

 
function updateContainerFrameAnchors()
	local _, xOffset, yOffset, _, _, _, _;
	local containerScale = 1;
	screenHeight = GetScreenHeight() / containerScale;
	-- Adjust the start anchor for bags depending on the multibars
	xOffset = CONTAINER_OFFSET_X / containerScale;
	yOffset = CONTAINER_OFFSET_Y / containerScale + 25;
	-- freeScreenHeight determines when to start a new column of bags
	freeScreenHeight = screenHeight - yOffset;
	column = 0;
	for index, frameName in ipairs(ContainerFrame1.bags) do
		frame = _G[frameName];
		frame:SetScale(containerScale);
		if ( index == 1 ) then
			-- First bag
			frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -xOffset, yOffset );
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1;
			freeScreenHeight = screenHeight - yOffset;
			frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -(column * CONTAINER_WIDTH) - xOffset, yOffset );
		else
			-- Anchor to the previous bag
			frame:SetPoint('BOTTOMRIGHT', ContainerFrame1.bags[index - 1], 'TOPRIGHT', 0, CONTAINER_SPACING);   
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
	end
end