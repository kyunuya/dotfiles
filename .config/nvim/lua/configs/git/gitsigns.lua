return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  opts = function()
    dofile(vim.g.base46_cache .. "git")

    return {
      signs = {
        delete = { text = "󰍵" },
        changedelete = { text = "󱕖" },
      },
    }
  end,
}
