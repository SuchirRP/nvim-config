-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--general keybinds
map("n", "<A-n>", ":tabe<CR>")              --new tab
map("n", "<A-m>", ":tabn<CR>")              --next tab

--nvim-tree keymaps
map("n", "<C-l>", ":NvimTreeToggle<CR>")    --opens nvim tree
--undo tree
map("n", "<C-u>", ":UndotreeToggle<CR>")    --opens undo tree
map("n", "<C-y>", ":UndotreeFocus<CR>")

--terminal
map("n", "term", ":terminal<cr>")           --opens terminal    -- Ctrl-\ + Ctrl-n to enter command mode from terminal tab
map("n", "n", ":nohlsearch<cr>")


--lspconfig keybindings
--diagnostics stuff
--:help vim.diagnostic
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<A-e>', vim.diagnostic.open_float, opts)       --expands an induvidual diagnostic on highlighting with cursor
vim.keymap.set('n', 'd[', vim.diagnostic.goto_prev, opts)           --prev diagnostic
vim.keymap.set('n', 'd]', vim.diagnostic.goto_next, opts)           --next diagnostic
--vim.keymap.set('n', '<C-d>', vim.diagnostic.setloclist, opts)       --shows all diagnostics in a dropdown --replaced by trouble.nvim

--implementation and definitions
-- Enable completion triggered by <c-x><c-o>

--telescope shortcuts
map("n", "ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
map("n", "tt", ":Telescope treesitter<cr>")
map("n", "<C-a>", ":AerialOpen")

--trouble lspsaga keymaps
map("n", "<C-d>", ":TroubleToggle<cr>")

local action = require("lspsaga.codeaction")
vim.keymap.set("n", "ca", action.code_action, { silent = true })
