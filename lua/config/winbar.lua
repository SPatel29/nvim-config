-- File name bar at the top of each code window:  <icon> FileName.kt  folder/path  ●
-- Also sets the terminal tab title (iTerm2) to the current file name.

local M = {}

-- Windows that shouldn't get a bar: explorer, telescope, diffview panels, help, terminals, popups
local skip_ft = { "neo-tree", "TelescopePrompt", "TelescopeResults", "DiffviewFiles", "DiffviewFileHistory", "lazy", "mason", "trouble", "help", "qf", "" }

function M.render()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local name = vim.fn.fnamemodify(path, ":t")
  local dir = vim.fn.fnamemodify(path, ":~:.:h")

  local icon, icon_hl = "", "WinBarDir"
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local i, hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true })
    icon, icon_hl = i or "", hl or icon_hl
  end

  local parts = { " ", "%#" .. icon_hl .. "#", icon, " ", "%#WinBarFile#", (name:gsub("%%", "%%%%")) }
  if dir ~= "." and dir ~= "" then
    table.insert(parts, "  %#WinBarDir#" .. dir:gsub("%%", "%%%%"))
  end
  if vim.bo[buf].modified then
    table.insert(parts, "  %#WinBarModified#●")
  end
  return table.concat(parts)
end

local function update()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local cfg = vim.api.nvim_win_get_config(win)
  local is_file = vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
  if cfg.relative ~= "" or not is_file or vim.tbl_contains(skip_ft, vim.bo[buf].filetype) or vim.wo[win].diff then
    vim.wo[win].winbar = ""
  else
    vim.wo[win].winbar = "%{%v:lua.require'config.winbar'.render()%}"
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("FileWinbar", { clear = true }),
  callback = update,
})

-- Terminal tab title: "Main.kt - nvim" (falls back to the folder name)
vim.opt.title = true
vim.opt.titlestring = "%{expand('%:t') != '' ? expand('%:t') : fnamemodify(getcwd(), ':t')} - nvim"

return M
