return {
    "m4xshen/autoclose.nvim",
    config = function()
        require("autoclose").setup({
            keys = {
                ["{"] = { escape = false, close = true, pair = "{}", disabled_filetypes = {} },
                ["["] = { escape = false, close = true, pair = "[]", disabled_filetypes = {} },
                ["("] = { escape = false, close = true, pair = "()", disabled_filetypes = {} },
                ["'"] = { escape = false, close = true, pair = "''", disabled_filetypes = { "text", "markdown" } },
                ['"'] = { escape = false, close = true, pair = '""', disabled_filetypes = {} },
                ["`"] = { escape = false, close = true, pair = "``", disabled_filetypes = {} },
            },
        })
    end
}
