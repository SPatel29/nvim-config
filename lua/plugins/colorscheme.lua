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
        },
      })
      vim.cmd.colorscheme("material")
    end,
  },

  -- Installed but only loaded when switched to (:colorscheme tokyonight)
  { "folke/tokyonight.nvim", lazy = true },
}
