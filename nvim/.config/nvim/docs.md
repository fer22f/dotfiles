# The way I use neovim

* Plugins are handled by git submodules

# Things I need to code

* A way to open files quickly by searching for their names
    * One solution is to use Ctrl+P
* Show whitespace at the end of the lines as red
    * Create thing that shows this
* Syntax highlighting that works in Vue files
* Bindings to copy from and to the clipboard
* Binding to access the settings config
    * `<leader>v`
* Gruvbox theme
* Way to move arguments of a function
* Use editorconfig
* Alternate between compact and open versions of code (splitjoin.vim)
* Readline binding in insert mode (vim-rsi)
* Show git changes in the sidebar
* Sandwich text (add parenthesis, add ", etc)
* Mappings for :cnext, :cprev, :bnext, :bprev ([q, ]q, [b, ]b)
* Indent guides
* Clear search after insert mode is entered or the cursor moves (vue-evanesco)
* Add :Rename for file (vim-eunuch)
* Coerce to snake_case, MixedCase, camelCase with vim-abolish

Fer22f's personal cheat sheet for Vim.

===============================================================================
1. Default vim                                                  *vim-shortcuts*

  - o, O : open lines
  - <C-O>, <C-I> : go to older, newer cursor position

===============================================================================
2. Leader mappings

  - v : open init.vim
  - o, O : open lines with leading line and count
  - cd : set working directory to the current file
  - f : alias for :find
  - g : alias for :Ggrep
  - . : change current word
  - w : remove trailing whitespace

===============================================================================
3. Other custom mappings

  - [e, ]e : move line up/down when linewise, move left/right when block
  - [w, ]w : go to next, last whitespace error
  - Q : play q
  - <A-h> <A-j> <A-k> <A-l> : move between windows
  - gl : alias for Tabularize /
  - gL : alias for Tabularize //\zs

===============================================================================
4. Useful commands

  :CloseHiddenBuffers : close all other buffers

===============================================================================
5. Useful plugin mappings

ReplaceWithRegister
  - grr : replace with register

commentary
  - gcc : add comment
  - gcgc, gcu : uncomment adjacent lines

tabularize
  - :Tabularize /,

vim-swap
  - g>, g< : swaps items under the cursor
  - gs : starts interactive swap mode

abolish
  - crc : camelCase
  - crm : MixedCase
  - cr_, crs : snake_case
  - cru, crU : SNAKE_UPPERCASE
  - cr-, crk : dash-case, kebab-case
  - cr<space> : space case
  - crt : Title Case

vim-unimpaired
  - [q, ]q : go to next quickfix error
  - [s, ]s : go to next spelling error
  - [f, ]f : previous, next file
  - ]<space>, [<space> : add blank lines
  - yos : toggle spell
  - yov : virtual edit
  - yow : wrap
  - yod : toggle diff
  - [p, ]p : linewise pasting
  - =p, =p : linewise pasting, reindent
  - [xx, ]xx : xml encode, decode
  - [uu, ]uu : url encode, decode
  - [yy, ]yy : c string encode, decode

sandwich
  b can be used as placeholder

  - saiw : makes foo to (foo).
  - sd( : deletes surrounding (
  - sr(" : replaces ( with "

exchange
  - cx{motion} : defines region and swaps
  - cxc : clears region
  - {Visual}X : in visual mode

splitjoin
  - gS : splits one line code into multiple
  - gJ : joins code form multiple lines into one

coc.nvim
  - [g, ]g : navigate diagnostics
  - gd : go to definition
  - gy : go to type definition
  - gi : implementation
  - gr : references
  - <space>rn : rename

===============================================================================
6. Readline

 - <C-a>, <C-e>  - start, end of line
 - <C-f>, <C-b>  - forwards, backwards one character
 - <C-d>         - delete one character
 - <M-f>, <M-b>  - forwards, backwards one word
 - <M-d>, <M-BS> - delete forwards, backwards one word

