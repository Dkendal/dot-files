(local mod {})

;; Neovim helpers

(fn mod.map [mode lhs rhs ?opts]
  (vim.api.nvim_set_keymap mode lhs rhs (or ?opts {})))

(fn mod.bmap [mode lhs rhs ?opts]
  (vim.api.nvim_buf_set_keymap 0 mode lhs rhs (or ?opts {})))

mod
