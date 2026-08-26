local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local framePools = {}

local nop = function() end

-- we should probably use our own templates for these, but this is a quick fix
local overrides = {
  ["MapLinkPinTemplate"] = {
    ["SuperTrack_OnShow"] = nop,
    ["SuperTrack_OnHide"] = nop,
    ["OnSuperTrackingChanged"] = nop,
    ["GetSuperTrackData"] = nop,
  }
}

function ART.CreateFramePool(frametype, parent, template)
  local pool = {
    active = {},
    inactive = {},
    Acquire = function(self)
      local frame = table.remove(self.inactive)
      if not frame then
        frame = CreateFrame(frametype, nil, parent, template)
        local override = overrides[template]
        if override then
          for k, v in pairs(override) do
            frame[k] = v
          end
        end
      end
      table.insert(self.active, frame)
      return frame
    end,
    ReleaseAll = function(self)
      for i = #self.active, 1, -1 do
        local frame = table.remove(self.active)
        frame:Hide()
        table.insert(self.inactive, frame)
      end
    end,
  }
  framePools[template] = pool
  return pool
end

function ART.GetFramePool(template)
  return framePools[template]
end
