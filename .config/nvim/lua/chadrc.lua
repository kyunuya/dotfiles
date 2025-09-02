-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,
  hl_override = {
    Comment = {
      fg = "#6c7086",
      italic = true,
    },

    ["@comment"] = {
      fg = "#6c7086",
      italic = true,
    },

    Visual = {
      bg = "#45475a",
      fg = "NONE",
    },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "block",
  },
  colorizer = {
    enable = false,
  },
}

return M
