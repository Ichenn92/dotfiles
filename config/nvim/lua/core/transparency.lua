-- Transparency toggle functionality using Catppuccin's built-in transparency
local M = {}

-- State variable to track transparency
local transparency_enabled = false

-- Function to enable transparency using Catppuccin's built-in feature
local function set_transparency()
  -- Check if catppuccin is available
  local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
  
  if catppuccin_ok then
    -- Use Catppuccin's built-in transparency
    catppuccin.setup({
      transparent_background = true,
      integrations = {
        neotree = {
          enabled = true,
          show_root = false,
          transparent_panel = false, -- Keep neo-tree panel opaque
        },
      },
    })
    
    -- Recompile and reload the colorscheme
    vim.cmd('colorscheme ' .. vim.g.colors_name)
  else
    -- Fallback to manual highlight setting for other colorschemes
    vim.cmd([[
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NonText guibg=NONE ctermbg=NONE
      highlight LineNr guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight EndOfBuffer guibg=NONE ctermbg=NONE
      highlight CursorLine guibg=NONE
      highlight CursorLineNr guibg=NONE
      highlight VertSplit guibg=NONE
      highlight WinSeparator guibg=NONE
      highlight StatusLine guibg=NONE
      highlight StatusLineNC guibg=NONE
    ]])
  end
end

-- Function to disable transparency
local function remove_transparency()
  local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
  
  if catppuccin_ok then
    -- Disable Catppuccin's transparency
    catppuccin.setup({
      transparent_background = false,
      integrations = {
        neotree = {
          enabled = true,
          show_root = false,
          transparent_panel = false,
        },
      },
    })
    
    -- Recompile and reload the colorscheme
    vim.cmd('colorscheme ' .. vim.g.colors_name)
  else
    -- Fallback: reload colorscheme to restore original colors
    vim.cmd('colorscheme ' .. vim.g.colors_name)
  end
end

-- Toggle function
function M.toggle()
  transparency_enabled = not transparency_enabled
  
  if transparency_enabled then
    set_transparency()
    print("Transparency enabled")
  else
    remove_transparency()
    print("Transparency disabled")
  end
end

-- Function to check current state
function M.is_enabled()
  return transparency_enabled
end

-- Function to enable transparency
function M.enable()
  if not transparency_enabled then
    M.toggle()
  end
end

-- Function to disable transparency
function M.disable()
  if transparency_enabled then
    M.toggle()
  end
end

return M
