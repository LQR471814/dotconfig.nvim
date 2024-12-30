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
    -- theme
    {
        "sho-87/kanagawa-paper.nvim",
        config = function()
            vim.cmd("colorscheme kanagawa-paper")
        end
    },
    -- fancy undos
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    -- file explorer
    {
        'stevearc/oil.nvim',
        opts = {},
    },
    -- line wrap
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },
    {
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
            require("telescope").load_extension("textcase")
        end
    },
    -- pcre syntax
    "othree/eregex.vim",
    -- guess indentation config of a file
    "NMAC427/guess-indent.nvim",
    -- make editing big files faster
    "LunarVim/bigfile.nvim",
    -- luasnip
    require('lqr471814.plugins.luasnip'),
    -- switch between files
    require("lqr471814.plugins.harpoon"),
    -- fuzzy find
    require("lqr471814.plugins.telescope"),
    -- search and replace
    require("lqr471814.plugins.spectre"),
    -- auto close brackets
    require("lqr471814.plugins.autoclose"),
    -- comments
    require("lqr471814.plugins.comment"),
    -- manipulate brackets
    require("lqr471814.plugins.surround"),
    -- AST parsing/syntax highlighting
    require("lqr471814.plugins.treesitter"),
})
