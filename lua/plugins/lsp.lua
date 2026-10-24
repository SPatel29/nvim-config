-- Language servers: errors, go-to-definition, rename, auto-imports, hover
return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- :Mason to install/manage servers
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp", -- load first so servers get completion capabilities
  },
  opts = {
    ensure_installed = { "vtsls", "eslint" }, -- auto-installed and auto-enabled
  },
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = true, -- show errors inline at end of line
      severity_sort = true,
      float = { border = "rounded" },
    })

    -- ESLint: apply all fixes on save
    local base_on_attach = vim.lsp.config.eslint.on_attach
    vim.lsp.config("eslint", {
      on_attach = function(client, bufnr)
        if not base_on_attach then return end
        base_on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "LspEslintFixAll",
        })
      end,
    })

    -- Keymaps added when a server attaches (built-ins: K, grn, gra, grr, gri, grt, gO)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("<leader>cd", vim.diagnostic.open_float, "Show line diagnostics")
      end,
    })

    require("mason-lspconfig").setup(opts)
  end,
}
