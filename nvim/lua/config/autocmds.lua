-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")


local status_group = vim.api.nvim_create_augroup("laststatus", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = status_group,
    callback = function()
        vim.o.laststatus = 3
    end,
})

--Return to dashboard if all buffers are deleted
--this is hella buggy
--[[ vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
        buffers = {}
        for _, buffer in pairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buffer) and vim.api.nvim_buf_get_name(buffer) ~= "" then
                table.insert(buffers, buffer)
            end
        end
        if #buffers == 1 and vim.fn.expand('%') == "" then
            Snacks.dashboard()
        end
    end,
}) ]]--