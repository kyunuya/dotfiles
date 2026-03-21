return {
  "stevearc/conform.nvim",
  event = "BufRead",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
      clangd = { "clang-format" },
      javascript = { "prettier", stop_after_first = true },
      typescript = { "eslint" },
      pylsp = { "prettier" },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
