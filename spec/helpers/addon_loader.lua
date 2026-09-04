local function repositoryRoot()
  local source = debug.getinfo(1, "S").source
  source = source:sub(1, 1) == "@" and source:sub(2) or source
  return source:match("^(.*)/spec/helpers/addon_loader%.lua$") or "."
end

local function pathFor(root, path)
  if root == "." then return "./"..path end
  return root.."/"..path
end

local Loader = {
  addonName = "AnniversaryRaidTools",
  root = repositoryRoot(),
}

function Loader.newNamespace()
  return { API = {} }
end

function Loader.load(path, namespace, environment)
  assert(type(path) == "string", "addon path must be a string")
  namespace = namespace or Loader.newNamespace()

  local chunk, message = loadfile(pathFor(Loader.root, path))
  assert(chunk, message)
  if environment ~= nil then
    assert(type(setfenv) == "function", "addon environments require Lua 5.1")
    setfenv(chunk, environment)
  end

  local result = chunk(Loader.addonName, namespace)
  return result, namespace
end

return Loader
