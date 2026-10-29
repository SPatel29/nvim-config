-- Render markdown in the buffer (headings, tables, code blocks, checkboxes).
-- The line under the cursor shows raw text so you can still edit it.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = "markdown",
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle markdown rendering" },
  },
  opts = {
    -- Subtle look: no shaded backgrounds on headings, code blocks, or `inline code`
    heading = { backgrounds = {} },
    code = { style = "language" },
    latex = { enabled = false }, -- not needed; avoids checkhealth warnings
  },
}
