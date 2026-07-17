-- Require Lazy first
require("config.lazy")
require("lazy").setup("plugins")

-- Now we can include everything else
require("config")

-- Finally, set the colorscheme
vim.cmd.colorscheme("catppuccin-nvim")
require("lualine").setup()
