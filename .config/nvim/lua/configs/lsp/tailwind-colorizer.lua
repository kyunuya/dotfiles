return {
  "roobert/tailwindcss-colorizer-cmp.nvim",
  ft = { "svelte", "typescript", "tsx" },
  config = function()
    require("tailwindcss-colorizer-cmp").setup {
      color_square_width = 2,
    }
  end,
}

-- return {
--   {
--     "luckasRanarison/tailwind-tools.nvim",
--     name = "tailwind-tools",
--     build = ":UpdateRemotePlugins",
--     dependencies = {
--       "nvim-treesitter/nvim-treesitter",
--       "nvim-telescope/telescope.nvim", -- optional
--       "neovim/nvim-lspconfig", -- optional
--     },
--     ft = { "svelte", "typescript", "tsx" },
--     opts = {}, -- your configuration
--   },
-- }
