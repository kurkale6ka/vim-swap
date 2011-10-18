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

function! s:Swap(mode) range

   let last_search = histget('search', -1)

   if a:mode =~ 'v'

      let save_cursor = getpos("'>")

      " visual interactive :)
      if 'vi' == a:mode

         let operators = input('Pivot: ')
      else
         let comparison_ops = ['===', '!==',  '<>', '==#', '!=#',  '>#',
                              \'>=#',  '<#', '<=#', '=~#', '!~#', '==?',
                              \'!=?',  '>?', '>=?',  '<?', '<=?', '=~?',
                              \'!~?',  '==',  '!=',  '>=',  '<=',  '=~',
                              \ '~=',  '!~']
         let logical_ops    = [ '&&',  '||']
         let assignment_ops = [ '+=',  '-=',  '*=',  '/=',  '%=',  '&=',
                              \ '|=',  '^=', '<<=', '>>=']
         let scope_ops      = [ '::']
         let pointer_ops    = ['->*',  '->',  '.*']
         let bitwise_ops    = [ '<<',  '>>']
         let misc_ops       = [  '>',   '<',   '=',   '+',   '-',   '*',
                              \  '/',   '%',   '&',   '|',   '^',   '.',
                              \  '?',   ':',   ',',  "'=",  "'<",  "'>",
                              \ '!<',  '!>']

         let operators_list = comparison_ops

         " If a count is used, swap on comparison operators only
         if v:count < 1

            let operators_list += assignment_ops +
                                \ logical_ops    +
                                \ scope_ops      +
                                \ pointer_ops    +
                                \ bitwise_ops

            if exists('g:swap_custom_ops')

               " let g:swap_custom_ops = ['ope1', 'ope2', ...]
               let operators_list += g:swap_custom_ops
            endif

            let operators_list += misc_ops
         endif

         let operators = join(operators_list, '\|')
         let operators = escape(operators, '*/~.^$')
      endif

      " Whole lines
      if 'V' ==# visualmode() ||
         \ 'v' ==# visualmode() && line("'<") != line("'>")

         execute 'silent ' . a:firstline . ',' . a:lastline .
            \'substitute/'           .
            \  '^[[:space:]]*\zs'    .
            \'\([^[:space:]].\{-}\)' .
            \ '\([[:space:]]*\%('    . operators . '\)[[:space:]]*\)' .
            \'\([^[:space:]].\{-}\)' .
            \'\ze[[:space:]]*$/\3\2\1/e'
      else
         if col("'<") < col("'>")

            let col_start = col("'<")

            if col("'>") >= col('$')

               let col_end = col('$')
            else
               let col_end = col("'>") + 1
            endif
         else
            let col_start = col("'>")

            if col("'<") >= col('$')

               let col_end = col('$')
            else
               let col_end = col("'<") + 1
            endif
         endif

         execute 'silent ' . a:firstline . ',' . a:lastline .
            \'substitute/\%'         . col_start . 'c[[:space:]]*\zs' .
            \'\([^[:space:]].\{-}\)' .
            \ '\([[:space:]]*\%('    . operators . '\)[[:space:]]*\)' .
            \'\([^[:space:]].\{-}\)' .
            \'\ze[[:space:]]*\%'     . col_end   . 'c/\3\2\1/e'
      endif

   " Swap Words
   elseif a:mode =~ 'n'

      let save_cursor = getpos(".")

      " swap with Word on the left
      if 'nl' == a:mode

         call search('[^[:space:]]\+'  .
            \'\_[[:space:]]\+'  .
            \ '[^[:space:]]*\%#', 'bW')
      endif

      " swap with Word on the right
      execute 'silent substitute/'              .
         \ '\([^[:space:]]*\%#[^[:space:]]*\)' .
         \'\(\_[[:space:]]\+\)'                .
         \ '\([^[:space:]]\+\)/\3\2\1/e'
   endif

   " Repeat
   let virtualedit_bak = &virtualedit
   set virtualedit=

   if 'nr' == a:mode

      silent! call repeat#set("\<plug>SwapSwapWithR_WORD")

   elseif 'nl' == a:mode

      silent! call repeat#set("\<plug>SwapSwapWithL_WORD")
   endif

   " Restore saved values
   let &virtualedit = virtualedit_bak

   if histget('search', -1) != last_search

      call histdel('search', -1)
   endif

   call setpos('.', save_cursor)

endfunction

xmap <silent> <plug>SwapSwapOperands      :     call <sid>Swap('v' )<cr>
xmap <silent> <plug>SwapSwapPivotOperands :     call <sid>Swap('vi')<cr>
nmap <silent> <plug>SwapSwapWithR_WORD    :<c-u>call <sid>Swap('nr')<cr>
nmap <silent> <plug>SwapSwapWithL_WORD    :<c-u>call <sid>Swap('nl')<cr>

xmap <leader>x  <plug>SwapSwapOperands
xmap <leader>cx <plug>SwapSwapPivotOperands
nmap <leader>x  <plug>SwapSwapWithR_WORD
nmap <leader>X  <plug>SwapSwapWithL_WORD

let &cpoptions = s:savecpo
unlet s:savecpo
