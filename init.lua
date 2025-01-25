vim.filetype.add({
  extension = {
    todo = "todo",
  },
})

local todo = vim.fn.expand("~/.todo/bin/todo.vim")
local todo_syntax = vim.fn.expand("~/.todo/bin/syntax.vim")

vim.cmd("source " .. todo)
vim.cmd("syntax on")
vim.cmd("syntax enable")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "todo",
  callback = function()
    vim.cmd("source " .. todo_syntax)
  end,
})
