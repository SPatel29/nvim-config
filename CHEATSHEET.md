# Neovim Config Cheat Sheet

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point: sets leader, loads config/*
├── lazy-lock.json        # Plugin versions (auto-generated, commit it)
└── lua/
    ├── config/
    │   ├── lazy.lua      # Plugin manager bootstrap (rarely touched)
    │   ├── options.lua   # Built-in Neovim settings
    │   └── keymaps.lua   # Shortcuts that don't need a plugin
    └── plugins/          # One file per plugin (auto-loaded)
```

## Where does it go?

| I want to...                        | Put it in                 |
|-------------------------------------|---------------------------|
| Change a built-in setting           | `config/options.lua`      |
| Add a shortcut (no plugin needed)   | `config/keymaps.lua`      |
| Add a plugin or theme               | new file in `plugins/`    |
| Add a shortcut for a plugin         | that plugin's `keys = {}` |
| Configure a plugin                  | that plugin's `opts = {}` |

## Snippets

**Option** (`options.lua`)
```lua
opt.number = true
```

**Keymap** (`keymaps.lua`)
```lua
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
```

**Plugin** (`plugins/name.lua`)
```lua
return {
  "author/repo",
  dependencies = {},      -- other plugins it needs
  event = "VeryLazy",     -- or cmd = / ft = / keys = (lazy-load trigger)
  keys = {
    { "<leader>x", "<cmd>Cmd<cr>", desc = "Do thing" },
  },
  opts = {},              -- passed to setup()
}
```

**Theme** (`plugins/colorscheme.lua`)
```lua
return {
  "author/theme",
  lazy = false,
  priority = 1000,
  config = function() vim.cmd.colorscheme("theme") end,
}
```

## Commands

| Command          | Does                                  |
|------------------|---------------------------------------|
| `:Lazy`          | Plugin manager UI                     |
| `:Lazy update`   | Update plugins + lockfile             |
| `:Lazy restore`  | Revert plugins to lockfile versions   |
| `:checkhealth`   | Diagnose problems                     |
| `:help <topic>`  | Docs (e.g. `:help 'number'`)          |

## New machine

```sh
brew install neovim git ripgrep
git clone <repo> ~/.config/nvim
nvim   # plugins install automatically
```
