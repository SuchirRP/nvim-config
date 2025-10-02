-- init.lua

-- Editor Settings
vim.opt.compatible = false			-- disble vi compatibility
vim.opt.showmatch = true			-- show matching
vim.opt.mouse = 'a'				    -- enable mouse in all modes
vim.opt.hlsearch = true				-- highlight search
vim.opt.incsearch = true			-- incremental search
vim.opt.ignorecase = true           -- ignore case during search
vim.opt.tabstop = 4				    -- tab = 4 spaces
vim.opt.softtabstop = 4				-- recognize 4 spaces as tab
vim.opt.expandtab = true			-- converts tabs to white spaces
vim.opt.shiftwidth = 4				-- autoindent number of spaces
vim.opt.autoindent = true			-- indent new line to same amount as current
vim.opt.number = true				-- adds line numbers
vim.opt.wildmode = 'longest:full,full'		-- get bash-like completions
vim.cmd("filetype plugin indent on")		-- allow auto indenting depending on file type
vim.cmd("syntax on")				-- syntax highlighting
vim.opt.clipboard = 'unnamedplus'			-- use system clipboard
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
    {'folke/tokyonight.nvim'},                      -- tokyonight
    {'ellisonleao/gruvbox.nvim'},                   -- gruvbox

    -- lsp stuff
    {'neovim/nvim-lspconfig'},                      -- nvim lspconfig
    {'williamboman/mason.nvim'},                    -- lsp installer/manager
    {'williamboman/mason-lspconfig.nvim'},
    {'nvimtools/none-ls.nvim'},                     -- for formatters and linters
    {'mfussenegger/nvim-lint'},                     -- linter plugin
    {'j-hui/fidget.nvim'},                          -- nvim-lsp load progress
    {'folke/neodev.nvim'},                          -- configures lua-language-server for your Neovim config
    {'folke/trouble.nvim', dependencies = {         -- prettier diagnostics
        "nvim-tree/nvim-web-devicons"}},

    -- dap (debugger)
    {'mfussenegger/nvim-dap'},
    {'rcarriga/nvim-dap-ui', dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'}},
    {'jay-babu/mason-nvim-dap.nvim'}, -- Bridge for mason to install debug adapters

    -- autocomplete
    {'hrsh7th/nvim-cmp', dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip',                         -- luasnips snippet for completion engine
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets'              -- adds community snippets
    }},

    -- treesitter
    {'nvim-treesitter/nvim-treesitter', dependencies = {                -- syntax highlighting
        'nvim-treesitter/nvim-treesitter-textobjects'}},
    {'nvim-telescope/telescope.nvim', dependencies = {                  -- fuzzy finding
        'nvim-lua/plenary.nvim' }},
    {'nvim-treesitter/playground'},

    -- tabline and statusline
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},           -- bufferline
    {'nvim-lualine/lualine.nvim'},                                                                      -- lualine

    -- misc
    {'nvim-tree/nvim-web-devicons'},                -- devicons
    {'ntpeters/vim-better-whitespace'},             -- trims whtespaces
    {'cohama/lexima.vim'},                          -- autopairs brackets and quotes
    {'kaarmu/typst.vim'},                           -- typst plugin
    {'dccsillag/magma-nvim'}                        -- Jupyter notebooks in nvim
})

-- =============================================================================
-- -- CONFIGURATIONS
-- =============================================================================

--- color scheme
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
})
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme catppuccin-mocha]])

---
--- mason: ensure our tools are installed
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-nvim-dap").setup({
    ensure_installed = {
        -- debug adapters
        "python", -- installs debugpy
    },
    -- auto-setup python dap
    handlers = {}
})

---
--- lspconfig: keymaps and capabilities
require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = {
        "lua_ls", "clangd", "bashls", "jedi_language_server",
        "html", "cssls", "tsserver", "jdtls", "tinymist",
    },
    -- This handler function runs for every server that is set up.
    handlers = {
        function(server_name) -- The default handler
            require("lspconfig")[server_name].setup({
                on_attach = function(client, bufnr)
                    local opts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

                    -- Format on save with none-ls
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
                            buffer = bufnr,
                            callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
                        })
                    end
                end,
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
        end,
        -- custom handler for typst
        ["tinymist"] = function()
            require("lspconfig").tinymist.setup({
                filetypes = {"typst"},
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
        end,
    }
})


---
--- none-ls: formatting and linting
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- formatters
        null_ls.builtins.formatting.stylua, -- for lua
        null_ls.builtins.formatting.black, -- for python
        null_ls.builtins.formatting.prettier, -- for web dev
    },
})

---
--- nvim-lint: dedicated linter
local lint = require('lint')
lint.linters_by_ft = {
  python = {'pylint'},
}
-- run linters on events
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

---
--- nvim-dap: debugger configuration
local dap, dapui = require("dap"), require("dapui")

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
        },
    },
})

-- dap event listeners for dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

---
--- nvim-cmp: autocompletion
local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

---
--- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python"},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
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

-- =============================================================================
-- -- KEYMAPS
-- =============================================================================
vim.g.mapleader = ' ' -- Sets the leader key to the space bar
vim.g.maplocalleader = ' '

---misc
vim.keymap.set('n', '<leader>no', ':nohl<CR>', {silent = true })
---spellcheck toggle
vim.keymap.set('n', '<leader>sp', ':set spell<CR>', {silent = true})
vim.keymap.set('n', '<leader>nsp', ':set nospell<CR>', {silent = true})
---tabs
vim.keymap.set('n', '<leader>new', ':tabe<CR>', {silent = true })
vim.keymap.set('n', '<A-tab>', ':tabn<CR>', {silent = true })
---nvim trouble
vim.keymap.set('n', '<A-e>', ':TroubleToggle<CR>', {silent = true })

---telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

---vim-better-whitespace
vim.keymap.set('n', '<leader>wh', ':ToggleWhitespace<CR>', {silent = true})      --toggle extraneous whitespace highlighting
vim.keymap.set('n', '<leader>tr', ':StripWhitespace<CR>', {silent = true})        --trim extraneous whitespace

---formatting
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, {desc = "Format current buffer"})

---debugger (dap)
vim.keymap.set('n', '<leader>du', ':DapUIToggle<CR>', {desc = "Toggle Debug UI"})
vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>', {desc = "Toggle Breakpoint"})
vim.keymap.set('n', '<leader>dc', ':DapContinue<CR>', {desc = "Continue Debugger"})
vim.keymap.set('n', '<leader>do', ':DapStepOver<CR>', {desc = "Step Over"})
vim.keymap.set('n', '<leader>di', ':DapStepInto<CR>', {desc = "Step Into"})
vim.keymap.set('n', '<leader>de', ':DapStepOut<CR>', {desc = "Step Out"})
