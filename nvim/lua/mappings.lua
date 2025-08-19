require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Disable 'h' in normal mode
map('n', 'h', '<NOP>', { desc = 'Do nothing (disable h in normal mode)' })

-- Disable 'h' in visual mode
map('v', 'h', '<NOP>', { desc = 'Do nothing (disable h in visual mode)' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
