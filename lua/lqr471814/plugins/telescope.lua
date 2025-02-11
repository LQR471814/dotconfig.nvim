return {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>pf", function()
            builtin.find_files({
                find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
            })
        end, {})

        vim.keymap.set("n", "<leader>ps", function()
            local target = vim.fn.input("grep > ")
            builtin.grep_string({
                search = target,
                additional_args = { "--iglob", "!.git", "--hidden" }
            })
        end, {})

        vim.keymap.set("n", "<leader>pg", builtin.git_files)
        vim.keymap.set("n", "<leader>pb", builtin.buffers)
        vim.keymap.set("n", "<leader>pe", "<CMD>Telescope diagnostics<CR>")
        vim.keymap.set("n", "<leader>pc", "<CMD>Telescope commands<CR>")
        vim.keymap.set("n", "<leader>ph", "<CMD>Telescope help_tags<CR>")
    end
}
