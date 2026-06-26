require "nvchad.autocmds"
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    if package.loaded["nvim-tree.api"] then
      require("nvim-tree.api").tree.reload()
    end
  end,
})
