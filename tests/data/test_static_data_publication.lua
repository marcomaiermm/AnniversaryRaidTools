-- Static Data Publication Contract v1 regression for generated raid artifacts.

local root = arg and arg[1] or "."
local artifact = root.."/Raids/TBC/Generated/GruulsLair.lua"

local function loadRaid(namespace)
  _G.ART = namespace
  return assert(loadfile(artifact))("AnniversaryRaidTools", {})
end

local ART = { StaticData = { raids = {} } }
local raid = loadRaid(ART)
assert(type(raid) == "table", "artifact must return one raid table")
assert(raid.key == "gruuls-lair", "unexpected raid key")
assert(ART.StaticData.raids[raid.key] == raid, "publication must reference returned table")

local ok, message = pcall(function()
  _G.ART = nil
  assert(loadfile(artifact))("AnniversaryRaidTools", {})
end)
assert(not ok and tostring(message):find("Core/Bootstrap.lua", 1, true), "missing ART must fail actionably")

ok, message = pcall(function()
  _G.ART = {}
  assert(loadfile(artifact))("AnniversaryRaidTools", {})
end)
assert(not ok and tostring(message):find("ART.StaticData bootstrap", 1, true), "missing StaticData must fail actionably")

ok, message = pcall(function()
  _G.ART = { StaticData = {} }
  assert(loadfile(artifact))("AnniversaryRaidTools", {})
end)
assert(not ok and tostring(message):find("ART.StaticData.raids bootstrap", 1, true), "missing raid bucket must fail actionably")

print("static data publication: ok")
