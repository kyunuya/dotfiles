-- add yours here

local map = vim.keymap.set
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

map("i", "jk", "<ESC>")

map("n", "<Tab>", "")
map("n", "<S-Tab>", "")

-- dev
map("n", "<leader>sf", "<cmd>source %<cr>", { desc = "source file", silent = true })
map("n", "<leader>lr", ":.lua<cr>", { desc = "run lua", silent = true })
map("v", "<leader>lr", ":lua<cr>", { desc = "run lua", silent = true })

-- todo
map("n", "<leader>td", ":Td<cr>", { desc = "open todo list", silent = true })

-- quicknote
map("n", "<leader>qn", ":QuicknoteToggle<cr>", { desc = "open last note", silent = true })
map("n", "<leader>qs", ":QuicknoteSelector<cr>", { desc = "open note list", silent = true })
map("n", "<leader>nn", ":QuicknoteNew<cr>", { desc = "create new note", silent = true })

-- vim tmux navigator
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true })

-- tabufline
map("n", "<s-l>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<s-h>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>bd", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "close buffer" })

map("n", "<leader>bl", function()
  require("nvchad.tabufline").closeBufs_at_direction "left"
end, { desc = "close buffers on left" })

map("n", "<leader>br", function()
  require("nvchad.tabufline").closeBufs_at_direction "right"
end, { desc = "close buffers on right" })

map("n", "<leader>b[", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "move buffer to left" })

map("n", "<leader>b]", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "move buffer to right" })

-- nvim treesitter
map({ "x", "o" }, ";", ts_repeat_move.repeat_last_move)
map({ "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- nvchad.term
-- buffer
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", { silent = true })
map("n", "<leader>|", "<cmd>vs<cr>", { silent = true })
map("n", "<leader>-", "<cmd>split<cr>", { silent = true })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- copilot
map("i", "<C-e>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

-- aider
map("n", "<leader>Ao", ":AiderOpen --no-auto-commits<CR>")

-- terminal
map("t", "jk", [[<C-\><C-n>]])

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Use buffer-local terminal mode mappings
    local function tmap(lhs, rhs)
      vim.api.nvim_buf_set_keymap(0, "t", lhs, rhs, { noremap = true, silent = true })
    end

    tmap("<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<CR>]])
    tmap("<C-j>", [[<C-\><C-n><cmd>TmuxNavigateDown<CR>]])
    tmap("<C-k>", [[<C-\><C-n><cmd>TmuxNavigateUp<CR>]])
    tmap("<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<CR>]])
  end,
})

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { silent = true })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })
map({ "n", "t" }, "<c-_>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      relative = "editor",
      row = 0.075,
      col = 0.14,
      width = 0.7,
      height = 0.8,
    },
  }
end, { desc = "terminal toggle floating term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })
