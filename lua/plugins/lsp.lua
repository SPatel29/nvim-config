-- Language servers: errors, go-to-definition, rename, auto-imports, hover
-- TypeScript: vtsls + eslint | Python: pyright (types) + ruff (linting)
return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- :Mason to install/manage servers
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp", -- load first so servers get completion capabilities
  },
  opts = {
    ensure_installed = { "vtsls", "eslint", "pyright", "ruff" }, -- auto-installed and auto-enabled
  },
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = true, -- show errors inline at end of line
      severity_sort = true,
      float = { border = "rounded" },
    })

    -- Python: use the project's .venv if it has one
    vim.lsp.config("pyright", {
      before_init = function(_, config)
        local venv_python = (config.root_dir or vim.fn.getcwd()) .. "/.venv/bin/python"
        if vim.uv.fs_stat(venv_python) then
          config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = venv_python })
        end
      end,
    })

    -- Keymaps added when a server attaches (built-ins: K, grn, gra, grr, gri, grt, gO)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        -- Let pyright handle hover docs instead of ruff
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end

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
