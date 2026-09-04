local M = {}

function M.capture(...)
  local names = { ... }
  local values = {}
  for index, name in ipairs(names) do values[index] = rawget(_G, name) end

  return function()
    for index, name in ipairs(names) do rawset(_G, name, values[index]) end
  end
end

return M
