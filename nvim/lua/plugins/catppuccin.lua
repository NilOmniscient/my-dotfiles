return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
      float = {
        transparent = false,
        solid = false,
      }
    })
    vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
