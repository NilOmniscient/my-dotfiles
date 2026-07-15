-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
map("n", "<leader>th", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

-- Keymaps for Overseer/Compiler
map("n", "<F6>", "<cmd>CompilerOpen<cr>", {
  noremap = true,
  silent = true,
})
map("n", "<S-F6>", "<cmd>CompilerStop<cr>" .. "<cmd>CompilerRedo<cr>", {
  noremap = true,
  silent = true,
})
map("n", "<S-F7", "<cmd>CompilerToggleResults<cr>", {
  noremap = true,
  silent = true,
})
