local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end
--lsp server setups
require'lspconfig'.jedi_language_server.setup{                  --python
}
require'lspconfig'.sumneko_lua.setup {                          --lua
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
require'lspconfig'.clangd.setup{                                --c/c++
}
require'lspconfig'.intelephense.setup{                          --php
}
require'lspconfig'.html.setup{                                  --html
}
require'lspconfig'.cssls.setup{                                 --css
}
require'lspconfig'.tsserver.setup{                              --js/typescript/jsreact/typ
}
require'lspconfig'.vimls.setup{                                 --vim
}
