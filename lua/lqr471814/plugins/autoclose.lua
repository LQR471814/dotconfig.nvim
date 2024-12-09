return {
    "m4xshen/autoclose.nvim",
    config = function()
        require("autoclose").setup({
            keys = {
                ["{"] = { escape = false, close = true, pair = "{}", disabled_filetypes = { "latex" } },
                ["["] = { escape = false, close = true, pair = "[]", disabled_filetypes = { "latex" } },
                ["("] = { escape = false, close = true, pair = "()", disabled_filetypes = { "latex" } },
                ["'"] = { escape = false, close = true, pair = "''", disabled_filetypes = { "text", "markdown", "latex" } },
                ['"'] = { escape = false, close = true, pair = '""', disabled_filetypes = { "latex" } },
                ["`"] = { escape = false, close = true, pair = "``", disabled_filetypes = { "latex" } },
            },
        })
    end
}
