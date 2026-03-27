local map = vim.keymap.set

-- ── General ────────────────────────────────────────────────

-- Quick save / quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Move between splits with Ctrl+hjkl
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Move visual selection up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep visual selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Y yanks to end of line (consistent with D and C)
map("n", "Y", "y$")

-- Center screen after jumping
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Press <Esc> to clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
