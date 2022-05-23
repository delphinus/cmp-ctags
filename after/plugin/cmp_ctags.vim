if exists('g:loaded_cmp_ctags')
  finish
endif
let g:loaded_cmp_ctags = v:true

lua require'cmp'.register_source('ctags', require'cmp_ctags')
