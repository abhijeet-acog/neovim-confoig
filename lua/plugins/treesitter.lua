return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "master",
    },
  },

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "typescript",
        "html",
        "css",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      textobjects = {
        select = {
          lookahead = true,

          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",

            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",

            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
