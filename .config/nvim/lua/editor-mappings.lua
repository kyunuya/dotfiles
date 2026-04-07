local M = {}
function M.set_editor_mappings()
  local opts = { buffer = true, noremap = true, silent = true }
  vim.keymap.set("n", "j", "gj", opts)
  vim.keymap.set("n", "k", "gk", opts)
  vim.keymap.set("n", "0", "g0", opts)
  vim.keymap.set("n", "$", "g$", opts)
  vim.keymap.set("n", "^", "g^", opts)
  vim.keymap.set("v", "j", "gj", opts)
  vim.keymap.set("v", "k", "gk", opts)
  vim.keymap.set("v", "0", "g0", opts)
  vim.keymap.set("v", "$", "g$", opts)
  vim.keymap.set("v", "^", "g^", opts)
end
return M
