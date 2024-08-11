vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

local function setIndent(files, size, tabs)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = files,
        callback = function()
            if tabs then
                vim.opt.tabstop = size
                vim.opt.shiftwidth = size
                vim.opt.expandtab = false
            else
                vim.opt.tabstop = 8
                vim.opt.softtabstop = size
                vim.opt.shiftwidth = size
                vim.opt.expandtab = true
            end
        end
    })
end

setIndent({ "*.js", "*.svelte", "*.ts", "*.tsx", "*.jsx", "*.json", "*.yaml", "*.dart", "*.proto" }, 2)
setIndent({ "*.md" }, 3)
setIndent({
    "*.rs",
    "*.py",
    "*.lua",
    "*.sh",
    "Dockerfile*",
    "*.html",
    "*.cpp",
    "*.c",
    "*.xml",
    "*.sql",
}, 4)
setIndent({ "*.go", "Makefile*", "*.json5" }, 4, true)

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.g.mapleader = " "

vim.opt.autoread = true

vim.keymap.set("n", "gy", "\"+y")
vim.keymap.set("v", "gy", "\"+y")
vim.keymap.set("n", "gyy", "\"+Y")
vim.keymap.set("n", "gyp", "let @\" = expand(\"%\")")

vim.keymap.set("n", "gp", "\"+p")
vim.keymap.set("v", "gp", "\"+p")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v", "i", "x" }, "<C-z>", "<nop>")

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
