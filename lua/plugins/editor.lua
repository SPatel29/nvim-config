return {
  -- Auto close/rename JSX/HTML tags
  { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, opts = {} },

  -- Faint vertical guide line at every indent level
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = false }, -- the current level is drawn by mini.indentscope below
      exclude = { filetypes = { "help", "lazy", "mason", "neo-tree", "trouble", "markdown" } },
    },
  },

  -- Colored guide line for the indent level the cursor is on (color: MiniIndentscopeSymbol)
  {
    "nvim-mini/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return {
        symbol = "│",
        options = { try_as_border = true }, -- on an `if x:` line, highlight the block below it
        draw = { delay = 50, animation = require("mini.indentscope").gen_animation.none() },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "lazy", "mason", "neo-tree", "trouble", "markdown", "TelescopePrompt" },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },

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
        { "<leader>r", group = "run" },
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
