require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html", "cssls", "dartls",
  "ols", "zls", "clangd", "glslls",
  "jsonls", "phpactor", "slangd",
  "ts_ls", "serve_d",
}
vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers 
