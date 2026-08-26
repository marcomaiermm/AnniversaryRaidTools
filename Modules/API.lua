-- Stable raid-domain API for addon consumers.
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local _, ART = ...

function ART:GetRaidDefinition(raidKey)
  return self.RaidRegistry and self.RaidRegistry:Get(raidKey)
end

function ART:GetRaidDefinitions()
  return self.RaidRegistry and self.RaidRegistry:GetAll() or {}
end

function ART:ValidateRoutePreset(preset)
  local raid = type(preset) == "table" and self:GetRaidDefinition(preset.raidKey)
  if not raid or not self.RoutePreset then return nil, "unknown raid" end
  return self.RoutePreset:Validate(preset, raid)
end
