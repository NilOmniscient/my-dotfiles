require "nvchad.autocmds"

local lazygit_closed = function()
  if package.loaded["nvim-tree.api"] then
    require("nvim-tree.api").tree.reload()
  end
  vim.cmd("lsp restart")
end
vim.g.lazygit_on_exit_callback = lazygit_closed
