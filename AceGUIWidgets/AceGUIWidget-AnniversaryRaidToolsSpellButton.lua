local _, ART = ...
local Type, Version = "ARTSpellButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local L = ART.L
local width, height, expandedHeight = 248, 32, 60
local statusIconScale = 0.504
local firstStatusIconOffsetX = 36
local firstStatusIconOffsetY = -1
local statusIconSpacingX = 1
local statusOrder = {
  "interruptible",
  "magic",
  "poison",
  "disease",
  "curse",
  "bleed",
  "enrage",
}
local statusAtlases = {
  interruptible = "icons_16x16_interrupt",
  magic = "icons_16x16_magic",
  poison = "icons_16x16_poison",
  disease = "icons_16x16_disease",
  curse = "icons_16x16_curse",
  bleed = "icons_16x16_bleed",
  enrage = "icons_16x16_enrage",
}
local statusLabels = {
  interruptible = L["Interruptible"],
  magic = L["Magic"],
  poison = L["Poison"],
  disease = L["Disease"],
  curse = L["Curse"],
  bleed = L["Bleed"],
  enrage = L["Enrage"],
}

local function CreateStatusIcon(parent, atlas)
  local texture = parent:CreateTexture(nil, "OVERLAY", nil, 0)
  texture:SetSize(height * statusIconScale, height * statusIconScale)
  texture:SetAtlas(atlas)
  texture:Hide()
  return texture
end

local methods = {
  ["OnAcquire"] = function(self)
    self:SetWidth(width)
    self:SetHeight(height)
    self.expanded = false
    self.expandToggle:Hide()
    self.descriptionText:Hide()
  end,

  ["Initialize"] = function(self)
    self.callbacks = {}

    function self.callbacks.OnClickNormal(_, mouseButton)
      if (IsControlKeyDown()) then
      elseif (IsShiftKeyDown()) then
        if DEFAULT_CHAT_FRAME.editBox and DEFAULT_CHAT_FRAME.editBox:IsVisible() then
          local old = DEFAULT_CHAT_FRAME.editBox:GetText()
          local link = C_Spell.GetSpellLink(self.spellId) or ""
          DEFAULT_CHAT_FRAME.editBox:SetText(old..link)
        end
      elseif mouseButton == "LeftButton" and self.description then
        self.expanded = not self.expanded
        self.expandVertical:SetShown(not self.expanded)
        self.descriptionText:SetShown(self.expanded)
        self:SetHeight(self.expanded and expandedHeight or height)
        if self.parent then self.parent:DoLayout() end
      end
    end

    function self.callbacks.OnEnter()
      GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMLEFT", 0, self.frame:GetHeight())
      GameTooltip:ClearLines()
      GameTooltip:SetSpellByID(self.spellId)
      GameTooltip:Show()

      if ART:GetDB().devMode then
        self.frame:EnableKeyboard(true)
      end
    end

    function self.callbacks.OnLeave()
      GameTooltip:Hide()
      if ART:GetDB().devMode then
        self.frame:EnableKeyboard(false)
      end
    end

    function self.callbacks.OnKeyDown(_, key)
      local db = ART:GetDB()
      if db.devMode then
        local enemies = ART.raidEnemies[db.currentRaidIndex]
        local enemyIdx = ART:GetEnemyInfoEnemyIdx()
        local enemy = enemies[enemyIdx]
        if not enemy or not enemy.spells or not enemy.spells[self.spellId] then return end
        local spell = enemy.spells[self.spellId]

        if key == "I" then
          spell.interruptible = not spell.interruptible
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "M" then
          spell.magic = not spell.magic
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "P" then
          spell.poison = not spell.poison
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "D" then
          spell.disease = not spell.disease
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "C" then
          spell.curse = not spell.curse
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "B" then
          spell.bleed = not spell.bleed
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        if key == "E" then
          spell.enrage = not spell.enrage
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end

        if key == "R" then
          enemy.spells[self.spellId] = nil
          ART:UpdateEnemyInfoFrame(enemyIdx)
        end
        --print spellId
        if key == "S" then
          print(self.spellId)
        end
      end

      if (key == "ESCAPE") then
      end
    end

    function self.callbacks.OnDragStart() end
    function self.callbacks.OnDragStop() end

    self.frame:SetScript("OnClick", self.callbacks.OnClickNormal)
    self.frame:SetScript("OnKeyDown", self.callbacks.OnKeyDown)
    self.frame:SetScript("OnEnter", self.callbacks.OnEnter)
    self.frame:SetScript("OnLeave", self.callbacks.OnLeave)
    self.frame:EnableKeyboard(false)
    self.frame:SetMovable(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", self.callbacks.OnDragStart)
    self.frame:SetScript("OnDragStop", self.callbacks.OnDragStop)
    self:Enable()
  end,

  ["SetSpell"] = function(self, spellId, spellData)
    if not C_Spell.IsSpellDataCached(spellId) then
      C_Spell.RequestLoadSpellData(spellId)
    end

    self.spellId = spellId
    local spellInfo = C_Spell.GetSpellInfo(spellId)
    --spell sometimes only exists on beta / ptr - guard against that here
    if not spellInfo then return end

    self.icon:SetTexture(C_Spell.GetSpellTexture(spellId))
    self.title:SetText(spellInfo.name)

    self.interruptible = spellData.interruptible or false
    self.magic         = spellData.magic         or false
    self.poison        = spellData.poison        or false
    self.disease       = spellData.disease       or false
    self.curse         = spellData.curse         or false
    self.bleed         = spellData.bleed         or false
    self.enrage        = spellData.enrage        or false
    self.description   = spellData.description
    self.expanded      = false
    self.expandVertical:Show()
    self.expandToggle:SetShown(not not self.description)
    self.descriptionText:SetText(self.description or "")
    self.descriptionText:Hide()
    self:SetHeight(height)

    local visibleStatuses = {}
    for _, statusKey in ipairs(statusOrder) do
      if self[statusKey] then table.insert(visibleStatuses, statusLabels[statusKey]) end
    end
    self.statusText:SetText(table.concat(visibleStatuses, " | "))

    for _, statusKey in ipairs(statusOrder) do
      self[statusKey.."Icon"]:Hide()
    end

    local iconsToShow = {}
    for _, statusKey in ipairs(statusOrder) do
      if self[statusKey] then
        table.insert(iconsToShow, self[statusKey.."Icon"])
      end
    end

    local prevIcon
    for i, iconFrame in ipairs(iconsToShow) do
      iconFrame:ClearAllPoints()
      if i == 1 then
        iconFrame:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", firstStatusIconOffsetX, firstStatusIconOffsetY)
      else
        iconFrame:SetPoint("LEFT", prevIcon, "RIGHT", statusIconSpacingX, 0)
      end
      iconFrame:Show()
      prevIcon = iconFrame
    end
  end,

  ["Disable"] = function(self)
    self.background:Hide()
    self.frame:Disable()
  end,

  ["Enable"] = function(self)
    self.background:Show()
    self.frame:Enable()
  end,

  ["Pick"] = function(self)
    self.frame:LockHighlight()
  end,

  ["ClearPick"] = function(self)
    self.frame:UnlockHighlight()
  end,

  ["SetIndex"] = function(self, index)
    self.index = index
  end,

  ["SetTitle"] = function(self, title)
    self.titletext = title
    self.title:SetText(title)
  end,
}

local function Constructor()
  local name = "ARTSpellButton"..AceGUI:GetNextWidgetNum(Type)
  local button = CreateFrame("BUTTON", name, UIParent, "OptionsListButtonTemplate")
  button:SetHeight(height)
  button:SetWidth(width)
  button.dgroup = nil
  button.data = {}

  local background = button:CreateTexture(nil, "BACKGROUND", nil, 0)
  button.background = background
  background:SetTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2.blp")
  background:SetBlendMode("ADD")
  background:SetVertexColor(0.5, 0.5, 0.5, 0.25)
  background:SetPoint("TOP", button, "TOP")
  background:SetPoint("BOTTOM", button, "BOTTOM")
  background:SetPoint("LEFT", button, "LEFT")
  background:SetPoint("RIGHT", button, "RIGHT")

  local icon = button:CreateTexture(nil, "OVERLAY", nil, 0)
  button.icon = icon
  icon:SetWidth(height)
  icon:SetHeight(height)
  icon:SetPoint("TOPLEFT", button, "TOPLEFT", 3, 0)

  local expandToggle = CreateFrame("Frame", nil, button)
  expandToggle:SetSize(16, height)
  expandToggle:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, 0)
  expandToggle:SetFrameLevel(button:GetFrameLevel() + 5)

  local expandBackground = expandToggle:CreateTexture(nil, "ARTWORK")
  expandBackground:SetSize(15, 15)
  expandBackground:SetPoint("CENTER")
  expandBackground:SetColorTexture(0.08, 0.08, 0.08, 0.9)

  local expandHorizontal = expandToggle:CreateTexture(nil, "OVERLAY")
  expandHorizontal:SetSize(9, 2)
  expandHorizontal:SetPoint("CENTER")
  expandHorizontal:SetColorTexture(1, 0.82, 0, 1)

  local expandVertical = expandToggle:CreateTexture(nil, "OVERLAY")
  expandVertical:SetSize(2, 9)
  expandVertical:SetPoint("CENTER")
  expandVertical:SetColorTexture(1, 0.82, 0, 1)

  local title = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  button.title = title
  title:SetHeight(14)
  title:SetJustifyH("LEFT")
  title:SetPoint("TOP", button, "TOP", 0, -2)
  title:SetPoint("LEFT", icon, "RIGHT", 2, 0)
  title:SetPoint("RIGHT", expandToggle, "LEFT", -2, 0)

  local statusText = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  statusText:SetJustifyH("LEFT")
  statusText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -1)
  statusText:SetPoint("RIGHT", expandToggle, "LEFT", -2, 0)

  local descriptionText = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  descriptionText:SetJustifyH("LEFT")
  descriptionText:SetJustifyV("TOP")
  descriptionText:SetWordWrap(true)
  descriptionText:SetPoint("TOPLEFT", button, "TOPLEFT", 8, -37)
  descriptionText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -8, 5)
  descriptionText:Hide()

  local interruptibleIcon = CreateStatusIcon(button, statusAtlases.interruptible)
  button.interruptibleIcon = interruptibleIcon

  local magicIcon = CreateStatusIcon(button, statusAtlases.magic)
  button.magicIcon = magicIcon

  local poisonIcon = CreateStatusIcon(button, statusAtlases.poison)
  button.poisonIcon = poisonIcon

  local diseaseIcon = CreateStatusIcon(button, statusAtlases.disease)
  button.diseaseIcon = diseaseIcon

  local curseIcon = CreateStatusIcon(button, statusAtlases.curse)
  button.curseIcon = curseIcon

  local bleedIcon = CreateStatusIcon(button, statusAtlases.bleed)
  button.bleedIcon = bleedIcon

  local enrageIcon = CreateStatusIcon(button, statusAtlases.enrage)
  button.enrageIcon = enrageIcon

  button.description = {}

  button:SetScript("OnEnter", function() end)
  button:SetScript("OnLeave", function() end)

  local widget = {
    frame = button,
    title = title,
    statusText = statusText,
    expandToggle = expandToggle,
    expandVertical = expandVertical,
    descriptionText = descriptionText,
    icon = icon,
    interruptibleIcon = interruptibleIcon,
    magicIcon = magicIcon,
    poisonIcon = poisonIcon,
    diseaseIcon = diseaseIcon,
    curseIcon = curseIcon,
    bleedIcon = bleedIcon,
    enrageIcon = enrageIcon,
    background = background,
    type = Type
  }
  for method, func in pairs(methods) do
    ---@diagnostic disable-next-line: assign-type-mismatch
    widget[method] = func
  end

  return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
