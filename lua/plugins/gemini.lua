-- lua/plugins/gemini.lua
return {
  "kiddos/gemini.nvim",
  enabled=false,
  opts = {
    model_config = {
      model_id = "gemini-2.5-flash",
      temperature = 0.1,
      top_k = 128,
    },
    completion = {
      enabled = true,
      completion_delay = 1,
      insert_result_key = "<Tab>", -- accept Gemini completion with double Tab
    },
    chat_config = {
      enabled = true,
    },
  },
}

