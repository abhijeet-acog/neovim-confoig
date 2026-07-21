
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      http = {
        -- Gemini adapter (default)
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = { gemini_api_key = os.getenv("GEMINI_API_KEY") },
            schema = { model = { default = "gemini-2.5-flash" } },
          })
        end,

        -- Azure OpenAI adapter (fallback)
        azure = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              openai_api_type = "azure",
              openai_api_version = "2024-05-01-preview",
              openai_api_base = os.getenv("AZURE_OPENAI_ENDPOINT"),
              openai_api_key = os.getenv("AZURE_OPENAI_KEY"),
            },
            schema = { model = { default = os.getenv("AZURE_OPENAI_DEPLOYMENT") or "gpt-5" } },
          })
        end,

        opts = {
          log_level = "DEBUG", -- or TRACE
        },
      },
    },

    strategies = {
      inline = { adapter = "gemini" }, -- Gemini by default
      chat   = { adapter = "gemini" },
    },
  },

  keys = {
    -- Inline AI edits
    { "<leader>ci", "<cmd>CodeCompanionInline<cr>", mode = { "n", "v" }, desc = "Inline AI Edit" },

    -- Chat buffer in right-hand split (70/30)
    {
      "<leader>cc",
      function()
        local width = math.floor(vim.o.columns * 0.3)
        vim.cmd("vsplit")
        vim.cmd("vertical resize " .. width)
        vim.cmd("CodeCompanionChat")
      end,
      desc = "AI Chat (right split)",
    },
  },
}

