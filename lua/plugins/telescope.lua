return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope", -- load only when the command is used
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep in files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in file" },
    { "<leader>ft", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Themes" },
  },
  opts = {},
}
