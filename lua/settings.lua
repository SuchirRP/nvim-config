--stuff i coulnt figure out how to do in lua
vim.cmd([[
"Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on
"syntax higlighting on
syntax on
]])

vim.opt.number = true               --line number
vim.opt.cursorcolumn = true         --cursor line higlighting vertically
vim.opt.cursorline = false          --cursor line higlighting horizontally
vim.opt.shiftwidth = 4              --indent depth to 4 spaces
vim.opt.tabstop = 4                 --set tab to 4 spaces
vim.opt.expandtab = true			--use spaces inpace of tabs
vim.opt.wrap = false                --let long lines extend right, and not wrap

vim.opt.incsearch = true            --search as charecters are types in
vim.opt.ignorecase = true           --ignore case during search
vim.opt.smartcase = true            --will only search capital letter if u enter capital
vim.opt.showmatch = true
vim.opt.hlsearch = true             --highlights search

vim.opt.showcmd = true              --show partial command you type in the last line of the screen
vim.opt.showmode = true             --show mode ur in on the last line
vim.opt.history = 1000              --set the commands to save in history default number is 20
vim.opt.wildmenu = true             --enable auto complete menu after pressing tab
