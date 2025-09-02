return {
  "lervag/vimtex",
  ft = { "tex" },
  init = function()
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_view_zathura_options = "-reuse-instance"
  end,
}
