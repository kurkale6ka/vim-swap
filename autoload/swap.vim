function! swap#text(mode) range

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
