let g:ale_sign_column_always = 1
let g:move_map_keys = 0

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

" extra whitespace
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" statusline colors
:autocmd ColorScheme * highlight User1 guibg=red
:autocmd ColorScheme * highlight User2 guifg=orange guibg=#504945
:autocmd ColorScheme * highlight User3 guifg=red guibg=#504945
:autocmd ColorScheme * highlight link jsFuncCall GruvboxGreen

colorscheme gruvbox

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
let g:javascript_conceal_function="λ"
set conceallevel=2

set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype c setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype elm setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

" allow for searching using :find
set path=.,**
set wildignore=*/node_modules/*,*/dist/*
set wildmode=list:full

set suffixesadd+=.ts
set suffixesadd+=.vue

" `gf` opens file under cursor in a new vertical split
nnoremap gf :vertical wincmd f<CR>

" allow for multiple buffers
set hidden

" uses amazing incremental command neovim feature if available
if exists("+inccommand")
  set inccommand=nosplit
endif

" moving sanely
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" sane terminal ESC
tnoremap <Esc> <C-\><C-n>

let mapleader=' '

" open .vimrc or init.vim
nnoremap <leader>v :e $MYVIMRC
set wildcharm=<C-z>
nnoremap <leader>e :e %:h<C-z>

" open one or more lines lines
nnoremap <Leader>o <Cmd>call OpenLines(v:count,0)<CR>S
nnoremap <Leader>O <Cmd>call OpenLines(v:count,-1)<CR>S

" set working directory to the current file
nnoremap <leader>cd :cd %:p:h<CR>

nnoremap <leader>f :find<space>
nnoremap <leader>g :Ggrep<space>

nnoremap gl :Tabularize /
vnoremap gl :Tabularize /
nnoremap gL :Tabularize /\zs<Left><Left><Left>
vnoremap gL :Tabularize /\zs<Left><Left><Left>

set modeline
nnoremap Y y$

" Call depends on mode
function! MoveE(dir)
  if mode() ==# "v" || mode() ==# "\<C-V>"
    " move block
    if a:dir < 0 | exe "normal \<Plug>MoveBlockLeft" | else | exe "normal \<Plug>MoveBlockRight" | endif
  elseif mode() ==# "V"
    " move line
    if a:dir < 0 | exe "normal \<Plug>MoveBlockUp" | else | exe "normal \<Plug>MoveBlockDown" | endif
  else
    " move line
    if a:dir < 0 | exe "normal \<Plug>MoveLineDown" | else | exe "normal \<Plug>MoveLineUp" | endif
  endif
endfunction

nmap <silent> <Plug>MoveE- <Cmd>call MoveE(-1)<CR>:<C-U>call repeat#set("\<Plug>MoveE-")<CR>
nmap <silent> <Plug>MoveE+  <Cmd>call MoveE(1)<CR>:<C-U>call repeat#set("\<Plug>MoveE+")<CR>
vmap <silent> <Plug>MoveE- <Cmd>call MoveE(-1)<CR>:<C-U>call repeat#set("gv\<Plug>MoveE-")<CR>
vmap <silent> <Plug>MoveE+  <Cmd>call MoveE(1)<CR>:<C-U>call repeat#set("gv\<Plug>MoveE+")<CR>

nmap [e <Plug>MoveE+
nmap ]e <Plug>MoveE-
vmap [e <Plug>MoveE+
vmap ]e <Plug>MoveE-

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
    let &relativenumber = a:v
endfunction

augroup relativize
  autocmd!
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup end

" go back to editing the same line as you exited in a file
aug resCur
    exe 'au!'
    au BufReadPost *
\     if line("'\"") > 1 && line("'\"") <= line("$") |
\       exe "normal! g`\"" |
\     endif
aug end

" git grep
func! GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ \"$*\"
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
endfun
command! -nargs=? Ggrep call GitGrep(<f-args>)

" highlight bad whitespace
augroup WhiteSpaceMatch
  autocmd!
  match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup end

augroup GitCommitNoWhiteSpaceMatch
  autocmd!
  autocmd FileType gitcommit call clearmatches() | autocmd! WhiteSpaceMatch
augroup end

" clear trailing space
command! -range=% TR let b:wv = winsaveview() |
            \ keeppattern <line1>,<line2>s/\s\+$// |
            \ call winrestview(b:wv)
nnoremap <leader>w :<C-U>TR<CR>
nnoremap ]w ?\s\+$<CR>
nnoremap [w /\s\+$<CR>

" Q is quite useless
nnoremap Q @q

" change current word
nnoremap <silent> <leader>. :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \cgn<C-R>.<esc>:call setreg('"', old_reg, old_regtype)<CR>

" recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

" return '•' if trailing white space is detected else ''
function! StatuslineTrailingSpaceWarning()
  " I don't care about trailing space in those
  if &filetype == 'gitcommit'
    return ''
  endif

  if !exists("b:statusline_trailing_space_warning")
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '•'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction

" moving between windows with Alt+HJKL
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

" fix syntax highlighting issues with vue files
autocmd BufRead,BufNewFile *.vue syntax sync fromstart

" add close hidden buffers command
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
set statusline+=%l/%L\ "

set iskeyword+=-

inoremap {, {<CR>},<C-c>O
inoremap {<CR> {<CR>}<C-c>O
