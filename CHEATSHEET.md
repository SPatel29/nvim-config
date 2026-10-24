# Neovim Config Cheat Sheet

`<leader>` = **Space**. Press it and wait to see all shortcuts (which-key).

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point: sets leader, loads config/*
├── lazy-lock.json        # Plugin versions (auto-generated, commit it)
├── after/ftplugin/
│   └── python.lua        # Settings/keymaps for Python files only
└── lua/
    ├── config/
    │   ├── lazy.lua      # Plugin manager bootstrap (rarely touched)
    │   ├── options.lua   # Built-in Neovim settings
    │   └── keymaps.lua   # Shortcuts that don't need a plugin
    └── plugins/          # One file per plugin/group (auto-loaded)
        ├── colorscheme.lua  # material (palenight), tokyonight
        ├── telescope.lua    # fuzzy finder
        ├── lsp.lua          # language servers (TS, ESLint, Python)
        ├── completion.lua   # autocomplete popup
        ├── treesitter.lua   # syntax highlighting
        ├── formatting.lua   # prettier / ruff on save
        └── editor.lua       # autopairs, autotag, git, which-key, trouble
```

## Where does it go?

| I want to...                        | Put it in                 |
|-------------------------------------|---------------------------|
| Change a built-in setting           | `config/options.lua`      |
| Add a shortcut (no plugin needed)   | `config/keymaps.lua`      |
| Add a plugin or theme               | new file in `plugins/`    |
| Add a shortcut for a plugin         | that plugin's `keys = {}` |
| Configure a plugin                  | that plugin's `opts = {}` |
| Keymap/setting for one language     | `after/ftplugin/<lang>.lua` |

## Plugins

| Plugin            | What it does                                        |
|-------------------|-----------------------------------------------------|
| lazy.nvim         | Plugin manager (`:Lazy`)                            |
| material.nvim     | Theme (palenight style)                             |
| tokyonight.nvim   | Backup theme (`:colorscheme tokyonight`)            |
| telescope.nvim    | Fuzzy find files, text, symbols                     |
| mason.nvim        | Installs language servers/tools (`:Mason`)          |
| nvim-lspconfig    | Configs for language servers (see below)            |
| blink.cmp         | Autocomplete popup                                  |
| nvim-treesitter   | Accurate syntax highlighting + indentation          |
| conform.nvim      | Formats on save (`:ConformInfo`)                    |
| nvim-ts-autotag   | Auto close/rename JSX/HTML tags                     |
| mini.pairs        | Auto close brackets and quotes                      |
| gitsigns.nvim     | Git changes in the gutter, blame                    |
| which-key.nvim    | Popup listing shortcuts                             |
| trouble.nvim      | List of all errors in project                       |

## Languages

| Language   | Language servers                  | Format on save          |
|------------|-----------------------------------|-------------------------|
| TypeScript | vtsls (types), eslint (lint)      | prettier + ESLint fixes |
| Python     | pyright (types), ruff (lint)      | ruff (sort imports + format) |

Python auto-uses the project's `.venv/` if present.

## Keymaps

**General**

| Key              | Action                         |
|------------------|--------------------------------|
| `<leader>w`      | Save                           |
| `<leader>q`      | Quit                           |
| `<leader>l`      | Open Lazy (plugin manager)     |
| `Esc`            | Clear search highlight         |
| `Ctrl-h/j/k/l`   | Move between splits            |
| `J` / `K` (visual)| Move selected lines down/up   |

**Find (telescope)**

| Key           | Action                       |
|---------------|------------------------------|
| `<leader>ff`  | Find files                   |
| `<leader>fg`  | Search text in project       |
| `<leader>fb`  | Open buffers                 |
| `<leader>fs`  | Symbols in file              |
| `<leader>ft`  | Pick theme (live preview)    |

**Code (LSP)** — `gr*`, `K`, `Ctrl-s`, `]d` are Neovim built-ins

| Key              | Action                            |
|------------------|-----------------------------------|
| `gd`             | Go to definition                  |
| `K`              | Hover type/docs                   |
| `grn`            | Rename everywhere                 |
| `gra`            | Code actions (imports, fixes)     |
| `grr`            | Find references                   |
| `gri`            | Go to implementation              |
| `grt`            | Go to type definition             |
| `gO`             | Symbols in file                   |
| `Ctrl-s` (insert)| Show function signature           |
| `]d` / `[d`      | Next / previous error             |
| `<leader>cd`     | Show full error for line          |
| `<leader>cf`     | Format file                       |
| `Ctrl-o`         | Jump back (after `gd`)            |

**Autocomplete (insert mode)**

| Key            | Action                  |
|----------------|-------------------------|
| `Tab`          | Accept suggestion       |
| `Ctrl-n/p`     | Next / previous item    |
| `Ctrl-e`       | Close popup             |
| `Ctrl-Space`   | Open popup manually     |

**Diagnostics & Git**

| Key           | Action                      |
|---------------|-----------------------------|
| `<leader>xx`  | All errors (trouble)        |
| `<leader>xX`  | Errors in this file         |
| `]h` / `[h`   | Next / previous git change  |
| `<leader>gp`  | Preview git change          |
| `<leader>gb`  | Blame line                  |

**Python only**

| Key           | Action                                  |
|---------------|-----------------------------------------|
| `<leader>rr`  | Run file in terminal (`.venv` if found) |
| `Ctrl-\ Ctrl-n` | Leave terminal mode (then `:q` to close) |

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

## Commands

| Command          | Does                                  |
|------------------|---------------------------------------|
| `:Lazy`          | Plugin manager UI                     |
| `:Lazy update`   | Update plugins + lockfile             |
| `:Lazy restore`  | Revert plugins to lockfile versions   |
| `:Mason`         | Install/update language servers       |
| `:checkhealth vim.lsp` | Check attached language servers |
| `:ConformInfo`   | Check formatters                      |
| `:checkhealth`   | Diagnose problems                     |
| `:help <topic>`  | Docs (e.g. `:help 'number'`)          |

## New machine

```sh
brew install neovim git ripgrep tree-sitter-cli
git clone <repo> ~/.config/nvim
nvim   # plugins + parsers install automatically
```
Then inside nvim (if not already installed): `:MasonInstall vtsls eslint-lsp prettierd pyright ruff`
