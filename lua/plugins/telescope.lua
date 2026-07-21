-- nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- It's recommended to pin to a specific version for stability
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Load default ignore patterns
    local patterns = { "node_modules", ".git/", "dist/", "build/", ".next/" }

    -- Try to read project-specific .nvimignore
    local ignore_file = vim.fn.getcwd() .. "/.nvimignore"
    if vim.fn.filereadable(ignore_file) == 1 then
      local custom = vim.fn.readfile(ignore_file)
      for _, line in ipairs(custom) do
        if line ~= "" then
          table.insert(patterns, line)
        end
      end
    end

    -- Telescope setup
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = patterns,
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Built-in pickers keymaps
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy Find: Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Fuzzy Find: Live Grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Fuzzy Find: Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Fuzzy Find: Help Tags" })
  end,
}

