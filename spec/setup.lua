if _VERSION ~= "Lua 5.1" then
  error("AnniversaryRaidTools specs require Lua 5.1 (got ".._VERSION..")")
end

if type(setfenv) ~= "function" then
  error("AnniversaryRaidTools specs require Lua 5.1 setfenv")
end
