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
            "b0o/schemastore.nvim",
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

            local golang_organize_imports = function(bufnr, isPreflight)
                local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding(bufnr))
                params.context = { only = { "source.organizeImports" } }

                if isPreflight then
                    vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function() end)
                    return
                end

                local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                for _, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding(bufnr))
                        else
                            vim.lsp.buf.execute_command(r.command)
                        end
                    end
                end
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "ge", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
                    vim.keymap.set({ "n" }, "<leader>f", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, opts)
                    vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
                    vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.name == "gopls" then
                        -- hack: Preflight async request to gopls, which can prevent blocking when save buffer on first time opened
                        golang_organize_imports(bufnr, true)

                        vim.api.nvim_create_autocmd("BufWritePre", {
                            pattern = "*.go",
                            group = vim.api.nvim_create_augroup("LspGolangOrganizeImports." .. bufnr, {}),
                            callback = function()
                                golang_organize_imports(bufnr)
                            end,
                        })
                    end
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
