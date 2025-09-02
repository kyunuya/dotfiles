return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  opts = function()
    dofile(vim.g.base46_cache .. "mason")

    return {
      PATH = "skip",
      ui = {
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },

        border = "rounded",
      },

      max_concurrent_installers = 10,
    }
  end,
}
