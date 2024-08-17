return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = { enabled = false },
        },
    },
    -- stylua: ignore
    keys = {
        { "S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
}
