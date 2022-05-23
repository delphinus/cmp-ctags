local debug = require "cmp.utils.debug"
local Process = require "cmp_ctags.process"
local Ctags = {}

Ctags.new = function(config)
  local self = setmetatable({}, { __index = Ctags })
  -- These flags will be updated asynchronously.
  self.searched = false
  self.has_valid_executable = false
  return self
end

function Ctags:is_available()
  return self.searched and self.has_valid_executable
end

function Ctags:get_completion_items(filename, cwd, callback)
  local p = Process.new(
    "ctags",
    { "--output-format=json", "--fields={name}{kind}{scope}{scopeKind}", filename },
    { cwd = cwd }
  )
  p:run(function(result)
    if not result.is_successful then
      debug.log(("ctags execution failed: code = %d, message = %s"):format(result.code, result.stderr))
      return
    end
    local results = {}
    for line in result.stdout:gmatch "[^\n]+" do
      table.insert(results, vim.json.decode(line))
    end
    callback(results)
  end)
end

function Ctags:complete(filename, cwd, callback)
  if self:is_available() then
    self:get_completion_items(filename, cwd, callback)
  else
    callback(nil)
  end
end

return Ctags
