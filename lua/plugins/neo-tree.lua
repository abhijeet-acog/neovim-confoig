-- nvim/lua/plugins/neo-tree.lua

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- Setup neo-tree
    require("neo-tree").setup({
      position = "right", 
      -- To show hidden files, you can add this block
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          use_libuv_file_watcher = true
        },
      },
    })

    -- Set keymaps
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Explorer: Toggle Neo-tree" })
  end,
}
