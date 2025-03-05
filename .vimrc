syntax enable

" UI Configuration
set number          " Show line numbers
set showmatch       " Highlight matching brackets
set ruler           " Show cursor position
set showcmd         " Show command in bottom bar
set wildmenu        " Visual autocomplete for command menu

" Search settings
set incsearch       " Search as characters are entered
set hlsearch        " Highlight search results
set ignorecase      " Case insensitive searching
set smartcase       " Case-sensitive if search contains uppercase

" Indentation
set autoindent      " Auto-indent new lines
set smartindent     " Smart indent
set expandtab       " Use spaces instead of tabs
set shiftwidth=4    " Number of spaces for each indent
set tabstop=4       " Number of spaces tabs count for

" Additional settings
set backspace=indent,eol,start  " Make backspace work as expected
set hidden          " Allow buffer switching without saving
set history=1000    " Increase history
set mouse=a         " Enable mouse support

" File management
set noswapfile      " No swap file
set autoread        " Auto reload files changed outside vim