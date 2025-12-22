return {
  "goolord/alpha-nvim",
  cond = function()
    return vim.fn.argc() == 0
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>enew<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>FzfLua find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>FzfLua live_grep<CR>"),

      -- ✅ FIXED persistence button
      dashboard.button(
        "SPC wr",
        "󰁯  > Restore Session (cwd)",
        "<cmd>lua require('persistence').load()<CR>"
      ),

      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)

    -- Disable folding in alpha
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
        vim.bo.bufhidden = "wipe"  -- 🔑 THIS IS THE FIX
      end,
    })
  end,
}

