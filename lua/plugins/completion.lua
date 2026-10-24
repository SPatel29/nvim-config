-- Autocomplete popup (capabilities are passed to LSP automatically)
return {
  "saghen/blink.cmp",
  version = "1.*", -- release tags ship a prebuilt binary
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "super-tab" }, -- Tab accepts, C-n/C-p to move, C-e to close
    completion = { documentation = { auto_show = true } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
