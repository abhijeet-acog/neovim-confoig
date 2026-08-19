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
    local ts_utils = require("nvim-treesitter.ts_utils")

    local chain = nil

    local function sorted_candidates(captures)
      local out = {}
      local seen = {}
      for _, cap in ipairs(captures) do
        local _, range, node = shared.textobject_at_point(cap, "textobjects", nil, nil, {})
        if node and range then
          local key = table.concat(range, ",")
          if not seen[key] then
            seen[key] = true
            out[#out + 1] = { range = range, node = node, cap = cap }
          end
        end
      end
      table.sort(out, function(a, b)
        local ar = a.range[3] - a.range[1]
        local br = b.range[3] - b.range[1]
        if ar ~= br then
          return ar < br
        end
        return (a.range[4] - a.range[2]) < (b.range[4] - b.range[2])
      end)
      return out
    end

    local function selection_pos()
      return vim.fn.getpos("'<"), vim.fn.getpos("'>")
    end

    local function matches(a, b)
      return a and b and a[1][2] == b[1][2] and a[1][3] == b[1][3] and a[2][2] == b[2][2] and a[2][3] == b[2][3]
    end

    local function select_block(captures)
      local mode = vim.fn.mode(1)
      local keymap_mode = mode:find("o") and "o" or "x"
      local buf = vim.api.nvim_get_current_buf()

      local candidates = sorted_candidates(captures)
      if #candidates == 0 then
        return
      end

      if keymap_mode == "x" and chain and chain.buf == buf and matches(chain.last, { selection_pos() }) then
        if chain.idx < #chain.list then
          chain.idx = chain.idx + 1
        end
        ts_utils.update_selection(0, chain.list[chain.idx].node, "v")
        chain.last = { selection_pos() }
        return
      end

      chain = { buf = buf, list = candidates, idx = 1 }
      ts_utils.update_selection(0, chain.list[1].node, "v")
      chain.last = { selection_pos() }
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
