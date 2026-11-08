return {
  -- Active theme: loads at startup
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon", -- storm | moon | night | day
        on_highlights = function(hl, c)
          -- Annotations: olive-yellow text, no background box
          hl["@attribute"] = { fg = "#BBB529", bg = "NONE" }
          -- Fields and keys (YAML/JSON keys, obj.field, class fields): coral
          hl["@property"] = { fg = c.red }
          hl["@variable.member"] = { fg = c.red }
          -- Comments: light blue italic, brighter than tokyonight's default dim comments
          hl["@comment"] = { fg = "#8DA3CA", italic = true }
          hl.Comment = { fg = "#8DA3CA", italic = true }
          -- Test files in Telescope results (see telescope.lua)
          hl.TelescopeTestFile = { fg = c.green }
          -- The matched word in the grep preview: bright yellow box, near-black bold text
          hl.TelescopeMatchWord = { fg = c.black, bg = c.yellow, bold = true }
          -- File name bar at the top of each window (see config/winbar.lua)
          hl.WinBarFile = { fg = c.fg, bold = true }
          hl.WinBarDir = { fg = c.dark3, italic = true }
          hl.WinBarModified = { fg = c.yellow }
          -- Indent guides (see editor.lua): faint lines, the cursor's indent level in bright blue
          hl.IblIndent = { fg = c.fg_gutter, nocombine = true }
          hl.MiniIndentscopeSymbol = { fg = c.blue1, nocombine = true }
        end,
      })
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },

  -- Previous theme, only loaded when switched to (:colorscheme material)
  { "marko-cerovac/material.nvim", lazy = true },
}
