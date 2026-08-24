-- Pure-Lua acceptance checks for exact/pool pull progress.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
assert(loadfile(root.."/Core/PullProgress.lua"))("AnniversaryRaidTools", { ART = ART })

local step = { spawnKeys = { "s1", "s2" } }
local exact1 = { kind = "exact", spawnKey = "s1" }
local exact2 = { kind = "exact", spawnKey = "s2" }
local pool = {
  kind = "packPool",
  allocationKey = "p:100",
  candidateSpawnKeys = { "s1", "s2" },
}

do
  local progress = ART.PullProgress.new()
  assert(progress:Track("g1", exact1, step) and progress:Track("g2", exact2, step))
  assert(progress:MarkDead("g1") and not progress:IsComplete(step), "one exact death is incomplete")
  assert(progress:MarkDead("g2") and progress:IsComplete(step), "all exact deaths complete")
end

do
  local progress = ART.PullProgress.new()
  assert(progress:Track("g1", pool, step))
  assert(progress:Track("g1", exact1, step), "later exact evidence updates the same binding")
  assert(progress.bindings.g1.kind == "pool", "pool membership remains exclusive")
  assert(progress:MarkDead("g1") and not progress:IsComplete(step), "one actor never counts twice")
  assert(not progress:MarkDead("g1"), "duplicate death is ignored")
  assert(not progress:Track("g1", exact1, step), "dead actor cannot be rebound and counted twice")
  assert(progress:Track("g2", pool, step) and progress:MarkDead("g2"))
  assert(progress:IsComplete(step), "required pool count completes")
end

do
  local progress = ART.PullProgress.new()
  assert(progress:Track("g1", exact1, step) and progress:MarkDead("g1"))
  assert(progress:Track("g2", pool, step), "later pool evidence reclassifies exact progress")
  assert(not progress:IsComplete(step), "transferred exact death counts once")
  assert(progress:MarkDead("g2") and progress:IsComplete(step), "pool completes after second actor")
end

print("pull progress checks passed")
