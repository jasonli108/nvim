return {
  {
    "jasonli108/gemini.nvim",
    opts = {
      -- IMPORTANT: Set the GEMINI_API_key environment variable to your actual Gemini API key
    },
    config = function(_, opts)
      require("gemini").setup(opts)
      vim.api.nvim_create_user_command("Gemini", function(cmd_opts)
        require("gemini").ask(cmd_opts.args)
      end, {
        nargs = "*",
        desc = "Ask a question to Gemini",
      })

      vim.api.nvim_create_user_command("GeminiListModels", function()
        require("gemini").list_models()
      end, {
        desc = "List available Gemini models",
      })
    end,
  },
}

