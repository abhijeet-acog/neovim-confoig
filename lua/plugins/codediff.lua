return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  config = function()
    require("codediff").setup({
      diff = {
        layout = "side-by-side",
        conflict_result_position = "bottom",
        conflict_result_height = 30,
        disable_diagnostics = true,
      },
    })
  end,
}
