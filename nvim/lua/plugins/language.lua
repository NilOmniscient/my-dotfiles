return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = true,
	},
	{
		"ManuLinares/nvim-c3",
		build = function()
			require("c3").update()
		end,
		config = true,
	},
}
