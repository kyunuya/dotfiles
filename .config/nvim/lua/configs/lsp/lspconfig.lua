return {
  "neovim/nvim-lspconfig",
  lazy = false,
  -- ft = { "svelte", "cpp", "rust", "python", "lua", "typescript", "javascript", "java" },
  -- event = "User FilePost",

  config = function()
    local servers = { "html", "clangd", "cssls", "lua_ls", "pylsp", "jdtls", "svelte", "texlab" }

    for _, lsp in ipairs(servers) do
      vim.lsp.enable(lsp)
    end

    vim.diagnostic.config {
      virtual_text = {
        prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
      },
      float = { border = "rounded" },
    }

    local win = require "lspconfig.ui.windows"
    win.default_options = { border = "rounded" }
    vim.diagnostic.config { float = { border = "rounded" } }
  end,
}
