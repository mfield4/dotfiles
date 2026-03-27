-- ── General ────────────────────────────────────────────────
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.belloff = "all"

-- ── Display ───────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true

-- Statusline setup (simple, no plugin needed)
vim.opt.statusline = " %f %m%r%h%w %= %y %l:%c %p%% "

-- ── Indentation ───────────────────────────────────────────
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true

-- ── Search ────────────────────────────────────────────────
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ── Splits ────────────────────────────────────────────────
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ── Completion ────────────────────────────────────────────
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- ── Performance ───────────────────────────────────────────
vim.opt.lazyredraw = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- ── Persistent Undo ───────────────────────────────────────
local undodir = vim.fn.expand("~/.local/state/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p", 0700)
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- ── Swap & Backup ─────────────────────────────────────────
local swapdir = vim.fn.expand("~/.local/state/nvim/swap//")
local backupdir = vim.fn.expand("~/.local/state/nvim/backup//")
if vim.fn.isdirectory(swapdir) == 0 then vim.fn.mkdir(swapdir, "p", 0700) end
if vim.fn.isdirectory(backupdir) == 0 then vim.fn.mkdir(backupdir, "p", 0700) end
vim.opt.directory = swapdir
vim.opt.backupdir = backupdir
vim.opt.backup = true
vim.opt.swapfile = true

-- ── Colorscheme ───────────────────────────────────────────
vim.cmd("silent! colorscheme retrobox")
