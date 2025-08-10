return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.biome, -- HTML, CSS, JavaScript, and JSON
        null_ls.builtins.formatting.clang_format, -- C/C++
        null_ls.builtins.formatting.dart_format, -- Dart
        null_ls.builtins.formatting.phpcbf, -- PHP
        null_ls.builtins.formatting.stylua, -- Lua
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
