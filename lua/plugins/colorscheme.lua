return {
  -- Active theme: loads at startup
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "palenight" -- darker | lighter | oceanic | palenight | deep ocean
      require("material").setup({
        custom_highlights = {
          -- Annotations: olive-yellow text, no background box
          ["@attribute"] = { fg = "#BBB529", bg = "NONE" },
          -- Fields and keys (YAML/JSON keys, obj.field, class fields): coral instead of dim gray
          ["@property"] = { fg = "#F07178" },
          ["@variable.member"] = { fg = "#F07178" },
          -- Comments: light blue italic, so they don't look like fields
          ["@comment"] = { fg = "#8DA3CA", italic = true },
          ["Comment"] = { fg = "#8DA3CA", italic = true },
          -- Test files in Telescope results (see telescope.lua)
          TelescopeTestFile = { fg = "#C3E88D" },
          -- The matched word in the grep preview: bright yellow box, near-black bold text
          TelescopeMatchWord = { fg = "#1B1E2B", bg = "#FFCB6B", bold = true },
          -- File name bar at the top of each window (see config/winbar.lua)
          WinBarFile = { fg = "#EEFFFF", bold = true },
          WinBarDir = { fg = "#676E95", italic = true },
          WinBarModified = { fg = "#FFCB6B" },
        },
      })
      vim.cmd.colorscheme("material")
    end,
  },

  -- Installed but only loaded when switched to (:colorscheme tokyonight)
  { "folke/tokyonight.nvim", lazy = true },
}
