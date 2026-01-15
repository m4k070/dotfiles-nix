return {
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    enabled = not vim.g.vscode,
    version = '*',
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return vim.o.lines * 0.4
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-`>]],
        direction = "float",
      })
    end,
  },
}
