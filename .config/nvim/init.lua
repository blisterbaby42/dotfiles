-- ============================================
-- 1. БАЗОВЫЕ НАСТРОЙКИ
-- ============================================
vim.opt.syntax = "on"
vim.opt.filetype = "on"


vim.opt.guicursor = "n-v-i-c:block-Cursor"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.scrolloff = 5
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"
-------   
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true

vim.opt.smartcase = true

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

vim.opt.clipboard = "unnamedplus"
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.termguicolors = false

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

vim.opt.background = "dark"

vim.opt.signcolumn = "yes"
vim.g.gitgutter_enabled = 1
--show spaces:
vim.o.list = true
--vim.o.listchars = 'lead:•,trail:•'
--vim.o.listchars = 'space:·'
   --     test  sad     

-- ============================================
-- 2. ГОРЯЧИЕ КЛАВИШИ
-- ============================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", { silent = true })
vim.keymap.set("i", "jj", "<Esc>")
vim.cmd([[cmap w!! w !sudo tee > /dev/null %]])
vim.keymap.set("n", "<C-x>", ":Ex<CR>", { silent = true })

vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+yy')
vim.keymap.set("n", "<leader>Y", 'ggVG"+y')

vim.keymap.set("n", "<S-Right>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", { silent = true })

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set("n", "<leader>ms", ":Mason<CR>", { silent = true })

vim.keymap.set("n", "m", ":popup PopUp<CR>", { silent = true })
vim.keymap.set("v", "m", ":popup PopUp<CR>", { silent = true })
-- BUFFER NAVIGATION:
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { silent = true }) --next buffer
vim.keymap.set("n", "<leader>b<Tab>", ":bn<CR>", { silent = true }) --next buffer
--first 4 buffers jumper:
vim.keymap.set("n", "<leader>b1", ":b1<CR>", { silent = true }) --buffer #1
vim.keymap.set("n", "<leader>b2", ":b2<CR>", { silent = true }) --buffer #2
vim.keymap.set("n", "<leader>b3", ":b3<CR>", { silent = true }) --buffer #3
vim.keymap.set("n", "<leader>b4", ":b4<CR>", { silent = true }) --buffer #4
--vim.keymap.set("n", "<leader>bp", ":b#<CR>", { silent = true }) --prev buffer

-- ============================================
-- 3. ПЛАГИНЫ (LAZY.NVIM)
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- ============================================
    -- ТЕМЫ
    -- ============================================
    { "dracula/vim", name = "dracula" },
    { "morhetz/gruvbox" },
    { "rose-pine/neovim", name = "rose-pine"},
    { "Mofiqul/vscode.nvim", name = "vscode"},
    { "Aejkatappaja/sora", name = "sora"},
    { "kvrohit/rasmus.nvim", name = "rasmus"},
    -- ============================================
    -- INDENT SHIT:
    -- ============================================
    { 'nvim-mini/mini.indentscope', version = '*' },
    -- ============================================
    -- СТАТУСБАР
    -- ============================================
    -- LUALINE:
    --
--    {
--       "nvim-lualine/lualine.nvim",
--        dependencies = { "nvim-tree/nvim-web-devicons" },
--        config = function()
--            require("lualine").setup({
--                options = {
--                    theme = "rose-pine",
--                    component_separators = { left = "", right = "" },
--                    section_separators = { left = "::", right = "::" },
--                },
--                extensions = { "quickfix" },
--            })
--        end
--    },
--    MINI.STATUSLINE:
    {"nvim-mini/mini.statusline"},
    -- ============================================
    -- ИКОНКИ
    -- ============================================
    { "nvim-tree/nvim-web-devicons", lazy = true },
    -- ============================================
    -- АВТОДОПОЛНЕНИЕ
    -- ============================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end
    },
    
    -- ============================================
    -- FOR STUPIES:
    -- ============================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    -- ============================================
    -- ПОИСК
    -- ============================================
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", telescope.find_files, { silent = true })
            vim.keymap.set("n", "<leader>fg", telescope.live_grep, { silent = true })
            vim.keymap.set("n", "<leader>fb", telescope.buffers, { silent = true })
            vim.keymap.set("n", "<leader>fh", telescope.help_tags, { silent = true })
        end
    },

    -- ============================================
    -- GIT
    -- ============================================
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },
    -- ============================================
    -- КОММЕНТАРИИ
    -- ============================================
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    -- ============================================
    -- SURROUND
    -- ============================================
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    },
    -- ============================================
    -- AUTO-PAIRS
    -- ============================================
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
    -- ============================================
    -- ПЛАВАЮЩИЙ ТЕРМИНАЛ
    -- ============================================
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- direction = "float",
                direction = "horizontal",
                float_opts = {
                    border = "curved",
                    width = 90,
                    height = 80,
                    winblend = 0,
                },
                open_mapping = [[<C-\>]],
                size = 7,
                start_in_insert = true,
                close_on_exit = true,
                shell = "powershell",
            })
            vim.keymap.set("n", "<leader>t", ":ToggleTerm .<CR>", { silent = true })
            vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { silent = true })
            vim.keymap.set("n", "<leader>tn", ":ToggleTermNext<CR>", { silent = true })
            vim.keymap.set("n", "<leader>tp", ":ToggleTermPrev<CR>", { silent = true })
        end,
    },
    -- ============================================
    -- MASON (УПРАВЛЕНИЕ LSP СЕРВЕРАМИ)
    -- ============================================
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    
    -- ============================================
    -- MASON-LSPCONFIG (СВЯЗКА MASON C LSP)
    -- ============================================
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",           -- C/C++
                    "vtsls",            -- TypeScript/JavaScript
                    "pyright",          -- Python
                    "lua_ls",           -- Lua
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local lspconfig = require("lspconfig")
                        lspconfig[server_name].setup({})
                    end,
               },
            })
        end,
    },
    -- ============================================
    -- LSP КЛАВИШИ
    -- ============================================
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    mason = false,
                },
            },
        },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local function lsp_keymaps(bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    lsp_keymaps(args.buf)
                end,
            })
        end,
    },
})

-- ============================================
-- 4. КОНТЕКСТНОЕ МЕНЮ (ПРАВЫЙ КЛИК)
-- ============================================
local function get_clipboard_command()
    if vim.fn.has("win32") == 1 then
        return "powershell -command Get-Clipboard"
    else
        return "xclip -sel c -o"
    end
end

local function set_clipboard_command()
    if vim.fn.has("win32") == 1 then
        return "clip"
    else
        return "xclip -sel c"
    end
end

local clip_get = get_clipboard_command()
local clip_set = set_clipboard_command()

vim.cmd([[
nnoremenu PopUp.Select\ All         ggVG
vnoremenu PopUp.Select\ All         gg0oG$
inoremenu PopUp.Select\ All         <Esc>ggVG

vnoremenu PopUp.Copy y:call system("]] .. clip_set .. [[", @")<CR>
nnoremenu PopUp.Copy\ line yy:call system("]] .. clip_set .. [[", @")<CR>

nnoremenu PopUp.Paste i<C-r>=system("]] .. clip_get .. [[")<CR><Esc>
vnoremenu PopUp.Paste c<C-r>=system("]] .. clip_get .. [[")<CR><Esc>
inoremenu PopUp.Paste <C-r>=system("]] .. clip_get .. [[")<CR>

anoremenu PopUp.Go\ To\ Definition  <Cmd>lua vim.lsp.buf.definition()<CR>
anoremenu PopUp.Show\ Diagnostic    <Cmd>lua vim.diagnostic.open_float()<CR>
anoremenu PopUp.Show\ Terminal      <Cmd>ToggleTerm<CR>
]])

-- ============================================
-- 5. ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ LSP
-- ============================================
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})
require("rose-pine").setup({
    styles = {
        bold = true,
        italic = true,
        --transparency = true,
    },
    })
require("vscode").setup({
        transparent = true,
})
-- Убирает фон у основного окна и плавающих окон
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

--vim.cmd("colorscheme rose-pine")
print("[OK] :: NVIM config loaded :: ")
