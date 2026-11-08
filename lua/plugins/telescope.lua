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

-- File icon + its color group for a file name (Kotlin, YAML, ...), via nvim-web-devicons
local function file_icon(name)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then return " ", "Normal" end
  local icon, hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true })
  return icon or " ", hl or "Normal"
end

-- Ask for file extensions (e.g. "java" or "yaml,yml") and return rg globs like { "*.yaml", "*.yml" }
local function ask_globs()
  local input = vim.fn.input("File types (e.g. java or yaml,yml): ")
  local globs = {}
  for ext in input:gmatch("[^,%s]+") do
    table.insert(globs, "*." .. ext:gsub("^%*?%.?", ""))
  end
  return globs
end

-- File types in the current project, most files first: known types from the list above, plus any other
-- extension the project has (e.g. *.avsc). Types with no files are left out; "Other..." is always last.
local function project_file_types()
  local binary_exts = {}
  for _, e in ipairs({ "jar", "class", "png", "jpg", "jpeg", "gif", "ico", "pdf", "zip", "gz", "tar", "woff", "woff2", "ttf", "exe", "dll", "so", "dylib" }) do
    binary_exts[e] = true
  end
  local ext_of_glob, counts = {}, {}
  for _, t in ipairs(file_types) do
    for _, g in ipairs(t[2] or {}) do ext_of_glob[g:sub(3)] = t end
  end
  local files = vim.fn.systemlist({ "rg", "--files", "--hidden", "--glob", "!**/.git/*" })
  for _, f in ipairs(files) do
    local ext = f:match("[^/]%.([^./]+)$")
    if ext and not binary_exts[ext:lower()] then counts[ext] = (counts[ext] or 0) + 1 end
  end
  local list, by_type = {}, {}
  for ext, n in pairs(counts) do
    local known = ext_of_glob[ext]
    if known then
      by_type[known] = (by_type[known] or 0) + n
    else
      table.insert(list, { "*." .. ext, { "*." .. ext }, n })
    end
  end
  for t, n in pairs(by_type) do table.insert(list, { t[1], t[2], n }) end
  -- Most files first; on a tie, named types (Kotlin) before raw extensions (*.bru), then A-Z
  table.sort(list, function(a, b)
    if a[3] ~= b[3] then return a[3] > b[3] end
    local a_raw, b_raw = a[1]:sub(1, 1) == "*", b[1]:sub(1, 1) == "*"
    if a_raw ~= b_raw then return b_raw end
    return a[1]:lower() < b[1]:lower()
  end)
  table.insert(list, { "Other...", nil, nil })
  return list
end

-- Pick a file type (project's types first, by file count), then call on_pick(globs)
local function pick_globs(on_pick)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers.new(require("telescope.themes").get_dropdown(), {
    prompt_title = "File type",
    finder = finders.new_table({
      results = project_file_types(),
      entry_maker = function(t)
        local label = t[1]
        if t[2] and t[1] ~= t[2][1] then label = label .. "  " .. table.concat(t[2], " ") end
        local icon, icon_hl = " ", "Normal"
        if t[2] then icon, icon_hl = file_icon("x." .. t[2][1]:gsub("^%*%.", "")) end
        local text = icon .. " " .. label
        return { value = t, ordinal = label, display = function() return text, { { { 0, #icon }, icon_hl } } end }
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

-- Search hidden folders like .github too, but never inside .git
local rg_hidden = { "--hidden", "--glob", "!**/.git/*" }

-- Test files (shown in light green in results, like IntelliJ)
local function is_test(path)
  path = "/" .. (path or "")
  local name = vim.fn.fnamemodify(path, ":t")
  return path:find("/tests?/") ~= nil or path:find("/__tests__/") ~= nil
    or name:match("Tests?%.%w+$") ~= nil or name:match("IT%.%w+$") ~= nil
    or name:match("%.test%.%w+$") ~= nil or name:match("%.spec%.%w+$") ~= nil
    or name:match("^test_.*%.py$") ~= nil or name:match("_test%.%w+$") ~= nil
end

-- Wrap an entry so test files get the TelescopeTestFile color (after the file icon, if any)
local function mark_tests(entry)
  if not entry then return end
  local display = entry.display
  entry.display = function(e)
    local text, hls = display, nil
    if type(display) == "function" then text, hls = display(e) end
    hls = hls or {}
    if is_test(e.filename or e.value) then
      local start = (hls[1] and hls[1][1][1] == 0) and hls[1][1][2] or 0
      table.insert(hls, { { start, #text }, "TelescopeTestFile" })
    end
    return text, hls
  end
  return entry
end

-- Exact text matching instead of fuzzy: "Error" only matches paths containing "Error" (not scattered letters).
-- Space-separated words must all appear. Smartcase: lowercase ignores case, any capital makes it case-sensitive.
-- Files whose name matches are listed before files that only match through a folder name.
local function exact_sorter()
  local sorter = require("telescope.sorters").get_substr_matcher()
  local substr_score = sorter.scoring_function
  sorter.scoring_function = function(self, prompt, line, entry)
    local score = substr_score(self, prompt, line, entry)
    if score < 0 or #prompt == 0 then return score end
    local name = entry.ordinal:match("[^/]+$") or entry.ordinal
    if not prompt:match("%u") then name, prompt = name:lower(), prompt:lower() end
    for word in prompt:gmatch("%S+") do
      if not name:find(word, 1, true) then return score + 1e6 end
    end
    return score
  end
  return sorter
end

-- File search: exact matching, includes hidden folders, test files in green
local function find_files(opts)
  opts = opts or {}
  local cmd = { "rg", "--files", "--color", "never" }
  vim.list_extend(cmd, rg_hidden)
  for _, g in ipairs(opts.globs or {}) do vim.list_extend(cmd, { "--glob", g }) end
  opts.find_command = cmd
  local base = require("telescope.make_entry").gen_from_file(opts)
  opts.entry_maker = function(line) return mark_tests(base(line)) end
  opts.sorter = exact_sorter()
  require("telescope.builtin").find_files(opts)
end

-- Grep preview: highlights the matched line, plus the matched word itself in a yellow box (TelescopeMatchWord)
local match_ns = vim.api.nvim_create_namespace("telescope_grep_match")
local function grep_previewer(get_prompt)
  local previewers = require("telescope.previewers")
  local conf = require("telescope.config").values
  return previewers.new_buffer_previewer({
    title = "Grep Preview",
    get_buffer_by_name = function(_, entry) return entry.filename end,
    define_preview = function(self, entry)
      conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        callback = function(bufnr)
          vim.api.nvim_buf_clear_namespace(bufnr, match_ns, 0, -1)
          local row = entry.lnum - 1
          local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
          if not line then return end
          -- Line highlight as a normal range (line_hl_group would paint over the word's background)
          vim.api.nvim_buf_set_extmark(bufnr, match_ns, row, 0, {
            end_row = row + 1, hl_group = "TelescopePreviewLine", hl_eol = true, priority = 150,
          })
          -- Length of the match at rg's column: try the prompt as a regex, else as plain text
          local col, len = (entry.col or 1) - 1, #get_prompt()
          local ok, re = pcall(vim.regex, "\\C\\v" .. get_prompt())
          if ok then
            local s, e = re:match_str(line:sub(col + 1))
            if s == 0 and e > 0 then len = e end
          end
          if len > 0 then
            vim.api.nvim_buf_set_extmark(bufnr, match_ns, row, col, {
              end_col = math.min(col + len, #line), hl_group = "TelescopeMatchWord", priority = 200,
            })
          end
          pcall(vim.api.nvim_win_set_cursor, self.state.winid, { row + 1, col })
          vim.api.nvim_win_call(self.state.winid, function() vim.cmd("normal! zz") end)
        end,
      })
    end,
  })
end

-- Text search where each result shows only "FileName.kt:42" (the matching code is in the preview).
-- Matches whole words by default; Ctrl-g switches between whole word and partial matches.
local function grep(opts)
  opts = opts or {}
  local whole = opts.whole_word ~= false
  local args = vim.list_extend({}, rg_hidden) -- fresh copy: live_grep appends globs to this list
  if whole then table.insert(args, "--word-regexp") end
  opts.additional_args = args
  opts.base_title = opts.base_title or opts.prompt_title or "Grep"
  opts.prompt_title = opts.base_title .. (whole and "  [whole word, Ctrl-g: partial]" or "  [partial, Ctrl-g: whole word]")
  local base = require("telescope.make_entry").gen_from_vimgrep(opts)
  opts.entry_maker = function(line)
    local entry = base(line)
    if entry then
      entry.display = function(e)
        local name = vim.fn.fnamemodify(e.filename, ":t")
        local icon, icon_hl = file_icon(name)
        return icon .. " " .. name .. ":" .. e.lnum, { { { 0, #icon }, icon_hl } }
      end
    end
    return mark_tests(entry)
  end
  local prompt = opts.default_text or ""
  opts.on_input_filter_cb = function(p) prompt = p end
  opts.previewer = grep_previewer(function() return prompt end)
  opts.attach_mappings = function(bufnr, map)
    map({ "i", "n" }, "<C-g>", function()
      local text = require("telescope.actions.state").get_current_line()
      require("telescope.actions").close(bufnr)
      grep({ glob_pattern = opts.glob_pattern, base_title = opts.base_title, whole_word = not whole, default_text = text })
    end)
    return true
  end
  require("telescope.builtin").live_grep(opts)
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope", -- load only when the command is used
  keys = {
    { "<leader>ff", function() find_files() end, desc = "Find files" },
    { "<leader>fg", function() grep() end, desc = "Grep in files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in file" },
    { "<leader>ft", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Themes" },
    {
      "<leader>fF",
      function()
        pick_globs(function(globs)
          find_files({ globs = globs, prompt_title = "Find " .. table.concat(globs, " ") })
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
