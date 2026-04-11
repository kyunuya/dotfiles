return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  -- ft = { "svelte", "python", "lua", "typescript", "tsx", "html" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = function()
    pcall(function()
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
    end)

    return {
      ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc", "svelte", "html", "tsx", "python", "typescript" },
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<Tab>",
          scope_incremental = false,
          node_decremental = "<S-Tab>",
        },
      },
    }
  end,
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath "data" .. "/site",
    }
    require("nvim-treesitter").install { "typescript", "python", "svelte", "rust", "lua", "javascript", "zig" }
  end,
}
