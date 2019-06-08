" plugin options (before loading plugins)
let g:move_key_modifier = 'C'

set packpath+=~/.config/nvim
packloadall

" only toggle this for neovim
if has('termguicolors')
  set termguicolors
endif

" fix annoying markdown folding
let g:vim_markdown_folding_disabled=1
autocmd FileType markdown set conceallevel=0

" setup gruvbox theme
let g:gruvbox_contrast_dark='hard'
set background=dark
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
colorscheme gruvbox

let mapleader=' '
nnoremap <leader>v :e $MYVIMRC

" open files
nnoremap <Leader>o :<C-u>call OpenLines(v:count,0)<CR>S
nnoremap <Leader>O :<C-u>call OpenLines(v:count,-1)<CR>S

" PEP-8
set colorcolumn=79

" highlight line and show numbers
set cursorline number

" allow flickering of pairs
set showmatch matchtime=2

" split to the right side
set splitright
" search ignoring case if all lowercase
set ignorecase smartcase

set list listchars=trail:•,tab:»\ |

" conceal cursor
aug conceal | exe 'au!' | au BufWinEnter * set concealcursor=cn | aug end

set expandtab tabstop=2 shiftwidth=2 softtabstop=2

" some file types are special
autocmd Filetype c setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype elm setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

" moving sanely
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" open multiple lines (insert empty lines) before or after current line,
" and position cursor in the new space, with at least one blank line
" before and after the cursor.
function! OpenLines(nrlines, dir)
    let nrlines = a:nrlines < 2 ? 2 : a:nrlines
    let start = line('.') + a:dir
    call append(start, repeat([''], nrlines))
    if a:dir < 0 | exe 'normal! 2k' | else | exe 'normal! 2j' | endif
endfunction

" relativize only on normal mode, not on insert or out of focus
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

set hidden
if exists("+inccommand")
  set inccommand=nosplit
endif

" sane terminal ESC
tnoremap <Esc> <C-\><C-n>

set modeline
nnoremap Y y$
nnoremap <leader>f :find<space>
nnoremap <leader>g :Ggrep<space>
nnoremap <leader>a :Gwrite<CR>

" git grep
func! GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
endfun
command! -nargs=? Ggrep call GitGrep(<f-args>)

" allow for searching using :find
set path=.,**
set wildignore=*/node_modules/*

" highlight bad whitespace
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" clear trailing space
command! -range=% TR let b:wv = winsaveview() |
            \ keeppattern <line1>,<line2>s/\s\+$// |
            \ call winrestview(b:wv)
nnoremap <expr> <leader>w TR()
nnoremap ]w ?\s\+$<CR>
nnoremap [w /\s\+$<CR>

" Q is quite useless
nnoremap Q @q

" keep the current block selected for indenting
vmap > >gv
vmap < <gv

" recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '•'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

" moving between windows
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

highlight link jsFuncCall GruvboxGreen

autocmd BufRead,BufNewFile *.vue syntax sync fromstart

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

" search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

vmap <leader>c *``cgn
nmap <leader>c *``cgn
nnoremap z* *``
vnoremap z* *``<esc>

hi User1 guibg=red
hi User2 guifg=orange guibg=#504945
hi User3 guifg=red guibg=#504945

" start of the statusline
set statusline=\ "
" tail of the filename
set statusline+=%n\ %t
" file encoding (not utf-8 or blank)
set statusline+=%{&fenc!='utf-8'&&strlen(&fenc)?'['+&fenc+']':''}
" line endings (not unix)
set statusline+=%{&ff!='unix'?'['+&ff+']':''}
" modified flag
set statusline+=%2*%{&modified?'*':''}%*
" show whitespace warning
set statusline+=%1*%{StatuslineTrailingSpaceWarning()}%*
" modifiable/read only flag
set statusline+=%3*%{&readonly?(&modifiable?'-':'!'):(&modifiable?'':'!')}%*
" left/right separator
set statusline+=%=
" cursor column
set statusline+=%c,
" line/total lines
set statusline+=%l/%L\
