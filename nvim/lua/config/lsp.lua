vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic",
			},
		},
	},
})
vim.lsp.config("ruff", {
	init_options = {
		settings = {
			organizeImports = false,
		},
	},
})
vim.lsp.config("serve_d", {})
vim.lsp.enable("serve_d")
