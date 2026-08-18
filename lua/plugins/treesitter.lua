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

    local shared = require("nvim-treesitter.textobjects.shared")
    local select = require("nvim-treesitter.textobjects.select")

    local function select_block(captures)
      local keymap_mode = vim.fn.mode(1):find("o") and "o" or "x"
      for _, cap in ipairs(captures) do
        local _, to = shared.textobject_at_point(cap, "textobjects", nil, nil, { lookahead = true })
        if to then
          select.select_textobject(cap, "textobjects", keymap_mode)
          return
        end
      end
    end

    vim.keymap.set({ "o", "x" }, "ab", function()
      select_block({
        "@class.outer",
        "@function.outer",
        "@conditional.outer",
        "@loop.outer",
        "@call.outer",
        "@block.outer",
        "@statement.outer",
      })
    end, { desc = "Select around block" })

    vim.keymap.set({ "o", "x" }, "ib", function()
      select_block({
        "@class.inner",
        "@function.inner",
        "@conditional.inner",
        "@loop.inner",
        "@block.inner",
      })
    end, { desc = "Select inside block" })
  end,
}
