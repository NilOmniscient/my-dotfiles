return {
	-- NeoTree File Explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree toggle<cr>",
				desc = "NeoTree Toggle",
			},
			{
				"<leader>o",
				function()
					if vim.bo.filetype == "neo-tree" then
						vim.cmd("wincmd l")
					else
						vim.cmd("Neotree focus")
					end
				end,
				desc = "NeoTree focus",
			},
		},
	},
}
