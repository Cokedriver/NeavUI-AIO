local B, C, DB = unpack(select(2, ...)) -- Import:  B - function; C - config; DB - Database

---------------------------------------
-- Crafting Bind On Pickup Warning Box
---------------------------------------
-- Credit for CBOP goes to oscarucb for his BOP Craft Confirm addon.
-- You can find the original addon at http://www.wowace.com/addons/bopcraftconfirm/files/
-- Edited by Cokedriver


if C["nCore"].cbop ~= true then return end


local addonName, vars = ...
BasicUI = vars
local addon = BasicUI
local settings

local L = setmetatable({}, { __index = function(t,k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

local defaults = {
  debug = false,
  always = {
  },
}

local function chatMsg(msg) 
	 DEFAULT_CHAT_FRAME:AddMessage(addonName..": "..msg)
end
local function debug(msg) 
  if settings and settings.debug then
	 chatMsg(msg)
  end
end

addon.scantt = CreateFrame("GameTooltip", addonName.."_Tooltip", UIParent, "GameTooltipTemplate")

local function OnEvent(frame, event, name, ...)
  if event == "ADDON_LOADED" and string.upper(name) == string.upper(addonName) then
	 debug("ADDON_LOADED: "..name)
	 BasicDB = BasicDB or {}
	 settings = BasicDB
	 for k,v in pairs(defaults) do
	   if settings[k] == nil then
		 settings[k] = defaults[k]
	   end
	 end
  end
end
local frame = CreateFrame("Button", addonName.."HiddenFrame", UIParent)
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", OnEvent);

local blizzard_DoTradeSkill
local save_idx, save_cnt, save_link
local function bopcc_DoTradeSkill(idx,cnt)   
   local link = GetTradeSkillItemLink(idx)
   debug(link,idx,cnt)   

   if not link then
	 blizzard_DoTradeSkill(idx,cnt)
	 return
   end

   local bop
   addon.scantt:ClearLines()
   addon.scantt:SetOwner(UIParent, "ANCHOR_NONE");
   addon.scantt:SetHyperlink(link)
   for i=1,addon.scantt:NumLines() do
	 local line = getglobal(addon.scantt:GetName() .. "TextLeft"..i)
	 local text = line and line:GetText()
	 if text and text:find(ITEM_BIND_ON_PICKUP) then
	   bop = ITEM_BIND_ON_PICKUP
	   break
	 elseif text and text:find(ITEM_BIND_TO_ACCOUNT) then
	   bop = ITEM_BIND_TO_ACCOUNT
	   break
	 elseif text and text:find(ITEM_BIND_TO_BNETACCOUNT) then
	   bop = ITEM_BIND_TO_BNETACCOUNT
	   break
	 elseif text and (text:find(ITEM_BIND_ON_USE) or text:find(ITEM_BIND_ON_EQUIP)) then
	   break
	 end
   end

   if settings and settings.always and settings.always[link] then
	  debug("Confirm suppressed: "..link)
	  bop = nil
   end

   if bop then
	 save_idx = idx
	 save_cnt = cnt
	 save_link = link
	 StaticPopupDialogs["BOPCRAFTCONFIRM_CONFIRM"].text =  
		save_link.."\n"..bop.."\n"..L["Crafting this item will bind it to you."]
	 StaticPopup_Show("BOPCRAFTCONFIRM_CONFIRM")
   else
	 blizzard_DoTradeSkill(idx,cnt)
   end
end

blizzard_DoTradeSkill = _G["DoTradeSkill"]
_G["DoTradeSkill"] = bopcc_DoTradeSkill

local function isValid()
   if not save_idx or not save_link then return false end
   local link = GetTradeSkillItemLink(save_idx)
   return link == save_link
end

local function CraftConfirmed()
   local link = save_link or "<unknown>"
   if not isValid() then -- trade window changed
	 debug("CraftConfirmed: Aborting "..link)
	 return
   end
   debug("CraftConfirmed: "..link)
   blizzard_DoTradeSkill(save_idx,save_cnt)
end

local function AlwaysConfirmed(_,reason)
  if reason == "override" then 
	 debug("AlwaysConfirmed: override abort")
	 return
  end
  local link = save_link or "<unknown>"
  if not isValid() then -- trade window changed
	 debug("AlwaysConfirmed: Aborting "..link)
	 return
  end
  debug("AlwaysConfirmed: "..save_link)
  settings.always[save_link] = true
  CraftConfirmed()
end

StaticPopupDialogs["BOPCRAFTCONFIRM_CONFIRM"] = {
  preferredIndex = 3, -- prevent taint
  text = "dummy",
  button1 = OKAY,
  button2 = ALWAYS.." "..OKAY,
  button3 = CANCEL,
  OnAccept = CraftConfirmed,
  OnCancel = AlwaysConfirmed, -- second button
  timeout = 0,
  hideOnEscape = false, -- this clicks always
  -- enterClicksFirstButton = true, -- this doesnt work (needs a hardware mouse click event?)
  showAlert = true,
}