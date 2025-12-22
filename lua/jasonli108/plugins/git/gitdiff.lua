return { "sindrets/diffview.nvim",
cmd={"DiffviewOpen", "DiffviewClose", "DiffviewRefresh","DiffviewToggleFiles","DiffviewFileHistory" },
keys={
    {"<leader>gdo", "<cmd>DiffviewOpen<CR>",desc="open diffview"},
    {"<leader>gdc", "<cmd>DiffviewClose<CR>",desc="colse diffview"},
    {"<leader>gdr", "<cmd>DiffviewRefresh<CR>",desc="refresh diffview"},
    {"<leader>gdt", "<cmd>DiffviewToggleFiles<CR>",desc="diffview toggle files"},
    {"<leader>gdh", "<cmd>DiffviewFileHistory<CR>",desc="diffview file history"},
  },
  opts={
    enhanced_diff_hl=true,
    use_icons=true,

  }
}
