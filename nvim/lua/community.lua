-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.completion.blink-cmp" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.zig" },

  -- import/override with your plugins folder
}
