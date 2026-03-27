-- ── Trim trailing whitespace on save ──────────────────────
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if not vim.opt_local.modifiable:get() then
            return
        end
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- ── Filetype tweaks ───────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "json", "html", "css", "javascript", "typescript" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})
