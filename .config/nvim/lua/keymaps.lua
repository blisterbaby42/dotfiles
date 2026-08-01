-- ============================================
-- ГОРЯЧИЕ КЛАВИШИ
-- ============================================

-- Лидеры
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ============================================
-- ОБЩИЕ КЛАВИШИ
-- ============================================

-- Снять подсветку поиска
vim.keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", { silent = true })

-- Выход из режима вставки
vim.keymap.set("i", "jj", "<Esc>")

-- Сохранить с sudo
vim.cmd([[cmap w!! w !sudo tee > /dev/null %]])

-- Файловый менеджер (netrw)
vim.keymap.set("n", "<C-x>", ":Ex<CR>", { silent = true })

-- ============================================
-- КОПИРОВАНИЕ / ВСТАВКА
-- ============================================

-- Копирование в системный буфер
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+yy')
vim.keymap.set("n", "<leader>Y", 'ggVG"+y')

-- ============================================
-- НАВИГАЦИЯ ПО БУФЕРАМ
-- ============================================

vim.keymap.set("n", "<S-Right>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", { silent = true })

-- ============================================
-- КОНТЕКСТНОЕ МЕНЮ (ПРАВЫЙ КЛИК)
-- ============================================

-- Определяем команды для буфера обмена в зависимости от ОС
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

-- Создаем контекстное меню
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

-- Открытие меню по клавише 'm'
vim.keymap.set("n", "m", ":popup PopUp<CR>", { silent = true })
vim.keymap.set("v", "m", ":popup PopUp<CR>", { silent = true })

-- ============================================
-- ДИАГНОСТИКА (LSP)
-- ============================================

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
