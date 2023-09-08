    -- Editor Settings
vim.opt.compatible = false			-- disble vi compatibility
vim.opt.showmatch = true			-- show matching
vim.opt.mouse = v				-- middle-click paste
vim.opt.hlsearch = true				-- highlight search
vim.opt.incsearch = true			-- incremental search
vim.opt.ignorecase = true           -- ignore case during search
vim.opt.tabstop = 4				-- tab = 4 spaces
vim.opt.softtabstop = 4				-- recognize 4 spaces as tab
vim.opt.expandtab = true			-- converts tabs to white spaces
vim.opt.shiftwidth = 4				-- autoindent number of spaces
vim.opt.autoindent = true			-- indent new line to same amount as current
vim.opt.number = true				-- adds line numbers
vim.opt.wildmode = longest,true			-- get bash-like completions
vim.cmd("filetype plugin indent on")		-- allow auto indenting dependin on file type
vim.cmd("syntax on")				-- syntax highlightinhg
vim.cmd.mouse = a				-- enable mouse click
vim.cmd.clipboard = unnamedplus			-- use system clipboard
vim.cmd("filetype plugin on")
vim.opt.ttyfast = true				-- speed up scrolling
--vim.opt.spell = true				-- enable spell checking
--vim.opt.noswapfile = true			-- disable swap file

-- Lazy nvim - Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- color scheme
    {'catppuccin/nvim'},                            -- catppuccin colorscheme
    {'folke/tokyonight.nvim'},                       -- tokyonight

    -- lsp stuff
    {'neovim/nvim-lspconfig'},                      -- nvim lspconfig
    {'williamboman/mason.nvim', dependencies = {    -- lsp installer
        'williamboman/mason-lspconfig.nvim',
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
        'jose-elias-alvarez/null-ls.nvim',
        'mfussenegger/nvim-lint',
        'jose-elias-alvarez/null-ls.nvim',
        'mhartington/formatter.nvim'}},
    {'j-hui/fidget.nvim'},                          -- nvim-lsp load progress
    {'folke/neodev.nvim'},                          -- configures lua-language-server for your Neovim config
    {'folke/trouble.nvim', dependencies = {         -- prettier diagnostics
        "nvim-tree/nvim-web-devicons"}},

    -- autocomplete
    {'hrsh7th/nvim-cmp', dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',

        'L3MON4D3/LuaSnip',                         -- luasnips snippet for completion engine
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets'              -- adds community snippets
    }},

    -- treesitter
    {'nvim-treesitter/nvim-treesitter', dependencies = {                -- syntax highlighting
        'nvim-treesitter/nvim-treesitter-textobjects'}},
    {'nvim-telescope/telescope.nvim', dependencies = {                  -- fuzzy finding
        'nvim-lua/plenary.nvim' }},
    {'nvim-treesitter/playground'},                                     --

    -- tabline and statusline
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},           -- bufferline
    {'nvim-lualine/lualine.nvim'},                                                                      -- lualine

    -- misc
    {'folke/which-key.nvim'},                       -- shows possible keybinds
    {'nvim-tree/nvim-web-devicons'},                -- devicons
    {'ntpeters/vim-better-whitespace'},             -- trims whtespaces
    {'cohama/lexima.vim'},                          -- autopairs brackets and quotes
    {'kaarmu/typst.vim'}                            -- typst plugin

})

-- configs
--- color scheme
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
})
require("tokyonight").setup({
  style = "night",
  })
vim.cmd.colorscheme "tokyonight"
---
--- lsp stuff
--- mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup()
---
--- nvim-cmp
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
---
--- lspconfig
local lspconfig = require('lspconfig')              -- set up induvidual servers after this point
require("lspconfig").lua_ls.setup {}                -- lua
require("lspconfig").clangd.setup {}                -- c/c++
require("lspconfig").bashls.setup {}                -- bash
require'lspconfig'.jedi_language_server.setup{}     -- python
require("lspconfig").html.setup {}                  -- html
require("lspconfig").cssls.setup {}                 -- css
require("lspconfig").tsserver.setup {}              -- typescript/javascript
require("lspconfig").typst_lsp.setup {              -- typst
    filetype = {typst}
}
require("lspconfig").jdtls.setup {}              -- java
---
--- treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  --ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
---
---bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}
---
---lualine
require('lualine').setup {
    options = {
        theme = 'iceberg_dark'
    }}
---

-- Keymaps
---misc
vim.keymap.set('n', 'no', ':nohl<CR>', {silent = true })

---tabs
vim.keymap.set('n', 'new', ':tabe<CR>', {silent = true })
vim.keymap.set('n', '<A-m>', ':tabn<CR>', {silent = true })

---nvim trouble
vim.keymap.set('n', '<A-e>', ':TroubleToggle<CR>', {silent = true })

---telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
---vim-better-whitespace
vim.keymap.set('n', 'wh', ':ToggleWhitespace<CR>', {silent = true})      --toggle extraneous whitespace highlighting
vim.keymap.set('n', 'trim', ':StripWhitespace<CR>', {silent = true})        --trim extraneous whitespace highlighting
--