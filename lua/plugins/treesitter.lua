-- nvim/lua/plugins/treesitter.lua

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "css" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })

    local shared = require("nvim-treesitter-textobjects.shared")

    local chain = nil

    local function sorted_candidates(captures)
      local out = {}
      local seen = {}
      for _, cap in ipairs(captures) do
        local range = shared.textobject_at_point(cap, "textobjects", nil, nil, {})
        if range then
          local key = table.concat(range, ",")
          if not seen[key] then
            seen[key] = true
            out[#out + 1] = { range = range, cap = cap }
          end
        end
      end
      table.sort(out, function(a, b)
        local ar = a.range[4] - a.range[1]
        local br = b.range[4] - b.range[1]
        if ar ~= br then
          return ar < br
        end
        return (a.range[5] - a.range[2]) < (b.range[5] - b.range[2])
      end)
      return out
    end

    local function update_selection_range(range, selection_mode)
      selection_mode = selection_mode or "v"
      local mode = vim.api.nvim_get_mode().mode
      if mode ~= selection_mode then
        selection_mode = vim.api.nvim_replace_termcodes(selection_mode, true, true, true)
        vim.cmd.normal({ selection_mode, bang = true })
      end

      local start_row, start_col, end_row, end_col = range[1], range[2], range[4], range[5]
      if end_col == 0 then
        end_row = end_row - 1
        end_col = #vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1] + 1
      end

      local end_col_offset = 1
      if selection_mode == "v" and vim.o.selection == "exclusive" then
        end_col_offset = 0
      end
      end_col = end_col - end_col_offset

      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      vim.cmd("normal! o")
      vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
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
        update_selection_range(chain.list[chain.idx].range, "v")
        chain.last = { selection_pos() }
        return
      end

      chain = { buf = buf, list = candidates, idx = 1 }
      update_selection_range(chain.list[1].range, "v")
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
