local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMinimap'].enable ~= true then return end

    -- A 'new' mail notification

MiniMapMailFrame:SetSize(14, 14)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -4, 5)

MiniMapMailBorder:SetTexture(nil)
MiniMapMailIcon:SetTexture(nil)

hooksecurefunc(MiniMapMailFrame, 'Show', function()
    MiniMapMailBorder:SetTexture(nil)
    MiniMapMailIcon:SetTexture(nil)
end)

MiniMapMailFrame.Text = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
MiniMapMailFrame.Text:SetFont(C['nMedia'].font, 15, 'OUTLINE')
MiniMapMailFrame.Text:SetPoint('BOTTOMRIGHT', MiniMapMailFrame)
MiniMapMailFrame.Text:SetTextColor(1, 0, 1)
MiniMapMailFrame.Text:SetText('N')

   -- Modify the lfg frame

QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint('TOPLEFT', Minimap, 4, -4)
QueueStatusMinimapButton:SetSize(14, 14)
QueueStatusMinimapButton:SetHighlightTexture(nil)

QueueStatusMinimapButtonBorder:SetTexture()
QueueStatusMinimapButton.Eye:Hide()

hooksecurefunc('EyeTemplate_StartAnimating', function(self)
    self:SetScript('OnUpdate', nil)
end)

QueueStatusMinimapButton.Text = QueueStatusMinimapButton:CreateFontString(nil, 'OVERLAY')
QueueStatusMinimapButton.Text:SetFont(C['nMedia'].font, 15, 'OUTLINE')
QueueStatusMinimapButton.Text:SetPoint('TOP', QueueStatusMinimapButton)
QueueStatusMinimapButton.Text:SetTextColor(1, 0.4, 0)
QueueStatusMinimapButton.Text:SetText('Q')

    -- Hide all unwanted things

MinimapZoomIn:Hide()
MinimapZoomIn:UnregisterAllEvents()

MinimapZoomOut:Hide()
MinimapZoomOut:UnregisterAllEvents()

MiniMapWorldMapButton:Hide()
MiniMapWorldMapButton:UnregisterAllEvents()

MinimapNorthTag:SetAlpha(0)

MinimapBorder:Hide()
MinimapBorderTop:Hide()

MinimapZoneText:Hide()

MinimapZoneTextButton:Hide()
MinimapZoneTextButton:UnregisterAllEvents()

    -- Hide the tracking button

MiniMapTracking:UnregisterAllEvents()
MiniMapTracking:Hide()

    -- hide the durability frame (the armored man)

DurabilityFrame:Hide()
DurabilityFrame:UnregisterAllEvents()

    -- Bigger minimap

MinimapCluster:SetScale(1.1)
MinimapCluster:EnableMouse(false)

    -- New position

Minimap:ClearAllPoints()
Minimap:SetPoint('TOPRIGHT', UIParent, -26, -26)

    -- Square minimap and create a border

function GetMinimapShape()
    return 'SQUARE'
end

Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
Minimap:CreateBeautyBorder(12)
Minimap:SetBeautyBorderPadding(1)
Minimap:SetBeautyBorderTexture('white')
if C['nMedia'].border == "Default" then
	Minimap:SetBeautyBorderColor(0.38, 0.38, 0.38)		
elseif C['nMedia'].border == "Classcolor" then
	Minimap:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
elseif C['nMedia'].border == "Custom" then
	Minimap:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
end	

    -- Enable mousewheel zooming

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if (delta > 0) then
        _G.MinimapZoomIn:Click()
    elseif delta < 0 then
        _G.MinimapZoomOut:Click()
    end
end)

    -- Modify the minimap tracking

Minimap:SetScript('OnMouseUp', function(self, button)
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    else
        Minimap_OnClick(self)
    end
end)

    -- Skin the ticket status frame

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, -25, -33)
TicketStatusFrameButton:HookScript('OnShow', function(self)
    self:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = 3, 
            right = 3, 
            top = 3, 
            bottom = 3
        }
    })
    self:SetBackdropColor(0, 0, 0, 0.5)
    self:CreateBeautyBorder(12)
	self:SetBeautyBorderTexture('white')
	if C['nMedia'].border == "Default" then
		self:SetBeautyBorderColor(0.38, 0.38, 0.38)		
	elseif C['nMedia'].border == "Classcolor" then
		self:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
	elseif C['nMedia'].border == "Custom" then
		self:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
	end		
end)

local function GetZoneColor()
    local zoneType = GetZonePVPInfo()
    if (zoneType == 'sanctuary') then
        return 0.4, 0.8, 0.94
    elseif (zoneType == 'arena') then
        return 1, 0.1, 0.1
    elseif (zoneType == 'friendly') then
        return 0.1, 1, 0.1
    elseif (zoneType == 'hostile') then
        return 1, 0.1, 0.1
    elseif (zoneType == 'contested') then
        return 1, 0.8, 0
    else
        return 1, 1, 1
    end
end

    -- Mouseover zone text

if (C['nMinimap'].mouseover.zoneText) then
    local MainZone = Minimap:CreateFontString(nil, 'OVERLAY')
    MainZone:SetFont(C['nMedia'].font, 16, 'THINOUTLINE')
    MainZone:SetPoint('TOP', Minimap, 0, -22)
    MainZone:SetTextColor(1, 1, 1)
    MainZone:SetAlpha(0)
    MainZone:SetSize(130, 32)
    MainZone:SetJustifyV('BOTTOM')

    local SubZone = Minimap:CreateFontString(nil, 'OVERLAY')
    SubZone:SetFont(C['nMedia'].font, 13, 'THINOUTLINE')
    SubZone:SetPoint('TOP', MainZone, 'BOTTOM', 0, -1)
    SubZone:SetTextColor(1, 1, 1)
    SubZone:SetAlpha(0)
    SubZone:SetSize(130, 26)
    SubZone:SetJustifyV('TOP')

    Minimap:HookScript('OnEnter', function()
        if (not IsShiftKeyDown()) then
            SubZone:SetTextColor(GetZoneColor())
            SubZone:SetText(GetSubZoneText())
            securecall('UIFrameFadeIn', SubZone, 0.15, SubZone:GetAlpha(), 1)

            MainZone:SetTextColor(GetZoneColor())
            MainZone:SetText(GetRealZoneText())
            securecall('UIFrameFadeIn', MainZone, 0.15, MainZone:GetAlpha(), 1)
        end
    end)

    Minimap:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', SubZone, 0.15, SubZone:GetAlpha(), 0)
        securecall('UIFrameFadeOut', MainZone, 0.15, MainZone:GetAlpha(), 0)
    end)
end