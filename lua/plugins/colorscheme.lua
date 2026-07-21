-- nvim/lua/plugins/colorscheme.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Make sure this is loaded first
  config = function()
    -- load the colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
