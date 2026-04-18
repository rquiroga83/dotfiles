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

  -- Íconos (necesario para nvim-tree y tabline)
  { "nvim-tree/nvim-web-devicons", lazy = false },

  -- Persistencia de sesión (restaurar estado al reabrir)
  {
    "folke/persistence.nvim",
    lazy = false,
    priority = 100,
    config = function()
      require("persistence").setup({
        dir = vim.fn.stdpath("data") .. "/persistence/",
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
        save_empty = false,
        -- Ignorar directorios donde no queremos restaurar sesión
        pre_save = nil,
        -- Guardar sesión automáticamente al salir
        autosave = true,
      })
    end,
  },

  -- Git: sign column + hunk operations
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        signs_staged = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        signcolumn = true,
        numhl      = false,
        linehl     = false,
        word_diff  = false,
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 300,
        },
        current_line_blame_formatter = " <author>, <author_time:%R> • <summary>",
        preview_config = {
          border = "single",
          style = "minimal",
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navegación entre hunks
          vim.keymap.set("n", "]h", function()
            if vim.wo.diff then return "]h" end
            vim.schedule(function() gs.nav_hunk("next") end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Next hunk" })

          vim.keymap.set("n", "[h", function()
            if vim.wo.diff then return "[h" end
            vim.schedule(function() gs.nav_hunk("prev") end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Prev hunk" })

          -- Atajos para hunks (leader + g)
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk,        { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk,        { buffer = bufnr, desc = "Reset hunk" })
          vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk,   { buffer = bufnr, desc = "Undo stage hunk" })
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk,      { buffer = bufnr, desc = "Preview hunk" })
          vim.keymap.set("n", "<leader>hb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle blame" })
          vim.keymap.set("n", "<leader>hd", gs.diffthis,           { buffer = bufnr, desc = "Diff this" })
        end,
      })

      -- Colores Git (Cyberpunk Red)
      vim.api.nvim_set_hl(0, "GitSignsAdd",          { fg = "#00cfff", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsChange",       { fg = "#fcee0a", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsDelete",       { fg = "#ff003c", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsTopdelete",    { fg = "#ff003c", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#ff6e00", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsUntracked",    { fg = "#553333", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsStagedAdd",          { fg = "#00a0cc", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsStagedChange",       { fg = "#d4c700", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsStagedDelete",       { fg = "#cc0030", bg = "none" })
      vim.api.nvim_set_hl(0, "GitSignsAddPreview",         { fg = "#00cfff", bg = "#0a1a1a" })
      vim.api.nvim_set_hl(0, "GitSignsDeletePreview",      { fg = "#ff003c", bg = "#1a0000" })
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame",   { fg = "#553333", bg = "none", italic = true })
    end,
  },

  -- Git: operaciones completas (status, commit, push, diff, blame, log)
  { "tpope/vim-fugitive" },

  -- Explorador de archivos
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Deshabilitar netrw (el explorador default de vim)
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1

      -- Reemplazar Ctrl+e en el árbol para volver al editor
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        -- Heredar todos los keymaps por defecto
        api.config.mappings.default_on_attach(bufnr)
        -- Sobreescribir Ctrl+e: volver al editor en vez de abrir archivo
        vim.keymap.set("n", "<C-e>", function()
          vim.cmd("wincmd p")
        end, { buffer = bufnr, nowait = true, silent = true, desc = "Back to editor" })
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
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

-- ─── Custom Tabline (tabs alineadas a la derecha — Cyberpunk Red) ──────────

-- Colores del tabline
vim.api.nvim_set_hl(0, "TabLineFill",       { fg = "#884444", bg = "#0a0000" })
vim.api.nvim_set_hl(0, "TabLine",           { fg = "#884444", bg = "#0a0000" })
vim.api.nvim_set_hl(0, "TabLineSel",        { fg = "#ff003c", bg = "#1a0000", bold = true })
vim.api.nvim_set_hl(0, "TabLineMod",        { fg = "#fcee0a", bg = "#0a0000" })
vim.api.nvim_set_hl(0, "TabLineModSel",     { fg = "#fcee0a", bg = "#1a0000", bold = true })
vim.api.nvim_set_hl(0, "TabLineNum",        { fg = "#661111", bg = "#0a0000" })
vim.api.nvim_set_hl(0, "TabLineNumSel",     { fg = "#ff003c", bg = "#1a0000", bold = true })
vim.api.nvim_set_hl(0, "TabLineSep",        { fg = "#2b0000", bg = "#0a0000" })

-- Función que construye el tabline
function _G.cyberpunk_tabline()
  local tabs = vim.api.nvim_list_tabpages()
  local curtab = vim.api.nvim_get_current_tabpage()
  local tab_items = {}

  for _, tabid in ipairs(tabs) do
    local winid = vim.api.nvim_tabpage_get_win(tabid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local name = vim.api.nvim_buf_get_name(bufid)
    local modified = vim.api.nvim_buf_get_option(bufid, "modified")

    if name == "" then
      name = "[Sin nombre]"
    else
      name = vim.fn.fnamemodify(name, ":t")
    end

    -- Ícono del archivo
    local icon, icon_hl = "", ""
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
      icon, icon_hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true })
      if not icon then icon = "" end
    end

    local num = vim.api.nvim_tabpage_get_number(tabid)
    local is_sel = (tabid == curtab)

    -- Formato: "  1  init.lua ● "
    local label = string.format(" %d %s%s%s ", num, icon ~= "" and icon .. " " or "", name, modified and " ●" or " ✕")

    -- Elegir highlight según estado
    local hl
    if is_sel then
      hl = modified and "%#TabLineModSel#" or "%#TabLineSel#"
    else
      hl = modified and "%#TabLineMod#" or "%#TabLine#"
    end

    table.insert(tab_items, hl .. label)
  end

  local tab_string = table.concat(tab_items, "%#TabLineSep#│")

  -- Padding a la izquierda para empujar tabs a la derecha
  local fill = "%#TabLineFill#"

  return fill .. "%=" .. tab_string .. "%#TabLineFill#"
end

vim.o.tabline = "%!v:lua.cyberpunk_tabline()"
vim.o.showtabline = 2  -- siempre visible

-- Atajos para navegar tabs
vim.keymap.set("n", "<Tab>",   "<cmd>tabnext<CR>",  { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Prev tab" })
vim.keymap.set("n", "<C-1>",   "1gt", { desc = "Tab 1" })
vim.keymap.set("n", "<C-2>",   "2gt", { desc = "Tab 2" })
vim.keymap.set("n", "<C-3>",   "3gt", { desc = "Tab 3" })
vim.keymap.set("n", "<C-4>",   "4gt", { desc = "Tab 4" })
vim.keymap.set("n", "<C-5>",   "5gt", { desc = "Tab 5" })
vim.keymap.set("n", "<C-6>",   "6gt", { desc = "Tab 6" })
vim.keymap.set("n", "<C-7>",   "7gt", { desc = "Tab 7" })
vim.keymap.set("n", "<C-8>",   "8gt", { desc = "Tab 8" })
vim.keymap.set("n", "<C-9>",   "9gt", { desc = "Tab 9" })

-- Atajo: Ctrl+b abre/cierra el panel
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
-- Atajo: Ctrl+e alterna el foco entre árbol y editor (mapeo global único)
vim.keymap.set("n", "<C-e>", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p")
  else
    vim.cmd("NvimTreeFocus")
  end
end, { desc = "Toggle focus tree/editor", nowait = true, silent = true })

-- Abrir nvim-tree solo si NO se está restaurando una sesión
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    -- Verificar si persistence.nvim restauró una sesión
    local has_session = false
    local ok, persistence = pcall(require, "persistence")
    if ok then
      has_session = persistence.load()
    end
    -- Si no había sesión previa, abrir el árbol de archivos
    if not has_session then
      vim.defer_fn(function()
        require("nvim-tree.api").tree.open()
      end, 50)
    end
  end,
})

-- ─── Opciones generales ────────────────────────────────────────────────────
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.cursorline     = true
vim.opt.hidden         = true    -- mantiene buffers con cambios no guardados en background
vim.opt.undofile       = true    -- persiste historial de undo entre sesiones
vim.opt.swapfile       = true    -- archivo swap para recuperación ante crashes
vim.opt.backup         = false   -- sin archivos de backup (undo file es suficiente)

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
  -- Re-aplicar colores del tabline
  vim.api.nvim_set_hl(0, "TabLineFill",       { fg = "#884444", bg = "#0a0000" })
  vim.api.nvim_set_hl(0, "TabLine",           { fg = "#884444", bg = "#0a0000" })
  vim.api.nvim_set_hl(0, "TabLineSel",        { fg = "#ff003c", bg = "#1a0000", bold = true })
  vim.api.nvim_set_hl(0, "TabLineMod",        { fg = "#fcee0a", bg = "#0a0000" })
  vim.api.nvim_set_hl(0, "TabLineModSel",     { fg = "#fcee0a", bg = "#1a0000", bold = true })
  vim.api.nvim_set_hl(0, "TabLineNum",        { fg = "#661111", bg = "#0a0000" })
  vim.api.nvim_set_hl(0, "TabLineNumSel",     { fg = "#ff003c", bg = "#1a0000", bold = true })
  vim.api.nvim_set_hl(0, "TabLineSep",        { fg = "#2b0000", bg = "#0a0000" })
end

set_colors()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_colors })
