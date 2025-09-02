return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = false,
    opts = {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    },
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
}
