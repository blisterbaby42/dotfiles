-- ============================================
-- УПРАВЛЕНИЕ ПЛАГИНАМИ (LAZY.NVIM)
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
    {
        "dracula/vim",
        name = "dracula",
    },
    {
        "morhetz/gruvbox",
    },
    
    -- ============================================
    -- СТАТУСБАР
    -- ============================================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "dracula",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "::", right = "::" },
                },
                extensions = { "quickfix" },
            })
        end
    },
    
    -- ============================================
    -- ИКОНКИ
    -- ============================================
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    
    -- ============================================
    -- АВТОДОПОЛНЕНИЕ
    -- ============================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
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
                }),
            })
        end
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
                direction = "float",
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
            })
            
            vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>", { silent = true })
            vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { silent = true })
            vim.keymap.set("n", "<leader>tn", ":ToggleTermNext<CR>", { silent = true })
            vim.keymap.set("n", "<leader>tp", ":ToggleTermPrev<CR>", { silent = true })
        end,
    }
})
