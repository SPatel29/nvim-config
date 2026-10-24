-- Format on save (uses the project's prettier from node_modules, or prettierd if installed)
local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = "", desc = "Format file" },
  },
  opts = {
    formatters_by_ft = {
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      css = prettier,
      html = prettier,
    },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  },
}
