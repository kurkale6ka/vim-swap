Swapping of text in Vim
=======================

A plugin which makes swapping of text in Vim easier

1. Visual mode
--------------

1.1 `\x`

First select some text (`[]` represents the highlighted area). Then press `\x`

    [a ==   123] [  a == 123 ] [a==123]
          |            |           |
          V            V           V
    123 ==   a     123 == a    123==a

_Note:_ Your selection can be loose and include white spaces at both ends.

1.2 `\\x`

By default the plugin acts on comparison operators  
You are however allowed to specify any pivot for the swapping.

First select some text. Then press `\\x`  
You will be asked to give a pattern (`%` used here)

    Just testing  %  a percentage as a pivot
                      |
                      V
    a percentage as a pivot  %  Just testing

1.3 Multiple lines

You can also use `V`, `v` or `^v` to select several lines (`v` used), then press `\x`

    a == [123
    user !~ unknown
    0]!=#1
       |
       V
    123 == a
    unknown !~ user
    1!=#0

---
2. Normal mode
--------------

Swap with WORD on the right `\x`

`#` indicates the cursor position in the examples below.

          #
    zero one      a_longer_word three
             |
             V
    zero a_longer_word      one three

Swap with WORD on the left  `\X`

    zero one two     three
    let's have some more fun
      #      |
             V
    zero one two     let's
    three have some more fun

2.1 Repeat

This plugin integrates with Tim Pope's repeat plugin. It means that you can  
use **. (dot)** to repeat any normal mode (for now) swap mapping you just used!

For more information see: http://github.com/tpope/vim-repeat

---
3. Supported operators
----------------------

Comparison operators
    ===    !==     <>    ==#    !=#     >#
    >=#     <#    <=#    =~#    !~#    ==?
    !=?     >?    >=?     <?    <=?    =~?
    !~?     ==     !=     >=     =~     <=
    !~      ~=

Logical operators
    &&     ||

Assignment operators
    +=     -=     *=     /=     %=     &=
    |=     ^=    <<=    >>=

Scope operators
    ::

Pointer operators
    ->*     ->     .*

Bitwise operators
    <<     >>

Misc operators
    >      <       =      +      -      *
    /      %       &      |      ^      .
    ?      :       ,     '=     '<     '>
    !<     !>

3.1 Custom operators

You can define your own operators by putting a similar line in your _vimrc_:

    let g:swap_custom_ops = ['first_operator', 'second_operator', ...]

---
4. Custom mappings
------------------

You have the possibility to define your own custom mappings in your _vimrc_:

    vmap <leader>x         <plug>SwapSwapOperands
    vmap <leader><leader>x <plug>SwapSwapPivotOperands
    nmap <leader>x         <plug>SwapSwapWithR_WORD
    nmap <leader>X         <plug>SwapSwapWithL_WORD

_Note:_ You can replace \x, \\x, \X with whatever you like.
