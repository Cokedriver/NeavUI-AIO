local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nCore'].mail ~= true then return end


local f = CreateFrame('Button', nil, InboxFrame, 'UIPanelButtonTemplate')
f:SetPoint("CENTER", InboxFrame, "TOP", -25, -396)
f:SetSize(100, 22)
f:SetText(OPENMAIL)

local processing = false
local function OnEvent()
	if (not MailFrame:IsShown()) then 
        return 
    end

	local num = GetInboxNumItems()
	if (processing) then
		if (num == 0) then
			MiniMapMailFrame:Hide()
			processing = false
			return
		end

		for i = num, 1, -1 do
			local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
			if (item and COD < 1) then
				TakeInboxItem(i)
				return
			end

			if (money > 0) then
				TakeInboxMoney(i)
				return
			end
		end
	end
end

f:RegisterEvent('MAIL_INBOX_UPDATE')
f:SetScript('OnEvent', OnEvent)
f:SetScript('OnClick', function(self) 
    if (not processing) then 
        processing = true 
        OnEvent() 
    end 
end)

f:SetScript('OnHide', function(self) 
    processing = false 
end)