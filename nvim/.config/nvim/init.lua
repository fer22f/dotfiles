-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end


require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- mini.nvim
  use 'echasnovski/mini.nvim'
  -- animate the cursor
  use 'echasnovski/mini.animate'
  -- highlight current word
  use 'echasnovski/mini.cursorword'
  -- move selection up/down
  use 'echasnovski/mini.move'
  -- trailing whitespace
  use 'echasnovski/mini.trailspace'

  use {
    'ckolkey/ts-node-action',
    requires = { 'nvim-treesitter' },
    config = function()
      local tsNodeAction = require 'ts-node-action'
      tsNodeAction.setup {}
      vim.keymap.set({ "n" }, "gS", tsNodeAction.node_action, { desc = "Trigger Node Action" })
    end
  }

  use 'mizlan/iswap.nvim'

  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- "gc" to comment visual regions/lines
  use 'numToStr/Comment.nvim'
  -- Highlight, edit, and navigate code
  use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  -- Refactor
  use 'nvim-treesitter/nvim-treesitter-refactor'
  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'
  -- Automatically install language servers to stdpath
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  -- Autocompletion
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }
  -- Theme
  use { 'ellisonleao/gruvbox.nvim' }
  -- Fancier statusline
  use 'nvim-lualine/lualine.nvim'
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Detect tabstop and shiftwidth automatically
  use 'tpope/vim-sleuth'
  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Return to last place
  use 'farmergreg/vim-lastplace'
  -- Readline bindings in insert/terminal mode
  use 'tpope/vim-rsi'
  -- Clear search after insert mode is entered or the cursor moves
  use 'pgdouyon/vim-evanesco'
  -- Mappings for :cnext, :cprev, :bnext, :bprev
  use 'tpope/vim-unimpaired'
  -- :Rename
  use 'tpope/vim-eunuch'
  -- Coerce to camel case, etc
  use 'tpope/vim-abolish'
  -- Sandwich
  use 'machakann/vim-sandwich'
  -- Better asterisk
  use 'haya14busa/vim-asterisk'
  -- hlslens
  use 'kevinhwang91/nvim-hlslens'
  -- Exchange
  use 'tommcdo/vim-exchange'
  -- Fold licenses
  use 'vim-scripts/Fold-License'

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 }

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

vim.o.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
vim.o.title = true -- set the title of window to the value of the titlestring
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.swapfile = false -- creates a swapfile
-- Add split window to substitute command
vim.o.inccommand = 'split'
-- Color column to PEP
vim.o.colorcolumn = "79"
-- Disable backup
vim.o.backup = false
-- Set highlight on search
vim.o.hlsearch = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- Pop up menu height
vim.o.pumheight = 10
-- we don't need to see things like -- INSERT -- anymore
vim.o.showmode = false
-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true -- set relative numbered lines
vim.o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
CACHE_PATH = vim.fn.stdpath "cache"
vim.o.undodir = CACHE_PATH .. "/undo" -- set an undo directory
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
-- Set colorscheme
vim.o.termguicolors = true
vim.o.background = "dark"

vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.cursorline = true -- highlight the current line
vim.o.showmatch = true
vim.o.matchtime = 2
vim.o.list = true
vim.o.listchars = 'trail:•,tab:» '

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>v', ":e $MYVIMRC<CR>")
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

require('hlslens').setup()

vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('gruvbox').setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = false
  },
  strikethrough = true,
  invert_selection = true,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard",
  overrides = {},
})
vim.cmd [[colorscheme gruvbox]]

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = "gruvbox",
    component_separators = '|',
    section_separators = '',
  },
}

require('Comment').setup()

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#424242]]
require('ibl').setup {
  indent = {
    highlight = {
      "IndentBlanklineIndent1",
    },
    char = "▏",
  },
  whitespace = {
    remove_blankline_trail = true,
    highlight = {
      "IndentBlanklineIndent1",
    },
  },
}

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('telescope').setup {
  defaults = {
    borderchars = {
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { " " },
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')

vim.api.nvim_create_autocmd({"User"}, {
  pattern = {"TelescopePreviewerLoaded"},
  command = "call FoldLicense()"
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  command = "normal zX",
})

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').treesitter, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', 'S', [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>]])

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'lua', 'typescript', 'rust', 'go', 'python' },

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ['g>'] = '@parameter.inner',
      },
      swap_previous = {
        ['g<'] = '@parameter.inner',
      },
    },
  },
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
  },
}

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', require('telescope.builtin').lsp_references)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.format or vim.lsp.buf.formatting, { desc = 'Format current buffer with LSP' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities({})

require('mason').setup()
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'lua_ls', 'denols' }
require('mason-lspconfig').setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local animate = require('mini.animate')
animate.setup {
  cursor = { timing = animate.gen_timing.linear({ duration = 50, unit = "total" }) },
  scroll = { timing = animate.gen_timing.linear({ duration = 25, unit = "total" }) }
}
require('mini.trailspace').setup()
require('mini.move').setup()
require('mini.cursorword').setup()

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- vim: ts=2 sts=2 sw=2 et
