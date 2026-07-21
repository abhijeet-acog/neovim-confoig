-- nvim/lua/core.lua

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set options
local opt = vim.opt
opt.autowrite = true          -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3          -- Hide * markup for bold and italic in markdown
opt.confirm = true            -- Confirm to save changes before exiting modified buffer
opt.cursorline = true         -- Enable highlighting of the current line
opt.expandtab = true          -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true         -- Ignore case in search patterns
opt.inccommand = "nosplit"    -- Show replacements in a preview split
opt.list = true               -- Show some invisible characters (tabs, newlines, etc.)
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.mouse = "a"               -- Enable mouse mode
opt.number = true             -- Print line number
opt.relativenumber = true     -- Show relative line numbers
opt.scrolloff = 4             -- Lines of context around the cursor
opt.shiftwidth = 2            -- Size of an indent
opt.showmode = false          -- Don't show the mode, lualine will do this
opt.smartcase = true          -- Don't ignore case with capitals
opt.smartindent = true        -- Insert indents automatically
opt.spell = false
opt.splitbelow = true         -- Splitting a window will put the new window below the current one
opt.splitright = true         -- Splitting a window will put the new window right of the current one
opt.tabstop = 2               -- Number of spaces tabs count for
opt.termguicolors = true      -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200          -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5           -- Minimum window width
opt.wrap = false              -- Disable line wrapping
