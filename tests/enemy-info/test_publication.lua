-- Pure-Lua acceptance checks for Static Data Publication Contract v1.

local root = arg and arg[1] or "."
local path = root.."/Data/EnemyInfo/GruulsLair.lua"
local ART = { StaticData = { enemyInfo = {} } }
_G.ART = ART

local enemyInfo = assert(loadfile(path))("AnniversaryRaidTools", { ART = ART })
assert(enemyInfo == ART.StaticData.enemyInfo["gruuls-lair"], "publication must preserve record identity")
assert(enemyInfo.enemies[18831].name.source == enemyInfo.source, "published value must be the returned record")

_G.ART = nil
local ok, message = pcall(assert(loadfile(path)), "AnniversaryRaidTools", {})
assert(not ok and tostring(message):find("Core/Bootstrap.lua", 1, true), "missing ART must fail actionably")

_G.ART = {}
ok, message = pcall(assert(loadfile(path)), "AnniversaryRaidTools", {})
assert(not ok and tostring(message):find("ART.StaticData bootstrap", 1, true), "missing StaticData must fail actionably")

_G.ART = { StaticData = {} }
ok, message = pcall(assert(loadfile(path)), "AnniversaryRaidTools", {})
assert(not ok and tostring(message):find("ART.StaticData.enemyInfo bootstrap", 1, true), "missing enemy-info bucket must fail actionably")

print("enemy-info publication: ok")
