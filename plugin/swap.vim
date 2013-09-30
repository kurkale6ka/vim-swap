" Easy swapping of text
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" https://github.com/kurkale6ka/vim-swap
"
" Todo: rightleft
" Todo: repeat.vim for visual mode
" Todo: re-position the cursor using cursor()
"       Position of cursor in the visual area?

if exists('g:loaded_swap') || &compatible || v:version < 700

   if &compatible && &verbose
      echo "Swap is not designed to work in compatible mode."
   elseif v:version < 700
      echo "Swap needs Vim 7.0 or above to work correctly."
   endif

   finish
endif

let g:loaded_swap = 1

let s:savecpo = &cpoptions
set cpoptions&vim

xmap <silent> <plug>SwapSwapOperands      :     call swap#text('v' )<cr>
xmap <silent> <plug>SwapSwapPivotOperands :     call swap#text('vi')<cr>
nmap <silent> <plug>SwapSwapWithR_WORD    :<c-u>call swap#text('nr')<cr>
nmap <silent> <plug>SwapSwapWithL_WORD    :<c-u>call swap#text('nl')<cr>

xmap <leader>x  <plug>SwapSwapOperands
xmap <leader>cx <plug>SwapSwapPivotOperands
nmap <leader>x  <plug>SwapSwapWithR_WORD
nmap <leader>X  <plug>SwapSwapWithL_WORD

let &cpoptions = s:savecpo
unlet s:savecpo
