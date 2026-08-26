local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local preset = addon:GetCurrentPreset()
  local message = addon:TableToString(preset)
  assert(message:sub(1, 7) == "!~ART2~", "Unexpected export encoding")
  local decoded = addon:StringToTable(message, false)
  assert(type(decoded) == "table", "Blizzard encoding round-trip failed")
  assert(decoded.text == preset.text, "Blizzard encoding changed the preset name")
  assert(decoded.value.currentRaidIndex == preset.value.currentRaidIndex, "Blizzard encoding changed the raid")

  local name, realm = UnitFullName("player")
  addon.commsObject:OnCommReceived("ARTPreset", message, "PARTY", name)
  local displayName = addon:GetRaidName(preset.value.currentRaidIndex, true)..": "..preset.text
  assert(addon.transmissionCache[name.."-"..realm][displayName], "Blizzard transmission was not cached")

  local invalidMessage = addon:TableToString({ test = true })
  addon.commsObject:OnCommReceived("ARTPreset", invalidMessage, "PARTY", UnitName("player"))

  local legacyRaidIndex
  for raidIndex in pairs(addon.knownRaids) do
    if not addon.raidList[raidIndex] then
      legacyRaidIndex = raidIndex
      break
    end
  end
  assert(legacyRaidIndex, "No historical raid available for validation test")

  local legacyPreset = {
    text = "Legacy validation test",
    value = {
      currentRaidIndex = legacyRaidIndex,
      currentPull = 1,
      currentSublevel = 1,
      pulls = { {} },
    },
  }
  assert(not addon:ValidateImportPreset(legacyPreset), "Normal import accepted unavailable raid")
  assert(addon:ValidateImportPreset(legacyPreset, true), "Shared legacy preset was rejected")
end

---@type ARTTest
local test = {
  name = "Transmission Validation",
  func = testFunc,
  duration = 0,
}

tinsert(addon.test.testList, test)
