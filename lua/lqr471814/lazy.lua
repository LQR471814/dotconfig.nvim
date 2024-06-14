-- Bootstrap lazyvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Actual plugin definition

require("lazy").setup({
    "tpope/vim-sleuth",
    "windwp/nvim-ts-autotag",
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd("colorscheme kanagawa-wave")
        end
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "VeryLazy"
    },
    {
        "numToStr/Comment.nvim",
        lazy = false,
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            'smoka7/hydra.nvim',
        },
        opts = {},
        cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
        keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>m',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
    },
    {
        'stevearc/oil.nvim',
        opts = {},
    },
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },
    "kblin/vim-fountain",
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.keymap.set('n', '<leader>re', '<cmd>lua require("spectre").toggle()<CR>', {
                desc = "Toggle Spectre"
            })
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set({ "n", "i" }, "<C-1>", function() harpoon:list():select(1) end)
            vim.keymap.set({ "n", "i" }, "<C-2>", function() harpoon:list():select(2) end)
            vim.keymap.set({ "n", "i" }, "<C-3>", function() harpoon:list():select(3) end)
            vim.keymap.set({ "n", "i" }, "<C-4>", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set({ "n", "i" }, "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set({ "n", "i" }, "<C-S-N>", function() harpoon:list():next() end)
        end
    },
    "NMAC427/guess-indent.nvim",
    {
        "m4xshen/autoclose.nvim",
        config = function()
            require("autoclose").setup({
                keys = {
                    ["{"] = { escape = false, close = true, pair = "{}", disabled_filetypes = {} },
                    ["["] = { escape = false, close = true, pair = "[]", disabled_filetypes = {} },
                    ["("] = { escape = false, close = true, pair = "()", disabled_filetypes = {} },
                    ["'"] = { escape = false, close = true, pair = "''", disabled_filetypes = {} },
                    ['"'] = { escape = false, close = true, pair = '""', disabled_filetypes = {} },
                    ["`"] = { escape = false, close = true, pair = "``", disabled_filetypes = {} },
                },
            })
        end
    },
    require("lqr471814.plugins.telescope"),
    require("lqr471814.plugins.treesitter"),
    require("lqr471814.plugins.lsp"),
})
