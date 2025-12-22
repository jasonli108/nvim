return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", ":UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
  },
  config = function()
    vim.g.undotree_WindowLayout = 2 -- vertical split
    vim.g.undotree_ShortIndicators = 1
  end
}

