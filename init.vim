" --- General Settings ---
set noswapfile
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
set clipboard+=unnamedplus

" Auto - Save after a period of inactivity 
" set updatetime=2000
" 
" augroup AutoSaveGroup
"   " autocmd! " This clears out old versions of the command
"   autocmd CursorHold,CursorHoldI * if &modified | update | echo "Auto-saved" | endif
" augroup END

" --- Keymaps ---
inoremap jj <Esc>
let mapleader = " "
let maplocalleader = " "
" Find files by name
nnoremap <leader>ff <cmd>Telescope find_files<cr>
" Search for a string in your entire project (requires ripgrep)
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" List open buffers
nnoremap <leader>fb <cmd>Telescope buffers<cr>
" Search through help tags
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" --- Highlight when yank ---
augroup kickstart_highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
augroup END

" --- Plugins (vim-plug) ---
call plug#begin()

    " Appearance & UI
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'lukas-reineke/indent-blankline.nvim'

    " Neovim Tips
    Plug 'MunifTanjim/nui.nvim'
    Plug 'MeanderingProgrammer/render-markdown.nvim'
    Plug 'saxon1964/neovim-tips', { 'tag': '*' } " Only update on tagged releases
    
    " Theme
    Plug 'ofirgall/ofirkai.nvim'
    Plug 'loctvl842/monokai-pro.nvim' 
    " Gotta have it
    Plug 'ThePrimeagen/vim-be-good'
    
    " Required dependency for Telescope
    Plug 'nvim-lua/plenary.nvim'

    " Telescope main plugin
    Plug 'nvim-telescope/telescope.nvim'

    " Optional: Native fzf extension for better performance but could not get it installed
    " Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    
    " Which-Key plugin
    Plug 'folke/which-key.nvim'

    " Optional: For pretty icons in the menu
    Plug 'nvim-tree/nvim-web-devicons'
    
    " File Explorer
    Plug 'nvim-tree/nvim-tree.lua'
    
    " Treesitter for better syntax highlighting and code understanding
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " So that I can take cool looking markdown notes 
    " It also has a live preview feature which is cool
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    " LaTeX support with live preview
    Plug 'lervag/vimtex'
    
call plug#end()

" --- Plugin Configuration ---

" Airline (Status Bar)
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'
let g:airline_section_y = '' 
let g:airline_section_z = '%3p%% | L = %l/%L | C = %c/%{col("$")-1}'

" --- Configuration for which-key ---
lua << EOF
-- 1. Global indicator for Nerd Fonts 
vim.g.have_nerd_font = true

-- Disable netrw (recommended for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 2. Configure Which-Key with Kickstart functionality
require("which-key").setup({
  delay = 100,
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ', Down = '<Down> ', Left = '<Left> ', Right = '<Right> ',
      C = '<C-…> ', M = '<M-…> ', D = '<D-…> ', S = '<S-…> ',
      CR = '<CR> ', Esc = '<Esc> ', NL = '<NL> ', BS = '<BS> ',
      Space = '<Space> ', Tab = '<Tab> ',
    },
  },
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>e', group = '[E]xplorer' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
})

-- 3. nvim-tree Configuration
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
})

-- nvim-tree Keymaps
vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<cr>', { desc = '[E]xplorer Toggle' })
vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<cr>', { desc = '[E]xplorer [F]ind File' })
vim.keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<cr>', { desc = '[E]xplorer [C]ollapse' })
vim.keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<cr>', { desc = '[E]xplorer [R]efresh' })

-- 4. Advanced Telescope Setup
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

telescope.setup({
  extensions = {
    ['ui-select'] = {
      themes.get_dropdown(),
    },
  },
})

-- Load extensions
pcall(telescope.load_extension, 'ui-select')

-- 5. Kickstart Keymaps (Telescope)
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Custom "Search in Config" mapping
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Fuzzily search in current buffer
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(themes.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- 6. Treesitter Configuration
require('nvim-treesitter.config').setup({
  -- Install parsers for these languages automatically
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'vim',
    'vimdoc',
    'javascript',
    'typescript',
  },
  
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  
  -- Enable syntax highlighting
  highlight = {
    enable = true,
    -- Disable vim's built-in syntax highlighting for better performance
    additional_vim_regex_highlighting = false,
  },
  
  -- Ensure modules are enabled
  modules = {},
  -- Enable indentation based on treesitter
  indent = {
    enable = true,
  },
  
  -- Enable incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
})

-- Enhanced semantic highlighting for better function recognition
-- Make function calls stand out
vim.api.nvim_set_hl(0, '@function.call', { fg = '#82AAFF', bold = false })
vim.api.nvim_set_hl(0, '@function.call.c', { fg = '#82AAFF', bold = false })
vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#89DDFF', bold = true })
vim.api.nvim_set_hl(0, '@variable.builtin', { fg = '#F07178', italic = true })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = '#FFCB6B', bold = true })

-- Make function definitions stand out too
vim.api.nvim_set_hl(0, '@function', { fg = '#C792EA', bold = true })

-- Force Treesitter to attach to C files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.treesitter.start()
  end,
})
 -- 7. Markdown Preview Configuration
vim.g.mkdp_auto_close = 0  -- Don't auto-close preview when switching buffers
vim.g.mkdp_theme = 'dark'  -- Use dark theme for preview

-- Markdown Preview Keymaps
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = '[M]arkdown [P]review' })
vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = '[M]arkdown Preview [S]top' })


-- LaTeX (VimTeX) Keymaps
vim.keymap.set('n', '<leader>lc', '<cmd>VimtexCompile<cr>', { desc = '[L]aTeX [C]ompile Toggle' })
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<cr>', { desc = '[L]aTeX [V]iew PDF' })
vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<cr>', { desc = '[L]aTeX [E]rrors' })
vim.keymap.set('n', '<leader>ll', '<cmd>VimtexCompile<cr>', { desc = '[L]aTeX Compile (\\ll alternative)' })
vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<cr>', { desc = '[L]aTeX Stop Compilation' })
vim.keymap.set('n', '<leader>lx', '<cmd>VimtexClean<cr>', { desc = '[L]aTeX Clean Aux Files' })
EOF


" --- VimTeX Configuration ---
" Set the PDF viewer for Linux with Zathura
let g:vimtex_view_method = 'zathura'

" Enable continuous compilation
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-pdf',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
\}

" Disable overfull/underfull warnings
let g:vimtex_quickfix_ignore_filters = [
    \ 'Overfull',
    \ 'Underfull',
\]

" Neovim Tips Configuration
lua << EOF
require("neovim_tips").setup {
  user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
  daily_tip = 1,  -- Daily tip: 0=off, 1=once per day, 2=every startup
}

local map = vim.keymap.set
map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
map("n", "<leader>ntb", ":NeovimTipsBookmarks<CR>", { desc = "Bookmarked tips", silent = true })
map("n", "<leader>nte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", silent = true })
map("n", "<leader>nta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", silent = true })
map("n", "<leader>nth", ":help neovim-tips<CR>", { desc = "Neovim tips help", silent = true })
map("n", "<leader>ntr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", silent = true })
map("n", "<leader>ntp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", silent = true })
EOF

" Indent Blankline (Lua)
lua << EOF
require("ibl").setup({
    indent = { char = "│" },
    scope = { enabled = false },
})
EOF

" --- Colorscheme ---
colorscheme ofirkai
"colorscheme monokai-pro
