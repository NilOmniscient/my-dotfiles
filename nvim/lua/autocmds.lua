require "nvchad.autocmds"
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    vim.cmd("lsp restart")
    if package.loaded["nvim-tree.api"] then
      require("nvim-tree.api").tree.reload()
    end
  end,
})
