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
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
            vim.keymap.set("n", "<C-p>", builtin.git_files, {})
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("grep > ") })
            end, {})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("lqr471814.plugins.treesitter")
        end
    },
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
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require("Comment").setup()
        end
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    require("lqr471814.plugins.lsp"),
    require("lqr471814.plugins.snippets"),
    require("lqr471814.plugins.autocomplete"),
})
