return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = "Telescope",
  opts = function()
    dofile(vim.g.base46_cache .. "telescope")
    local actions = require "telescope.actions"

    return {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          n = { ["q"] = actions.close },
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-[>"] = actions.move_to_top,
            ["<C-]>"] = actions.move_to_bottom,
            ["<C-j>"] = actions.preview_scrolling_up,
            ["<C-k>"] = actions.preview_scrolling_down,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
            ["<C-u>"] = false,
          },
        },
      },

      extensions_list = { "themes", "terms" },
      extensions = {},
    }
  end,
}
