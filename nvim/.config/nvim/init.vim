set packpath+=~/.config/nvim
packloadall

let g:vim_markdown_folding_disabled=1

let g:gruvbox_contrast_dark='hard'
set background=dark
colorscheme gruvbox

let mapleader=' '
nnoremap <leader>ev :e $MYVIMRC

" PEP-8
set colorcolumn=79
set cursorline number relativenumber

set showmatch matchtime=2

set splitright
set ignorecase smartcase

set list listchars=trail:•,tab:»\ |

" conceal cursor
aug conceal | exe 'au!' | au BufWinEnter * set concealcursor=cn | aug end

set expandtab tabstop=2 shiftwidth=2 softtabstop=2

autocmd Filetype c setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4

nnoremap ; :
nnoremap : ;

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

noremap Y y$

" Open multiple lines (insert empty lines) before or after current line,
" and position cursor in the new space, with at least one blank line
" before and after the cursor.
function! OpenLines(nrlines, dir)
    let nrlines = a:nrlines < 2 ? 2 : a:nrlines
    let start = line('.') + a:dir
    call append(start, repeat([''], nrlines))
    if a:dir < 0 | exe 'normal! 2k' | else | exe 'normal! 2j' | endif
endfunction

nnoremap <Leader>o :<C-u>call OpenLines(v:count,0)<CR>S
nnoremap <Leader>O :<C-u>call OpenLines(v:count,-1)<CR>S
nnoremap <leader>F :s/\s\+$//e<CR>:nohl<CR>

function! Relativize(v)
  if &number
    let &relativenumber = a:v
  endif
endfunction

augroup relativize
  autocmd!
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END

" go back to editing the same line as you exited in a file
aug resCur
    exe 'au!'
    au BufReadPost *
\     if line("'\"") > 1 && line("'\"") <= line("$") |
\       exe "normal! g`\"" |
\     endif
aug end

let g:javascript_conceal_function="λ"
set conceallevel=2

autocmd FileType markdown set conceallevel=0

set hidden
if exists("+inccommand")
  set inccommand=nosplit
endif

tnoremap <Esc> <C-\><C-n>

" Update time of 100ms for vim-gitgutter
set updatetime=100
