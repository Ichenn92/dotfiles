return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
        -- Disable netrw
        vim.g.loaded = 1
        vim.g.loaded_netrwPlugin = 1

        -- Set key mappings
        vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
        vim.keymap.set("n", "<leader>lb", ":Neotree buffers reveal float<CR>", {})

        -- Setup neo-tree with recommended settings
        require("neo-tree").setup({
      window = {
            mappings = {
                ["<space>"] = { 
                    "toggle_node", 
                    nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use 
                },
            },
      },
        })
    end,
}
