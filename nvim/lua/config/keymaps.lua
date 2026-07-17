-- smart-splits mappings
-- resize mappings
vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left)
vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down)
vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up)
vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

-- Terminal
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm<cr>")

-- Compiler settings
vim.api.nvim_set_keymap("n", "<F6>", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<S-F6>",
	"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
		.. "<cmd>CompilerRedo<cr>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

-- Safely close buffer tab
vim.keymap.set("n", "<leader>c", function()
	local current_buf = vim.api.nvim_get_current_buf()
	require("bufferline").cycle(1)
	vim.cmd("bdelete! " .. current_buf)
end, { desc = "Close Tab" })
