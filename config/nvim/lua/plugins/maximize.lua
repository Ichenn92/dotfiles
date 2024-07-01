return {
  'declancm/maximize.nvim',
  config = function()
    require('maximize').setup()

    -- Remap keys inside the config
    vim.api.nvim_set_keymap('n', '<leader>sm', ':Maximize<CR>', { noremap = true, silent = true })
  end
}
