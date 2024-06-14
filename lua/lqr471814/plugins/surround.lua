return {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            keymaps = {
                normal = "ys",
                normal_cur = "yss",
                visual = "S",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
                change_line = "cS",
            },
            -- disables the whitespace in front and back of the thing
            surrounds = {
                ["("] = false,
                ["["] = false,
                ["{"] = false,
            },
            aliases = {
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
            },
        })
    end
}

-- quick reference
-- yss<new> - surround line with <new>
-- ysiw<new> - surround word with <new>
-- ysa<thing><new> - surround <thing> with <new>
-- (in visual mode) S<new> - surround selection with <new>
-- (in visual line mode) gS<new> - surround each selection with <new>
-- cs/ds<target><new> - replace <target> with <new>
