set background=dark
set nohlsearch
set tags=/home/nagp/development/cscope/tags
set incsearch
set autoindent
set cindent
se nu
set sw=4
set ts=4
map Ctrl+< <Esc>:N<CR>
map Ctrl+> <Esc>:n<CR>

" Folding settings
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

"cs add /home/nagp/development/cscope/cscope.out

set expandtab
map <F12> /*<CR> * <CR> *<CR> * Nagaprabhanjan Bellari, Sep 2016<CR> *<CR> *<CR> *<CR> * Copyright (C) 2016-present, RtBrick, Inc.<CR> */<CR>
imap <F12> /*<CR> * <CR> *<CR> * Nagaprabhanjan Bellari, Sep 2016<CR> *<CR> *<CR> *<CR> * Copyright (C) 2016-present, RtBrick, Inc.<CR> */<CR>
map <F9> :set noautoindent nocindent<CR>
map <F10> :set autoindent cindent<CR>
set hlsearch
set tags=./tags;/
set textwidth=65
