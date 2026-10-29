-- Accurate syntax highlighting and indentation (needs: brew install tree-sitter-cli)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "typescript", "tsx", "javascript", "json", "html", "css",
      "python", "toml",
      "kotlin", "java",
      "lua", "markdown", "markdown_inline", "yaml", "bash", "vim", "vimdoc",
    })

    -- Enable for any filetype that has a parser installed
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
