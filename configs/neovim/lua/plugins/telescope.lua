-- telescope
return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
    end
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      local builtin = require"telescope".load_extension("frecency")
      vim.keymap.set('n', '<leader>fq', builtin.frecency, {})
    end,
    dependencies = {"kkharji/sqlite.lua"}
  },
}
