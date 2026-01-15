-- リーダーキー
vim.g.mapleader = " "

-- オプション設定
local opt = vim.opt
opt.mouse = 'a'
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.laststatus = 2
opt.splitright = true
opt.autochdir = true

vim.filetype.add({
  extension = {
    hujson = "json"
  }
})

require("config.lazy")

-- vscode neovim
vim.g.vscode = os.getenv("VSCODE_NVIM") ~= nil
