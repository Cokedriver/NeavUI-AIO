local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nCore'].skins ~= true then return end

local f = CreateFrame('Frame')
f:RegisterEvent('VARIABLES_LOADED')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')

f:SetScript('OnEvent', function(self)
    if (IsAddOnLoaded('Omen')) then
        if (not OmenBarList.beautyBorder) then
            OmenBarList:CreateBeautyBorder(12)
            OmenBarList:SetBeautyBorderPadding(3)
			OmenBarList:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				OmenBarList:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				OmenBarList:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				OmenBarList:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end				
        end
    end

        -- a example for addons like pitbull

    --[[ 
    if (IsAddOnLoaded('PitBull4')) then
        f:SetScript('OnUpdate', function(self)
                
                -- works fine because beautycase will not create multiple textures/borders
                
            for _, pitframe in pairs({
                PitBull4_Frames_player,
                PitBull4_Frames_target,
                PitBull4_Frames_targettarget,
            }) do
                if (pitframe:IsShown()) then
                    pitframe:CreateBeautyBorder(12)
                    pitframe:SetBeautyBorderPadding(2)
                end
            end
        end)
    end
    --]]

    if (IsAddOnLoaded('DBM-Core')) then
        hooksecurefunc(DBT, 'CreateBar', function(self)
            for bar in self:GetBarIterator() do
                local frame = bar.frame
                local tbar = _G[frame:GetName()..'Bar']
                local spark = _G[frame:GetName()..'BarSpark']
                local texture = _G[frame:GetName()..'BarTexture']
                local icon1 = _G[frame:GetName()..'BarIcon1']
                local icon2 = _G[frame:GetName()..'BarIcon2']
                local name = _G[frame:GetName()..'BarName']
                local timer = _G[frame:GetName()..'BarTimer']

                spark:SetTexture(nil)

                timer:ClearAllPoints()
                timer:SetPoint('RIGHT', tbar, 'RIGHT', -4, 0)
                timer:SetFont(C['nMedia'].font, 22)
                timer:SetJustifyH('RIGHT')

                name:ClearAllPoints()
                name:SetPoint('LEFT', tbar, 4, 0)
                name:SetPoint('RIGHT', timer, 'LEFT', -4, 0)
                name:SetFont(C['nMedia'].font, 15)

                tbar:SetHeight(24)
                tbar:CreateBeautyBorder(12)
				tbar:SetBeautyBorderTexture('white')
				if C['nMedia'].border == "Default" then
					tbar:SetBeautyBorderColor(0.38, 0.38, 0.38)		
				elseif C['nMedia'].border == "Classcolor" then
					tbar:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
				elseif C['nMedia'].border == "Custom" then
					tbar:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
				end					
                tbar:SetBeautyBorderPadding(tbar:GetHeight() + 3, 2, 2, 2, tbar:GetHeight() + 3, 2, 2, 2)
                tbar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
                tbar:SetBackdropColor(0, 0, 0, 0.5)

                icon1:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                icon1:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)

                icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                icon2:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)
            end
        end)

            -- hide the pesky range check

        DBM.RangeCheck:Show()
        DBM.RangeCheck:Hide()
        DBMRangeCheck:HookScript('OnShow', function(self)
            self:Hide()
            self.Show = function() end
        end)
    end

    if (IsAddOnLoaded('TinyDPS')) then
        if (not tdpsFrame.beautyBorder) then
            tdpsFrame:CreateBeautyBorder(12)
            tdpsFrame:SetBeautyBorderPadding(2)
			tdpsFrame:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				tdpsFrame:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				tdpsFrame:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				tdpsFrame:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end				
            tdpsFrame:SetBackdrop({
                bgFile = 'Interface\\Buttons\\WHITE8x8',
                insets = { left = 0, right = 0, top = 0, bottom = 0 },
            })
            tdpsFrame:SetBackdropColor(0, 0, 0, 0.5)
        end
    end

    if (IsAddOnLoaded('Recount')) then
        if (not Recount.MainWindow.beautyBorder) then
            Recount.MainWindow:CreateBeautyBorder(12)
			Recount.MainWindow:SetBeautyBorderTexture('white')
			if C['nMedia'].border == "Default" then
				Recount.MainWindow:SetBeautyBorderColor(0.38, 0.38, 0.38)		
			elseif C['nMedia'].border == "Classcolor" then
				Recount.MainWindow:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
			elseif C['nMedia'].border == "Custom" then
				Recount.MainWindow:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
			end				
            Recount.MainWindow:SetBeautyBorderPadding(2, -10, 2, -10, 2, 2, 2, 2)
            Recount.MainWindow:SetBackdrop({
                bgFile = 'Interface\\Buttons\\WHITE8x8',
                insets = { left = 0, right = 0, top = 10, bottom = 0 },
            })
            Recount.MainWindow:SetBackdropColor(0, 0, 0, 0.5)
        end
    end
end)
