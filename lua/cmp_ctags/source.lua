local config = require "cmp.config"
local Ctags = require "cmp_ctags.ctags"

local source = {}

local default_config = {
  executable = "ctags",
  trigger_characters = { "." },
  trigger_characters_ft = {},
}

local completion_item_kind = {
  text = 1,
  method = 2,
  ["function"] = 3,
  constructor = 4,
  field = 5,
  variable = 6,
  class = 7,
  interface = 8,
  module = 9,
  property = 10,
  unit = 11,
  value = 12,
  enum = 13,
  keyword = 14,
  snippet = 15,
  color = 16,
  file = 17,
  reference = 18,
  folder = 19,
  enumMember = 20,
  constant = 21,
  struct = 22,
  event = 23,
  operator = 24,
  typeParameter = 25,
}

source.new = function()
  local self = setmetatable({}, { __index = source })
  local source_config = config.get_source_config "ctags" or {}
  self.config = vim.tbl_extend("force", default_config, source_config.option or {})
  self.ctags = Ctags.new(self.config.executable)
  return self
end

source.get_debug_name = function()
  return "ctags"
end

function source:is_available()
  return self.ctags:is_available()
end

function source:get_keyword_pattern()
  return [[\w\+]]
end

function source:get_trigger_characters()
  local ft = vim.opt.filetype:get()
  return self.config.trigger_characters_ft[ft] or self.config.trigger_characters
end

function source:complete(request, callback)
  local bufnr = request.context.bufnr
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local cwd = vim.fn.getcwd()
  self.ctags:complete(filename, cwd, function(results)
    if not results then
      return callback()
    end

    local items = vim.tbl_map(function(r)
      return {
        label = r.name,
        kind = completion_item_kind[r.kind:lower()] or nil,
      }
    end, results)

    callback(items)
  end)
end

function source:resolve(completion_item, callback)
  callback(completion_item)
end

function source:execute(completion_item, callback)
  callback(completion_item)
end

return source
