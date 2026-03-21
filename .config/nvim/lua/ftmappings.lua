local ft_group = vim.api.nvim_create_augroup("FileTypeMappings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = { "tex", "markdown" },
  callback = function()
    vim.keymap.set("n", "j", "gj", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("n", "0", "g0", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("n", "$", "g$", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("n", "^", "g^", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("v", "j", "gj", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("v", "k", "gk", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("v", "0", "g0", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("v", "$", "g$", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("v", "^", "g^", { buffer = true, noremap = true, silent = true })
  end,
})
