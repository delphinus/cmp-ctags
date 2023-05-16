local debug = require "cmp.utils.debug"
local Process = require "cmp_ctags.process"
local Ctags = {}

Ctags.new = function(executable)
  local self = setmetatable({}, { __index = Ctags })
  self.executable = executable
  -- These flags will be updated asynchronously.
  self.searched = false
  self.has_valid_executable = false
  return self
end

function Ctags:is_available()
  if self.searched then
    return self.has_valid_executable
  end
  return true
end

function Ctags:search_executable()
  local p = Process.new(self.executable, { "--help" })
  p:run(function(result)
    if not result.is_successful then
      debug.log { message = "execution failed", path = self.executable, code = result.code, stderr = result.stderr }
    end
    self.searched = true
    self.has_valid_executable = result.is_successful
        and result.stdout:match [[^Universal Ctags]]
        and result.stdout:match [[%-%-output%-format=.*json]]
        and true
      or false
  end)
end

function Ctags:get_completion_items(filename, cwd, callback)
  local p = Process.new(
    self.executable,
    { "--output-format=json", "--fields={name}{kind}{scope}{scopeKind}", filename },
    { cwd = cwd }
  )
  p:run(function(result)
    if not result.is_successful then
      debug.log { message = "ctags execution failed", code = result.code, stderr = result.stderr }
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
  if self.searched then
    if self:is_available() then
      self:get_completion_items(filename, cwd, callback)
    else
      callback(nil)
    end
  else
    callback(nil)
    self:search_executable()
  end
end

return Ctags
