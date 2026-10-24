return {
  -- Auto close/rename JSX/HTML tags
  { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, opts = {} },

  -- Auto close brackets and quotes
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

  -- Git changes in the sign column
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next git change" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous git change" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview git change" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
    },
  },

  -- Popup showing available keymaps after pressing <leader>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- Project-wide list of errors
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "All diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "File diagnostics" },
    },
  },
}
