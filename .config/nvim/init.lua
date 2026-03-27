-- Set leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configurations
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load work-specific configuration if available
local ok, work = pcall(require, "work")
if ok then
    -- Work config is loaded!
else
    -- Standard config fallback or notice
end
