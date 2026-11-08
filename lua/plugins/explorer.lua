-- File explorer sidebar: click (or Enter) to expand folders and open files
-- Icons need a Nerd Font in the terminal (brew install --cask font-jetbrains-mono-nerd-font)
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false, -- loads itself lazily; needed so `nvim .` opens the tree
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "File explorer" },
  },
  opts = {
    close_if_last_window = true, -- quit nvim instead of leaving only the tree open
    filesystem = {
      follow_current_file = { enabled = true }, -- highlight the open file in the tree
      use_libuv_file_watcher = true,            -- refresh when files change on disk
      hijack_netrw_behavior = "open_default",   -- `nvim .` opens the tree instead of netrw
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true, -- hides gitignored files (e.g. build output) from the tree and `/` search
        hide_by_name = { ".git", ".DS_Store" },
      },
      window = {
        mappings = {
          -- On the "(N hidden items)" line, Enter/double-click shows hidden files instead of
          -- opening a bogus "<name>_hidden_message" file (which neo-tree would then crash on)
          ["<cr>"] = "open_or_show_hidden",
          ["<2-LeftMouse>"] = "open_or_show_hidden",
        },
      },
      commands = {
        open_or_show_hidden = function(state)
          local cmds = require("neo-tree.sources.filesystem.commands")
          if state.tree:get_node().type == "message" then
            cmds.toggle_hidden(state)
          else
            cmds.open(state)
          end
        end,
      },
    },
  },
}
