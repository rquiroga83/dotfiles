-- ─── Plugin manager: lazy.nvim ────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Íconos (necesario para nvim-tree)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Explorador de archivos
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Deshabilitar netrw (el explorador default de vim)
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = {
          width = 32,
          side  = "left",
        },
        renderer = {
          group_empty    = true,   -- agrupa dirs vacíos
          highlight_git  = true,
          icons = {
            show = {
              file        = true,
              folder      = true,
              folder_arrow = true,
              git         = true,
            },
          },
        },
        filters = {
          dotfiles = false,        -- muestra ocultos
        },
        git = {
          enable  = true,
          ignore  = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,  -- mantiene el panel abierto al abrir archivo
          },
        },
      })

      -- Colores del panel (Cyberpunk Red)
      vim.api.nvim_set_hl(0, "NvimTreeNormal",       { bg = "#0a0000" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderName",   { fg = "#ff003c", bold = true })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#ff003c", bold = true })
      vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName",  { fg = "#553333" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderIcon",   { fg = "#ff003c" })
      vim.api.nvim_set_hl(0, "NvimTreeFileIcon",     { fg = "#00cfff" })
      vim.api.nvim_set_hl(0, "NvimTreeFileName",     { fg = "#ffcccc" })
      vim.api.nvim_set_hl(0, "NvimTreeCursorLine",   { bg = "#1a0000" })
      vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#2b0000" })
      vim.api.nvim_set_hl(0, "NvimTreeGitDirty",     { fg = "#fcee0a" })
      vim.api.nvim_set_hl(0, "NvimTreeGitNew",       { fg = "#00cfff" })
      vim.api.nvim_set_hl(0, "NvimTreeGitDeleted",   { fg = "#ff003c" })
    end,
  },

})

-- Atajo: Ctrl+b abre/cierra el panel
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
-- Atajo: Ctrl+Shift+e enfoca el panel
vim.keymap.set("n", "<C-S-e>", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- Abrir automáticamente al iniciar nvim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

-- ─── Opciones generales ────────────────────────────────────────────────────
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.cursorline     = true

-- ─── Colores — se re-aplican tras cualquier colorscheme ───────────────────
local function set_colors()
  vim.api.nvim_set_hl(0, "Normal",       { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC",     { bg = "none" })
  vim.api.nvim_set_hl(0, "LineNr",       { fg = "#661111", bg = "none" })
  vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = "#661111", bg = "none" })
  vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = "#661111", bg = "none" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff003c", bg = "none", bold = true })
  vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#1a0000" })
end

set_colors()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_colors })
