" ============================================
" 1. БАЗОВЫЕ НАСТРОЙКИ
" ============================================
set nocompatible
syntax on
filetype plugin indent on
set number
set relativenumber
set showmatch
set showmode
set showcmd
set scrolloff=5

" Мышь: Включена везде + правый клик открывает контекстное меню (как в Neovim)
set mouse=a
set mousemodel=popup

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

set incsearch
set hlsearch
set ignorecase
set smartcase

set encoding=utf-8
set fileencoding=utf-8

set nobackup
set noswapfile
set nowritebackup

set clipboard=unnamedplus
set laststatus=2
set ruler
"set termguicolors
"set t_Co=256

" Настройки netrw (встроенный файловый менеджер)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" ============================================
" 2. ЛИДЕР И ГОРЯЧИЕ КЛАВИШИ
" ============================================
let mapleader = " "
let maplocalleader = ","

" Снять подсветку поиска
nnoremap <CR> :nohlsearch<CR><CR>

" Выход из режима вставки
inoremap jj <Esc>

" Сохранить с sudo
cmap w!! w !sudo tee > /dev/null %

" Файловый менеджер (netrw)
nnoremap <C-x> :Ex<CR>

" Копирование в системный буфер
vnoremap <leader>y "+y
nnoremap <leader>y "+yy
"nnoremap <leader>Y ggVG"+y

" Навигация по вкладкам/буферам клавиатурой (на всякий случай)

" ============================================
" 3. УСТАНОВКА ПЛАГИНОВ (VIM-PLUG)
" ============================================
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ТЕМА И ИНТЕРФЕЙС
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox', {'as': 'gruvbox'}
Plug 'rose-pine/vim', {'as': 'rosepine'}
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

" ЧИСТЫЙ LSP И АВТОДОПОЛНЕНИЕ ДЛЯ VIM (БЕЗ COC / БЕЗ NODE.JS)
Plug 'yegappan/lsp'          " Родной быстрый LSP клиент для Vim
Plug 'girishji/vimcomplete'  " Асинхронное автодополнение с поддержкой мыши
" ПОИСК И НАВИГАЦИЯ
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ДОПОЛНИТЕЛЬНЫЕ ИНСТРУМЕНТЫ
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'iaalm/terminal-drawer.vim' " -- term toggle

call plug#end()

" ============================================
" 4. НАСТРОЙКИ ИНТЕРФЕЙСА И ПРОЗРАЧНОСТИ
" ============================================
set background=dark
colorscheme rosepine

" Полная прозрачность заднего фона (выполняется после загрузки цветовой схемы)
autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE
autocmd ColorScheme * highlight SignColumn guibg=NONE ctermbg=NONE
autocmd ColorScheme * highlight StatusLine guibg=NONE ctermbg=NONE
autocmd ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE

" Повторно применяем для гарантии прозрачности дракулы
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE

" --- Настройка Кликабельных Вкладок (Буферов) вверху экрана ---
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'default'
"let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
" Делает табы кликабельными левой кнопкой мыши:
"let g:airline#extensions#tabline#buffer_idx_mode = 1

" --- Настройка vim-airline---
let g:airline_theme = 'monochrome'
let g:airline_powerline_fonts = 1

" ============================================
" 5. НАСТРОЙКА NATIVE LSP & VIMCOMPLETE
" ============================================

" Функция инициализации LSP (использует новые глобальные команды плагина)
function! SetupMyLsp() abort
    if executable('clangd')
        call LspAddServer([#{
            \ name: 'clangd',
            \ filetype: ['c', 'cpp'],
            \ path: 'clangd',
            \ args: ['--background-index', '--clang-tidy']
            \ }])
    endif
    if executable('rust-analyzer')
        call LspAddServer([#{
            \ name: 'rust-analyzer',
            \ filetype: ['rs'],
            \ path: 'rust-analyzer',
            "\ args: ['--background-index', '--clang-tidy']
            \ }])
    endif
endfunction
" Привязываем регистрацию серверов к событию LspSetup
autocmd User LspSetup call SetupMyLsp()
"autocmd VimEnter * call LspAddServer([
"    \ #{ name: 'clangd', filetype: ['c', 'cpp'], path: 'clangd', args: ['--background-index', '--clang-tidy'] },
"    \ #{ name: 'vtsls', filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'], path: 'vtsls', args: ['--stdio'] },
"    \ ])
" Горячие клавиши для нативного LSP (в стиле старого CoC)
nnoremap <silent> gd :LspGotoDefinition<CR>
nnoremap <silent> gy :LspTypeDefinition<CR>
nnoremap <silent> gi :LspImplementation<CR>
nnoremap <silent> gr :LspShowReferences<CR>
nnoremap <silent> <leader>rn :LspRename<CR>
nnoremap <silent> <leader>f :LspFormat<CR>
nnoremap <silent> <leader>h :LspHover<CR>

" Настройка всплывающего меню автодополнения (Vimcomplete)
let g:vimcomplete_config = {
    \ 'lsp': { 'enable': 1, 'priority': 10 },
    \ 'buffer': { 'enable': 1, 'priority': 5 },
    \ }
" --- Навигация по автодополнению с помощью Tab и Shift+Tab ---

" В режиме вставки: если меню открыто -> следующий пункт, иначе -> обычный Tab
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"

" В режиме вставки: если меню открыто -> предыдущий пункт, иначе -> обычный Shift+Tab
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Нажатие Enter (CR) подтверждает выбор в автодополнении, если меню открыто
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" ============================================
" 6. ПОИСК И ГОРЯЧИЕ КЛАВИШИ FZF:
" ============================================
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>
" BUFFER JUMPS:
nnoremap <leader>bn :bn<CR>
nnoremap <leader><Tab> :bn<CR>

nnoremap <leader>b1 :b1<CR>
nnoremap <leader>b2 :b2<CR>
nnoremap <leader>b3 :b3<CR>
nnoremap <leader>b4 :b4<CR>
nnoremap <leader>b5 :b5<CR>

let g:gitgutter_enabled = 1

"=============================================
"LSP error remaps:
"=============================================
" Навигация и отображение диагностик (Ошибок / Предупреждений) 

" Показать список всех ошибок в текущем файле (Location List)
nnoremap <silent> <leader>dd :LspDiag show<CR>

" Показать развернутую ошибку под курсором в текущей строке
nnoremap <silent> <leader>di :LspDiag current<CR>

" Прыгнуть к следующей ошибке в коде
nnoremap <silent> ]d :LspDiag next<CR>

" Прыгнуть к предыдущей ошибке в коде
nnoremap <silent> [d :LspDiag prev<CR>

" Добавить пункт 'Show Diagnostic' в контекстное меню мыши (Правый клик)
amenu PopUp.Show\ Diagnostic :LspDiag current<CR>

" ============================================================================
" НАСТРОЙКИ КОНТЕКСТНОГО МЕНЮ (ПРАВЫЙ КЛИК)
" ============================================================================
set mousemodel=popup

" 1. ВЫБРАТЬ ВСЁ (Select All)
nnoremenu PopUp.Select\ All         ggVG
vnoremenu PopUp.Select\ All         gg0oG$
inoremenu PopUp.Select\ All         <Esc>ggVG

" 2. ВСТАВИТЬ (Paste из системного буфера обмена)
" Поскольку в вашем конфиге включено 'unnamedplus', "+gP вставляет текст чисто
set mouse=a

" --- COPY (Visual Mode Only) ---
vnoremenu PopUp.Copy y:call system("xclip -sel c", @")<CR>
" Normal Mode: Copy the CURRENT LINE
nnoremenu PopUp.Copy\ line yy:call system("xclip -sel c", @")<CR>

" --- PASTE (Separated By Mode) ---
" Normal Mode: Inserts at cursor
nnoremenu PopUp.Paste i<C-r>=system("xclip -sel c -o")<CR><Esc>

" Visual Mode: Deletes selection and overwrites it
vnoremenu PopUp.Paste c<C-r>=system("xclip -sel c -o")<CR><Esc>

" Insert Mode: Pastes directly at the cursor
inoremenu PopUp.Paste <C-r>=system("xclip -sel c -o")<CR>
"3. ПЕРЕЙТИ К ОПРЕДЕЛЕНИЮ (Go to Definition - ваша команда LSP)
" <Cmd> предотвращает изменение режима при клике мышкой
anoremenu PopUp.Go\ To\ Definition  <Cmd>LspGotoDefinition<CR>

" 4. ВАШ СТАРЫЙ ДИАГНОСТИК (Диагностика ошибок)
anoremenu PopUp.Show\ Diagnostic    <Cmd>LspDiag current<CR>

" Map 'm' in Normal and Visual modes to open the popup menu
nnoremap m :popup PopUp<CR>
vnoremap m :popup PopUp<CR>

"set term position to bottom:
set splitbelow
" Автоматически устанавливает высоту окна терминала в 7 строк при его открытии
autocmd TerminalOpen * resize 7
"Defo
nnoremap <C-Bslash> :ToggleTerminalDrawer<CR>
"term in menu:noremap <C-Bslash>
anoremenu PopUp.Show\ Terminal      <Cmd>:terminal<CR>

"term-drawer confo:

let g:terminal_drawer_shell = "bash"
let g:terminal_drawer_leader = "<C-Bslash>"
let g:terminal_drawer_position = "bottom"
let g:terminal_drawer_size = 7
