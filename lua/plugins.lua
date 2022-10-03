local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    use {"wbthomason/packer.nvim"}	                --let packer manage self

    --use {"mhinz/vim-startify"}                      --vim startpage
    use {"startup-nvim/startup.nvim"}               --vim startpage

    --themes
    use {"ellisonleao/gruvbox.nvim"}
    use {"xiyaowong/nvim-transparent"}              --transperent background

    --devicons
    use {"kyazdani42/nvim-web-devicons"}            --enables use of icons by nerdtree, etc

    --custom stausline and buffer

    --file explorer
    use {"kyazdani42/nvim-tree.lua", requires = {"kyazdani42/nvim-web-devicons"}}

    --undotree
    use {"mbbill/undotree"}

    --color preview
    use {"brenoprata10/nvim-highlight-colors"}

    --nvim indent lines
    use {"lukas-reineke/indent-blankline.nvim"}
    use {"p00f/nvim-ts-rainbow"}                    --rainbow highlints for brackets highlighting
    use {"zakharykaplan/nvim-retrail"}              --remove trailing spaces on :w

    use {"RRethy/vim-illuminate"}                   --highlight all usage of variables when under cursor
    use {"tpope/vim-endwise"}                       --and end and the likes to languages like lua, ruby, vimscript, etc that need them automatically
    use {"rstacruz/vim-closer"}                     --closes brackets on enter

    --snippets
    use {"SirVer/ultisnips"}                        --snipet engine
    use {"honza/vim-snippets"}                      --snipet library

    --lsp stuff
    use {"j-hui/fidget.nvim"}                       --Shows lspserver setup status
    use {"neovim/nvim-lspconfig"}                   -- Configurations for Nvim LSP
    use {"williamboman/mason.nvim"}                 --installs lsp servers
    use {"williamboman/mason-lspconfig.nvim"}       --ensures proper integration
    --nvim cmp + depecdency plugins
    use {"hrsh7th/cmp-nvim-lsp"}
    use {"hrsh7th/cmp-buffer"}
    use {"hrsh7th/cmp-path"}
    use {"hrsh7th/cmp-cmdline"}
    use {"hrsh7th/nvim-cmp"}
    use {"quangnguyen30192/cmp-nvim-ultisnips"}     --ultisnips integration
    --treesitter and telescope
    use {"nvim-treesitter/nvim-treesitter"}         --imporoved syntax highlighting
    use {"nvim-treesitter/playground"}
    use {"nvim-lua/plenary.nvim"}
    use {"nvim-telescope/telescope.nvim", tag = "0.1.0", requires = { {"nvim-lua/plenary.nvim"} }}
    use {"stevearc/aerial.nvim"}                    --code outline window for skimming and quick navigation
    --trouble and lspsaga
    use {"folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons"}       --pretty diagnostics
    use {"glepnir/lspsaga.nvim", branch = "main",}                              --code action shower


    if packer_bootstrap then
        require('packer').sync()
    end
end)
