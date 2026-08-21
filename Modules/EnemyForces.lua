-- Made by Nnoggie, 2017-2025
-- Legacy load-list slot. Raid routes have no completion-count mechanic.

local _, MDT = ...

function MDT:EnableRouteStatus()
  return false, "not-applicable"
end
