-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- quit all
keymap.set("n", "<leader>qq", "<cmd>quitall<CR>", { desc = "quit all" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

keymap.set("n", "<leader>on", '<cmd>ObsidianNewFromTemplate<CR>', { desc = "new from Obsidian" })

keymap.set("n", "<leader>od", '<cmd>ObsidianToday<CR>', { desc = "new ObsidianToday" })

keymap.set('n', 'q', '<Nop>')

-- paste from clipboard
-- keymap.set({'n', 'v'}, '<C-v>', '"+p', { desc = "paste from clipboard", noremap = true })
keymap.set({'v'}, '<C-v>', '"+p', { desc = "paste from clipboard", noremap = true })
keymap.set({'i', 'c'}, '<C-v>', '<C-r>+', { desc = 'paste from clipboard', noremap = true })
-- Open Neo-tree in the current working directory
vim.keymap.set('n', '<leader>ee', function()
  require("neo-tree.command").execute({
    toggle = true,
    dir = vim.loop.cwd(),
  })
end, { desc = "Explorer (Neo-tree, cwd)", noremap = true, silent = true })

-- Git Explorer
vim.keymap.set('n', '<leader>ge', function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer", noremap = true, silent = true })

-- Buffer Explorer
vim.keymap.set('n', '<leader>be', function()
  require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer Explorer", noremap = true, silent = true })

