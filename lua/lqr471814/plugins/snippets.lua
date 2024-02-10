return {
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip")
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    },
    {
        "saadparwaiz1/cmp_luasnip",
        dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/nvim-cmp" },
    }
}

