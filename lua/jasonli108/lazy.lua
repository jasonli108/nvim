# nvim plugin needs java, goland-go, nodejs, npm, python3,fzf 

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "jasonli108.plugins" },
  { import = "jasonli108.plugins.coding" },
  { import = "jasonli108.plugins.editor" },
  { import = "jasonli108.plugins.game" },
  { import = "jasonli108.plugins.git" },
  { import = "jasonli108.plugins.lsp" },
  { import = "jasonli108.plugins.lang" },
  { import = "jasonli108.plugins.ui" },
  { import = "jasonli108.plugins.utils" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
