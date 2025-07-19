vim.diagnostic.config({ virtual_text = false })

-- UI/Visual settings
vim.opt.termguicolors = true
vim.opt.guicursor = "n-v-c:block"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

-- Line numbers
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true

-- Scrolling and viewport
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.cmdheight = 0

-- Window management
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hidden = true

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Completion
vim.opt.complete = { ".", "w", "b", "u", "t", "i", "kspell" }
vim.opt.completeopt = { "menuone" }

-- Indentation and formatting
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Text wrapping
vim.opt.textwidth = 80
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.breakindent = true

-- Folding
vim.opt.foldlevel = 10
vim.opt.foldmethod = "indent"
vim.opt.fillchars = { foldclose = " ", fold = " ", eob = " " }

-- File handling
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/nvim/undo/"

-- Performance settings
vim.opt.timeout = true
vim.opt.timeoutlen = 200
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 5
vim.opt.updatetime = 50

-- Clipboard
vim.opt.clipboard = "unnamed,unnamedplus"

-- Mouse
vim.opt.mouse = "a"

-- Messages
vim.opt.shortmess = "aToIOWAF"

-- Filetype specific
vim.opt.isfname:append("@-@")
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- LSP hover configuration
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
  width = 60,
  height = 10,
})
