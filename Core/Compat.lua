local addonName, MDT = ...
local API = MDT.API

local Compat = {}
MDT.Compat = Compat
MDT.AddonPath = "Interface\\AddOns\\"..addonName.."\\"
API.Compat = Compat

local addons = C_AddOns or {}

function Compat:IsAddOnLoaded(name)
  if addons.IsAddOnLoaded then
    local loadedOrLoading, loaded = addons.IsAddOnLoaded(name)
    return loaded == nil and not not loadedOrLoading or not not loaded
  end
  if not IsAddOnLoaded then return false end
  local loaded = IsAddOnLoaded(name)
  return not not loaded
end

function Compat:EnableAddOn(name)
  local fn = addons.EnableAddOn or EnableAddOn
  if not fn then return false end
  fn(name)
  return true
end

function Compat:LoadAddOn(name)
  local fn = addons.LoadAddOn or LoadAddOn
  if not fn then return false, "MISSING" end
  return fn(name)
end

function Compat:GetAddOnMetadata(name, field)
  local fn = addons.GetAddOnMetadata or GetAddOnMetadata
  return fn and fn(name, field)
end

function Compat:GetNumAddOns()
  local fn = addons.GetNumAddOns or GetNumAddOns
  return fn and fn() or 0
end

function Compat:GetAddOnInfo(index)
  local fn = addons.GetAddOnInfo or GetAddOnInfo
  return fn and fn(index)
end

function Compat:SendChatMessage(...)
  local fn = C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage
  if not fn then return false end
  fn(...)
  return true
end

function Compat:RequestLoadSpellData(spellId)
  if C_Spell and C_Spell.RequestLoadSpellData then
    C_Spell.RequestLoadSpellData(spellId)
  end
end

function Compat:GetBestMapForUnit(unit)
  return C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit(unit)
end

function Compat:GetMapInfo(mapId)
  return C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapId)
end

function Compat:GetCombatLogEventInfo()
  if not CombatLogGetCurrentEventInfo then return nil end
  return CombatLogGetCurrentEventInfo()
end

local menuFrame

local function newDescription(entries)
  local description = {}

  function description:CreateTitle(text)
    entries[#entries + 1] = { text = text, isTitle = true, notCheckable = true }
  end

  function description:CreateDivider()
    entries[#entries + 1] = { text = " ", disabled = true, notCheckable = true }
  end

  function description:CreateButton(text, callback)
    local children = {}
    local entry = { text = text, callback = callback, children = children, notCheckable = true }
    entries[#entries + 1] = entry
    return newDescription(children)
  end

  function description:CreateRadio(text, isSelected, setSelected, data)
    entries[#entries + 1] = {
      text = text,
      checked = function() return isSelected(data) end,
      callback = function() setSelected(data) end,
      isNotRadio = false,
    }
  end

  return description
end

local function addMenuEntries(entries, level)
  for index, entry in ipairs(entries) do
    local info = UIDropDownMenu_CreateInfo()
    info.text = entry.text
    info.isTitle = entry.isTitle
    info.disabled = entry.disabled
    info.notCheckable = entry.notCheckable
    info.isNotRadio = entry.isNotRadio
    info.checked = entry.checked
    info.func = entry.callback
    if entry.children and #entry.children > 0 then
      info.hasArrow = true
      info.menuList = entry.children
    end
    UIDropDownMenu_AddButton(info, level)
  end
end

function Compat:CreateContextMenu(ownerRegion, generator, ...)
  if MenuUtil and MenuUtil.CreateContextMenu then
    return MenuUtil.CreateContextMenu(ownerRegion, generator, ...)
  end
  if not (UIDropDownMenu_Initialize and UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton and ToggleDropDownMenu) then
    return nil
  end

  local entries = {}
  generator(ownerRegion, newDescription(entries), ...)
  menuFrame = menuFrame or CreateFrame("Frame", "ARTContextMenu", UIParent, "UIDropDownMenuTemplate")
  UIDropDownMenu_Initialize(menuFrame, function(_, level, menuList)
    addMenuEntries(menuList or entries, level)
  end, "MENU")
  ToggleDropDownMenu(1, nil, menuFrame, ownerRegion.frame or ownerRegion, 0, 0)
  return menuFrame
end
