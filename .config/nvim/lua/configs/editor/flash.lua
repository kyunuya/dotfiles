return {
  "folke/flash.nvim",
  event = "VeryLazy",

  ---@type Flash.Config
  opts = {
    search = { forward = true, wrap = false, multi_window = true },
    modes = {
      char = {
        config = function(opts)
          -- autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or (vim.fn.mode(true):find "no")
          opts.multi_line = opts.multi_line and not vim.fn.mode(true):find "o"

          opts.jump_labels = opts.jump_labels
            and not vim.fn.mode(true):find "o"
            and vim.v.count == 0
            and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""
        end,
        -- hide after jump when not using jump labels
        autohide = false,
        jump_labels = true,
        multi_line = true,
      },
    },
    labels = "asfghjklqwertuiopzxcbnm",
  },


    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
}
