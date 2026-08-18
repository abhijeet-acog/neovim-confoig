# Git Mergetool with Neovim (codediff.nvim)

Quick guide to use Neovim as your `git mergetool` with a VSCode-style merge
view: Current / Incoming panes on top, merged Result at the bottom.

## 1. Install the plugin

Already in `lua/plugins/codediff.lua`. If fresh, add:

```lua
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
```

The C diff library auto-downloads on first `:CodeDiff` use. Install it
manually if needed: `:CodeDiff install`.

## 2. Register it as your mergetool (one-time)

```sh
git config --global merge.tool codediff
git config --global mergetool.codediff.cmd 'nvim "$MERGED" -c "CodeDiff --exit-on-close merge \"$MERGED\""'
```

> `--exit-on-close` makes nvim exit when the merge view closes, so `git
> mergetool` knows you're done.

## 3. Use it during a merge

```sh
git merge <branch>      # conflicts occur
git mergetool           # opens each conflicted file in nvim
```

Optional: `git config --global mergetool.codediff.trustExitCode true`
if the plugin ever needs non-zero exit codes to signal abort.

## 4. Keybindings (inside the merge view)

| Key | Action |
|-----|--------|
| `<leader>co` | Accept Current (ours) |
| `<leader>ct` | Accept Incoming (theirs) |
| `<leader>cb` | Accept both |
| `<leader>cx` | Discard both, keep base |
| `]x` / `[x` | Next / previous conflict |
| `2do` / `3do` | Get hunk from incoming / current |
| `q` | Close view (exit mergetool) |

## 5. Finish the merge

```sh
git add . && git commit -m "merge"
```
