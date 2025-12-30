" --- General Settings ---
syntax enable
filetype plugin indent on
set termguicolors          " Enable true color support
set background=dark
set number relativenumber  " Shows both current line number and relative
set smartindent
set backspace=indent,eol,start
set scrolloff=8            " Keep 8 lines above/below cursor
set virtualedit=all        " Allow cursor to move where there is no text
set nowrapscan             " Stop search at end of file
set cursorline             " Highlight current line
set ruler                  " Show cursor position

" --- Keymaps ---
inoremap jj <Esc>

" --- Plugins (vim-plug) ---
call plug#begin()
    " Appearance & UI
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'lukas-reineke/indent-blankline.nvim'
    
    " Theme
    Plug 'ofirgall/ofirkai.nvim'

    " Fun/Utility
    Plug 'ThePrimeagen/vim-be-good'
call plug#end()

" --- Plugin Configuration ---

" Airline (Status Bar)
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'
let g:airline_section_y = '' 
let g:airline_section_z = '%3p%% | L = %l/%L | C = %c/%{col("$")-1}'

" Indent Blankline (Lua)
lua << EOF
require("ibl").setup({
    indent = { char = "│" },
    scope = { enabled = false },
})
EOF

" --- Colorscheme ---
" Pick one and keep the others commented out for quick switching
" colorscheme tokyonight
" colorscheme dracula
" colorscheme catppuccin-macchiato
" colorscheme monokai-pro
colorscheme ofirkai-darkblue
