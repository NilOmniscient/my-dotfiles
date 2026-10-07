 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#282a36',
    base01 = '#44475a',
    base02 = '#4d5066',
    base03 = '#6d728b',
    base04 = '#d6d8e0',
    base05 = '#f8f8f2',
    base06 = '#f8f8f2',
    base07 = '#f8f8f2',
    base08 = '#ff5555',
    base09 = '#8be9fd',
    base0A = '#ff79c6',
    base0B = '#bd93f9',
    base0C = '#82e7fd',
    base0D = '#b586f8',
    base0E = '#ff80c9',
    base0F = '#ffb3de',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#f8f8f2',          bg = '#282a36' })
  hi('TelescopeBorder',         { fg = '#6d728b',             bg = '#282a36' })
  hi('TelescopePromptNormal',   { fg = '#f8f8f2',          bg = '#282a36' })
  hi('TelescopePromptBorder',   { fg = '#6d728b',             bg = '#282a36' })
  hi('TelescopePromptPrefix',   { fg = '#bd93f9',             bg = '#282a36' })
  hi('TelescopePromptCounter',  { fg = '#d6d8e0',  bg = '#282a36' })
  hi('TelescopePromptTitle',    { fg = '#282a36',             bg = '#bd93f9' })
  hi('TelescopePreviewTitle',   { fg = '#282a36',             bg = '#ff79c6' })
  hi('TelescopeResultsTitle',   { fg = '#282a36',             bg = '#8be9fd' })
  hi('TelescopeSelection',      { fg = '#f8f8f2',          bg = '#4d5066' })
  hi('TelescopeSelectionCaret', { fg = '#bd93f9',             bg = '#4d5066' })
  hi('TelescopeMatching',       { fg = '#bd93f9',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#f8f8f2',          bg = '#282a36' })
  hi('MiniPickBorder',         { fg = '#6d728b',             bg = '#282a36' })
  hi('MiniPickPrompt',   { fg = '#f8f8f2',          bg = '#282a36' })
  hi('MiniPickPromptPrefix',   { fg = '#bd93f9',             bg = '#282a36' })
  hi('MiniPickBorderText',    { fg = '#282a36',             bg = '#bd93f9' })
  hi('MiniPickMatchCurrent',      { fg = '#f8f8f2',          bg = '#4d5066' })
  hi('MiniPickPromptCaret', { fg = '#bd93f9',             bg = '#4d5066' })
  hi('MiniPickMatchRanges',       { fg = '#bd93f9',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
