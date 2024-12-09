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
        "ray-x/go.nvim",
        config = function()
            require("go").setup()

            local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()'
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            "hrsh7th/nvim-cmp",
            "b0o/schemastore.nvim",
        },
        config = function()
            require("neodev").setup({})

            require("mason").setup()
            require("mason-lspconfig").setup()

            require("lspconfig").texlab.setup {}
            require("lspconfig").vtsls.setup({
                settings = {
                    vtsls = {
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true
                            }
                        }
                    },
                    javascript = {
                        preferences = {
                            autoImportFileExcludePatterns = {
                                "node_modules/**"
                            }
                        },
                        updateImportsOnFileMove = { enabled = "always" },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                    },
                    typescript = {
                        preferences = {
                            autoImportFileExcludePatterns = {
                                "node_modules/**"
                            }
                        },
                        updateImportsOnFileMove = { enabled = "always" },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                    }
                }
            })
            require("lspconfig").lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
                }
            })
            require("lspconfig").jsonls.setup({
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
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
                    vim.keymap.set("n", "ge", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                    -- rename with a completely different name
                    vim.keymap.set("n", "<leader>rr", function()
                        vim.ui.input(
                            {
                                prompt = "Rename: ",
                                default = "",
                            },
                            function(input)
                                if input then
                                    vim.lsp.buf.rename(input)
                                end
                            end
                        )
                    end, opts)
                    -- rename starting with the same name
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
                    vim.keymap.set({ "n" }, "<leader>f", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, opts)
                    vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
                    vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
                end,
            })

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = 'luasnip',  priority = 30 },
                    { name = 'nvim_lsp', priority = 20 },
                    { name = 'buffer',   priority = 10 },
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
