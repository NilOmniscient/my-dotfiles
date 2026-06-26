require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- NVim Tree Overrides
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NVim Tree" })
map("n", "<leader>o", function()
  if vim.fn.bufname():match 'NvimTree_' then
    vim.cmd.wincmd 'p'
  else 
    vim.cmd('NvimTreeFocus')
  end
end, { desc = "Toggle NvimTree focus"})

-- Terminal Overrides
map("n", "<leader>t", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-N>", { desc = "Terminal escape" })

-- Overseer Controls
map("n", "<F6>", "<cmd>CompilerOpen<cr>", { desc = "Compile Target" })
map("n", "<S-F7>", "<cmd>CompilerToggle<cr>", { desc = "Toggle Overseer" })

-- Tabufline
map("n", "<leader>c", function() require("nvchad.tabufline").close_buffer() end, { desc = "Close tab" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
