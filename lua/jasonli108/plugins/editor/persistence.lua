-- ~/.config/nvim/lua/plugins/persistence.lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre",

  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = {
      "buffers",
      "curdir",
      "tabpages",
      "winsize",
    },
  },

  init = function()
    -- 🚫 Do NOT store special buffers like neo-tree
    vim.o.sessionoptions =
      "buffers,curdir,tabpages,winsize,help,globals,skiprtp,terminal"

    -- ✅ Auto-restore session (only once)
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("PersistenceAutoRestore", { clear = true }),
      nested = true,
      callback = function()
        -- Only restore if NO files were passed
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end,
    })
  end,

  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>qS",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "Disable Session Saving",
    },
  },
}

