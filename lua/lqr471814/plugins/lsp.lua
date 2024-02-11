return {
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip")
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            "L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
        },
    },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            "hrsh7th/nvim-cmp",
		},
        config = function()
            require("neodev").setup({})

            require("mason").setup()
            require("mason-lspconfig").setup()

            require("lspconfig").lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
                }
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
                end,
            })

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = 'luasnip', priority = 30 },
                    { name = 'nvim_lsp', priority = 20 },
                    { name = 'buffer', priority = 10 },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                }),
            })
        end
	},
}
-- return {
--     {
--         'williamboman/mason.nvim',
--         lazy = false,
--         config = true,
--     },
--     {
--         'VonHeikemen/lsp-zero.nvim',
--         branch = 'v3.x',
--         dependencies = {
--             { 'hrsh7th/cmp-nvim-lsp' },
--             { 'neovim/nvim-lspconfig' },
--             { 'williamboman/mason-lspconfig.nvim' },
--         },
--         config = function()
--             local lsp = require('lsp-zero')

--             lsp.extend_lspconfig()
--             lsp.on_attach(function(_, bufnr)
--                 -- see :help lsp-zero-keybindings
--                 -- to learn the available actions
--                 local opts = { buffer = bufnr, remap = false }
--                 lsp.default_keymaps(opts)
--                 vim.keymap.set("n", "ge", function() vim.diagnostic.open_float() end, opts)
--                 vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--                 vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts)
--                 vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
--                 vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
--                 vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--                 vim.keymap.set({ "n", "x", "i" }, "<leader>f", function()
--                     vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
--                 end, opts)
--             end)

--             require('mason').setup({})
--             require('mason-lspconfig').setup({
--                 ensure_installed = {},
--                 handlers = {
--                     lsp.default_setup,
--                 },
--             })

--             require("lspconfig").lua_ls.setup({
--                 settings = {
--                     Lua = {
--                         diagnostics = {
--                             globals = { 'vim' },
--                         }
--                     }
--                 },
--             })
--         end
--     },
-- }

-- return {
--     {
--         'VonHeikemen/lsp-zero.nvim',
--         branch = 'v3.x',
--         lazy = true,
--         config = false,
--         init = function()
--             -- Disable automatic setup, we are doing it manually
--             vim.g.lsp_zero_extend_cmp = 0
--             vim.g.lsp_zero_extend_lspconfig = 0
--         end,
--     },
--     {
--         'williamboman/mason.nvim',
--         lazy = false,
--         config = true,
--     },
--
--     -- LSP
--     {
--         'neovim/nvim-lspconfig',
--         cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
--         event = { 'BufReadPre', 'BufNewFile' },
--         dependencies = {
--             { 'hrsh7th/cmp-nvim-lsp' },
--             { 'williamboman/mason-lspconfig.nvim' },
--         },
--         config = function()
--             -- This is where all the LSP shenanigans will live
--             local lsp_zero = require('lsp-zero')
--             lsp_zero.extend_lspconfig()
--
--             --- if you want to know more about lsp-zero and mason.nvim
--             --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
--             lsp_zero.on_attach(function(_, bufnr)
--                 -- see :help lsp-zero-keybindings
--                 -- to learn the available actions
--                 local opts = { buffer = bufnr, remap = false }
--                 lsp_zero.default_keymaps(opts)
--                 vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--                 vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts)
--                 vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
--                 vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
--                 vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--                 vim.keymap.set({ "n", "x", "i" }, "<leader>f", function()
--                     vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
--                 end, opts)
--             end)
--
--             require('mason-lspconfig').setup({
--                 ensure_installed = {},
--                 handlers = {
--                     lsp_zero.default_setup,
--                     lua_ls = function()
--                         -- (Optional) Configure lua language server for neovim
--                         local lua_opts = lsp_zero.nvim_lua_ls()
--                         require('lspconfig').lua_ls.setup(lua_opts)
--                     end,
--                 }
--             })
--         end
--     }
-- }
