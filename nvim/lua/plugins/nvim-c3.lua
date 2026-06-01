return {
  {
    "ManuLinares/nvim-c3",
    name = "nvim-c3",
    opts = {
      lsp = {
        enable = true, -- Set to false to disable LSP
        cmd = "c3lsp -c3c-path /usr/bin/c3c",
        version = "latest", -- (2)
        compiler_path = nil, -- Custom path to c3c binary (3)
        stdlib_path = nil, -- Custom path to C3 standard library (3)
      },
      formatter = {
        enable = true, -- Set to false to disable formatter
        cmd = "c3fmt",
        format_on_save = false,
        config_file = nil, -- Path to .c3fmt file (1)
        version = "latest", -- (2)
      },
      highlighting = {
        enable_treesitter = true,
      },
    },
  },
}
