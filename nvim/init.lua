vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- hide mouse when typing
vim.g.neovide_hide_mouse_when_typing = true

-- Railgun cursor neovide
vim.g.neovide_cursor_vfx_mode = "railgun"

-- Railgun amount of particles
vim.g.neovide_cursor_vfx_particle_density = 15.0

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false, -- is already lazy
    },
     
    {
        "Canop/nvim-bacon",
        config = function()
            require("bacon").setup({
                quickfix = {
                    enabled = true, -- Enable Quickfix integration
                    event_trigger = true, -- Trigger QuickFixCmdPost after populating Quickfix list
                },
            })
        end,
    },

    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

  { import = "plugins" },
}, lazy_config)

--clipboard functionality
vim.api.nvim_set_option("clipboard", "unnamed")
-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- Load custom nvim-cmp config
require("configs.cmp")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
