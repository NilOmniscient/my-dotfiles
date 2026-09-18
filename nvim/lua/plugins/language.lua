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
		ft = { "c3", "c3i", "c3t" },
		build = function()
			require("c3").update()
		end,
		config = true,
	},
}
