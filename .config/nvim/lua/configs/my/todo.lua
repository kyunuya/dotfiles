return {
  "kyunuya/todo.nvim",
  cmd = "Td",
  config = function()
    require("todo").setup {
      target_file = "~/todo/todo.md",
    }
  end,
}
