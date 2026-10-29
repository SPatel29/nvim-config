-- Common file types for the "by type" pickers; "Other..." lets you type your own (e.g. "yaml,yml")
local file_types = {
  { "Markdown", { "*.md" } },
  { "Python", { "*.py" } },
  { "JavaScript", { "*.js", "*.jsx", "*.mjs", "*.cjs" } },
  { "TypeScript", { "*.ts", "*.tsx" } },
  { "JSON", { "*.json" } },
  { "Text", { "*.txt" } },
  { "YAML", { "*.yaml", "*.yml" } },
  { "Java", { "*.java" } },
  { "Kotlin", { "*.kt", "*.kts" } },
  { "Go", { "*.go" } },
  { "Lua", { "*.lua" } },
  { "Shell", { "*.sh", "*.zsh", "*.bash" } },
  { "HTML", { "*.html" } },
  { "CSS", { "*.css", "*.scss" } },
  { "SQL", { "*.sql" } },
  { "TOML", { "*.toml" } },
  { "XML", { "*.xml" } },
  { "Other...", nil },
}

-- Ask for file extensions (e.g. "java" or "yaml,yml") and return rg globs like { "*.yaml", "*.yml" }
local function ask_globs()
  local input = vim.fn.input("File types (e.g. java or yaml,yml): ")
  local globs = {}
  for ext in input:gmatch("[^,%s]+") do
    table.insert(globs, "*." .. ext:gsub("^%*?%.?", ""))
  end
  return globs
end

-- Pick a file type from the list above, then call on_pick(globs)
local function pick_globs(on_pick)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers.new(require("telescope.themes").get_dropdown(), {
    prompt_title = "File type",
    finder = finders.new_table({
      results = file_types,
      entry_maker = function(t)
        local label = t[2] and (t[1] .. "  " .. table.concat(t[2], " ")) or t[1]
        return { value = t, display = label, ordinal = label }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(bufnr)
      actions.select_default:replace(function()
        local t = action_state.get_selected_entry().value
        actions.close(bufnr)
        local globs = t[2] or ask_globs()
        if #globs > 0 then on_pick(globs) end
      end)
      return true
    end,
  }):find()
end

-- Text search where each result shows only "FileName.kt:42" (the matching code is in the preview)
local function grep(opts)
  opts = opts or {}
  local base = require("telescope.make_entry").gen_from_vimgrep(opts)
  opts.entry_maker = function(line)
    local entry = base(line)
    if entry then
      entry.display = function(e)
        return vim.fn.fnamemodify(e.filename, ":t") .. ":" .. e.lnum
      end
    end
    return entry
  end
  require("telescope.builtin").live_grep(opts)
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope", -- load only when the command is used
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", function() grep() end, desc = "Grep in files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in file" },
    { "<leader>ft", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Themes" },
    {
      "<leader>fF",
      function()
        pick_globs(function(globs)
          local cmd = { "rg", "--files", "--color", "never" }
          for _, g in ipairs(globs) do vim.list_extend(cmd, { "--glob", g }) end
          require("telescope.builtin").find_files({ find_command = cmd, prompt_title = "Find " .. table.concat(globs, " ") })
        end)
      end,
      desc = "Find files by type",
    },
    {
      "<leader>fG",
      function()
        pick_globs(function(globs)
          grep({ glob_pattern = globs, prompt_title = "Grep in " .. table.concat(globs, " ") .. " (type to search)" })
        end)
      end,
      desc = "Grep in files by type",
    },
  },
  opts = {},
}
