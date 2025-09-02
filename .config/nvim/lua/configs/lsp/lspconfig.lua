return {
  "neovim/nvim-lspconfig",
  ft = { "cpp", "rust", "python", "lua", "typescript", "javascript", "java" },
  event = "User FilePost",

  config = function()
    local lspconfig = require "lspconfig"

    -- EXAMPLE
    local servers = { "html", "clangd", "cssls", "lua_ls", "pylsp", "jdtls" }
    -- local nvlsp = require "nvchad.configs.lspconfig"

    local M = {}
    local map = vim.keymap.set

    -- export on_attach & capabilities
    M.on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
      map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
      map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
      map("n", "grn", vim.lsp.buf.rename, opts "Rename variable")
      map("n", "gra", vim.lsp.buf.code_action, opts "Show code actions")
      map("n", "grr", vim.lsp.buf.references, opts "Show references")

      map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts "List workspace folders")

      map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
      map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
    end

    -- disable semanticTokens
    M.on_init = function(client, _)
      if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    M.capabilities = vim.lsp.protocol.make_client_capabilities()

    M.capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    M.defaults = function()
      dofile(vim.g.base46_cache .. "lsp")
      require("nvchad.lsp").diagnostic_config()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          M.on_attach(_, args.buf)
        end,
      })

      local lua_lsp_settings = {
        Lua = {
          workspace = {
            library = {
              vim.fn.expand "$VIMRUNTIME/lua",
              vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
              vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
              "${3rd}/luv/library",
            },
          },
        },
      }

      -- Support 0.10 temporarily

      if vim.lsp.config then
        vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
        vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
        vim.lsp.enable "lua_ls"
      else
        require("lspconfig").lua_ls.setup {
          capabilities = M.capabilities,
          on_init = M.on_init,
          settings = lua_lsp_settings,
        }
      end
    end

    -- lsps with default config
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = M.on_attach,
        on_init = M.on_init,
        capabilities = M.capabilities,
      }
    end

    -- Add border to the diagnostic popup window
    vim.diagnostic.config {
      virtual_text = {
        prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
      },
      float = { border = "rounded" },
    }

    -- configuring single server, example: typescript
    -- lspconfig.tsserver.setup {
    --   on_attach = nvlsp.on_attach,
    --   on_init = nvlsp.on_init,
    --   capabilities = nvlsp.capabilities,
    -- }
    local win = require "lspconfig.ui.windows"
    win.default_options = { border = "rounded" }
    vim.diagnostic.config { float = { border = "rounded" } }
  end,
}
