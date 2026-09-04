local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local current, nonce = addon:GetCurrentPreset(), tostring(GetTime())
  local preset = {
    text = "ART Transmission Probe "..nonce,
    value = {
      currentRaidIndex = current.value.currentRaidIndex,
      currentPull = 1,
      currentSublevel = current.value.currentSublevel or 1,
      pulls = {},
    },
  }
  local payload, state = {}, 104729
  for index = 1, 512 do
    state = (state * 48271) % 2147483647
    payload[index] = string.char(32 + state % 95)
  end
  preset.artTransmissionProbe = nonce..":"..table.concat(payload)

  local message = addon:TableToString(preset)
  assert(message:sub(1, 6) == "!ART1!", "Unexpected export encoding")
  assert(#message > 255, "Transmission probe did not cross one packet")
  local decoded = addon:StringToTable(message, false)
  assert(type(decoded) == "table", "ART encoding round-trip failed")
  assert(decoded.text == preset.text, "ART encoding changed the preset name")
  assert(decoded.value.currentRaidIndex == preset.value.currentRaidIndex, "ART encoding changed the raid")

  local name, realm = UnitFullName("player")
  local fullName = name.."-"..realm
  local displayName = addon:GetRaidName(preset.value.currentRaidIndex, true)..": "..preset.text
  addon.transmissionCache[fullName] = addon.transmissionCache[fullName] or {}
  addon.transmissionCache[fullName][displayName] = nil

  addon.commsObject:SendCommMessage("ARTPreset", message, "WHISPER", name, "BULK")

  local invalidMessage = addon:TableToString({ test = true })
  addon.commsObject:OnCommReceived("ARTPreset", invalidMessage, "PARTY", UnitName("player"))

  return function()
    local cached = addon.transmissionCache[fullName] and addon.transmissionCache[fullName][displayName]
    addon.transmissionCache[fullName][displayName] = nil
    assert(cached and cached.text == preset.text and cached.artTransmissionProbe == preset.artTransmissionProbe,
      "ART self-whisper was not cached")
  end
end

---@type ARTTest
local test = {
  name = "Transmission Validation",
  func = testFunc,
  duration = 4,
}


tinsert(addon.test.testList, test)
