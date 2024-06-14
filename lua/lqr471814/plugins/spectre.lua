return {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set('n', '<leader>re', '<cmd>lua require("spectre").toggle()<CR>', {
            desc = "Toggle Spectre"
        })
    end
}
