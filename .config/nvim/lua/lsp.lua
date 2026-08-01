-- ============================================
-- НАСТРОЙКА LSP (ВСТРОЕННЫЙ)
-- ============================================

-- Проверка существования команды в Windows/Linux
local function cmd_exists(cmd)
    if vim.fn.has("win32") == 1 then
        return vim.fn.executable(cmd .. ".cmd") == 1 or vim.fn.executable(cmd .. ".exe") == 1
    end
    return vim.fn.executable(cmd) == 1
end

-- ============================================
-- НАСТРОЙКА СЕРВЕРОВ
-- ============================================

-- clangd для C/C++
if cmd_exists("clangd") then
    vim.lsp.config.clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
        filetypes = { "c", "cpp" },
    }
    pcall(vim.lsp.enable, "clangd")
end

-- vtsls для TypeScript/JavaScript
if cmd_exists("vtsls") then
    vim.lsp.config.vtsls = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        cmd = { "vtsls", "--stdio" },
    }
    pcall(vim.lsp.enable, "vtsls")
end

-- ============================================
-- ГОРЯЧИЕ КЛАВИШИ ДЛЯ LSP
-- ============================================

local function lsp_keymaps(bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
end

-- Прикрепляем клавиши при подключении LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        lsp_keymaps(args.buf)
    end,
})

-- ============================================
-- НАСТРОЙКИ АВТОДОПОЛНЕНИЯ
-- ============================================

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
