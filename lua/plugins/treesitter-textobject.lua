-- lua/plugins/treesitter-textobjects.lua

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",

  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,

        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "V",
        },

        include_surrounding_whitespace = false,
      },

      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- Select text objects
    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Around function" })

    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Inside function" })

    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Around class" })

    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Inside class" })

    vim.keymap.set({ "x", "o" }, "aa", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "Around argument" })

    vim.keymap.set({ "x", "o" }, "ia", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "Inside argument" })

    -- Move between functions
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function" })

    -- Move between classes
    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next class" })

    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous class" })

    -- Swap function arguments
    vim.keymap.set("n", "<leader>an", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap argument with next" })

    vim.keymap.set("n", "<leader>ap", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap argument with previous" })
  end,
}
