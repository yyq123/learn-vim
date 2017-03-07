" File: dubs_html_entities.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2016.03.24
" Project Page: https://github.com/landonb/dubs_html_entities
" Summary: HTML Character Entity Table
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2009, 2015-2016 Landon Bouma.
" 
" This program is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License as
" published by the Free Software Foundation, either version 3 of
" the License, or (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" ------------------------------------------
" About:

" HtmlCharTable displays an interactive list of
" HTML Character Entities (a/k/a Special Characters).

" This file is a reworking of Christian Habermann's awesome
" chartab.vim, which displays an interactive list of ASCII
" character values. Check it out here:
"   http://www.vim.org/scripts/script.php?script_id=898

" I lifted the list of HTML4 Character Entities from TNT Luoma:
"   http://tntluoma.com/files/codes.htm

if exists("g:plugin_dubs_html_entities") || &cp
  finish
endif
let g:plugin_dubs_html_entities = 1

" ------------------------------------------
" Usage:

" See 'dubs_html_entities/README.rst' or try
"  :help dubs_html_entities
"
" Basic usage is <Leader>ht but there are
" a few tricks available.

" ------------------------------------------
" User Interface:

" Startup
" ------------------------
" This allows the user to avoid loading this 
" plugin by defining plugin_htmlchartable; this 
" also prevents the script from being re-loaded.
if exists("plugin_htmlchartable_vim")
  finish
endif
let plugin_htmlchartable_vim = 1

" Configuration
" ------------------------

" 2016.01.19: Try using the :digraph feature.
":set digraph

" Use <Plug> to name the functions we want to be 
" _easily_ publically accessible -- this is so 
" the user doesn't have to know anything about 
" the script's <SID>, and so we can keep 
" implementation details private. This also means 
" a bunch of thunking -- first from the public 
" Plug fcn to the our Sid fcn, then from the Sid 
" fcn to the private script fcn.
" (NOTE A <Plug> fcn. is globally named, so it 
"       must be unique (and so Vim recommends pre-
"       pending the name of the script first), 
"       while a <SID> fcn. is re-named by Vim to 
"       include the script ID (which is generated 
"       at startup, so <SID>HCT_QuickLookup 
"       might really be <SNR>16_HCT_QuickLookup())

" ---------------
" Map <Leader>ht to the Html Table
if !hasmapto('<Plug>HCT_HtmlCharTable')
  map <silent> <unique> <Leader>ht 
    \ <Plug>HCT_HtmlCharTable
endif
" Map <Plug> to an <SID> function
map <silent> <unique> <script> 
  \ <Plug>HCT_HtmlCharTable 
  \ :call <SID>HCT_HtmlCharTable()<CR>
" And finally thunk to the script fcn.
function <SID>HCT_HtmlCharTable()
  call s:HtmlCharTable()
endfunction

" ---------------
" Map <Leader>hT (with a CAP) to the Quick Lookup
if !hasmapto('<Plug>HCT_QuickLookup')
  map <silent> <unique> <Leader>hT 
    \ <Plug>HCT_QuickLookup
endif
" Map <Plug>
map <silent> <unique> <script> 
  \ <Plug>HCT_QuickLookup 
  \ :call <SID>HCT_QuickLookup()<CR>
" Thunk to local fcn.
function <SID>HCT_QuickLookup()
  call s:QuickLookup()
endfunction

" ---------------
" Let the user map their own command to the
" toggle function by making it a <Plug>
"   1. Make the <Plug>
map <silent> <unique> <script> 
  \ <Plug>HCT_ToggleLookup 
  \ :call <SID>HCT_ToggleLookup()<CR>
"   2. Thunk the <Plug>
function s:HCT_ToggleLookup()
  " See if the table buffer exists
  if exists('s:viewBufNr')
      \ && (-1 != s:viewBufNr)
    " Yup. But is the buffer being shown in a 
    " window on the current tab? If so, close 
    " the table, otherwise, show it!
    if 1 == s:HCT_IsTableVisibleInTab()
      " Close the table
      call <SID>HCT_Exit()
    else
      " Table is on a different tab, so show it
      " in the current tab, in the current window
      execute s:viewBufNr . "buffer"
    endif
  else
    " Nope! So create a new one
    call s:HtmlCharTable()
  endif
endfunction

" ---------------
" Set the default base (hex or dec or ent; 
" defaults to dec). E.g., 
"  dec: &#928; / hex: &#x3D6; / ent: &piv;
" The user can override this by defining 
" g:hct_base before sourcing this script.
if !exists('g:hct_base')
  let g:hct_base = "dec"
endif

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Convenient Key Mapping
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" MAYBE: Don't set this here. But then, where? I could make,
"        e.g., dubsacks_mappings.vim, and just store all my
"        mappings there, after making g:global attributes for
"        all the plugins wherein mappings are hard-coded. Seems
"        like a lot of work, though... so, for now, most mappings
"        are hard-coded and not overwriteable.

" Alt-Shift-5 // Toggle HTML Char Table
" --------------------------------
" This also isn't in EditPlus, but it's 
" similar to the Alt-Shift-1 Cliptext 
" window, only this window shows you 
" HTML Character Entity translations.
" (Note: It's M-%, not M-S-5)
" SYNC_ME: Dubsacks' <M-????> mappings are spread across plugins. [M-S-5]
nmap <M-%> <Plug>HCT_ToggleLookup
imap <M-%> <C-O><Plug>HCT_ToggleLookup<ESC>
"cmap <M-%> <C-C><Plug>HCT_ToggleLookup<ESC>
"omap <M-%> <C-C><Plug>HCT_ToggleLookup<ESC>

" ------------------------------------------
" Private Interface:

" Initialisation
" ------------------------

" Store the buffer number of the table buffer; 
" start with an impossible value
let s:viewBufNr = -1 

" ------------------------------------------
" HTML Entity Table

" Main Task
" ------------------------

" Creates and loads the HTML Character Entity 
" Table into a new buffer.
function s:HtmlCharTable()

  " Allow modifications (for now; necessary 
  " if called from the script's own buffer)
  setlocal modifiable

  " Open a new buffer for viewing the table
  call s:OpenViewBuffer()

  " Define local key mappings for user commands
  call s:SetLocalKeyMappings()

  " Use syntax highlighting to colorize the table
  call s:SetupSyntaxHighlighting()
  
  " Begin the new buffer with a header 
  " (this initializes s:txt)
  call s:MakeHeader()

  " Append the entity table to the buffer-to-be
  call s:MakeCharTable()
  
  " TODO Is it necessary to specify this again?
  setlocal modifiable
  
  " Finally write the entity table to the buffer
  put! = s:txt

  " Move the cursor back to the top of the buffer
  call cursor(1, 1)

  " Disallow modifications; we're done
  setlocal nomodifiable

endfunction

" Table Helper Fcns.
" ------------------------

" Creates and displays a new buffer to show the 
" entity table and to process key commands
function s:OpenViewBuffer()

  " Save the current buffer number so we can 
  " switch back to it later, when the table is 
  " dismissed
  if (s:viewBufNr != winbufnr(0))
    let s:startBufNr = winbufnr(0)
  endif

  " Also save the current cursor position, so we 
  " can restore it when we destroy this buffer
  let s:startPos = getpos(".")

  " Open a new buffer for the table
  execute "enew"

  " Save the new table buffer's buffer number
  let s:viewBufNr = winbufnr(0)

  " Set the behavior of the new buffer:
  "  - nomodifiable:     no edits to this buffer
  "  - noswapfile:       we don't need a swapfile
  "  - buftype=nowrite:  buffer will not be writ
  "  - bufhidden=delete: delete buf if being hid
  "  - nowrap:           don't wrap long lines
  "  - iabclear:         no abbrevs in insert mode
  setlocal nomodifiable
  setlocal noswapfile
  setlocal buftype=nowrite
  setlocal bufhidden=delete
  setlocal nowrap
  iabclear <buffer>

  " Register a BufDelete listener, so we know 
  " when to reset our dangling pointers; also 
  " remove the autocmd itself when this happens
  execute "autocmd BufDelete "
    \ . "    <buffer=" . s:viewBufNr . "> nested "
    \ . "  let s:viewBufNr = -1 | "
    \ . "  let s:startBufNr = -1 | "
    \ . "  autocmd! BufDelete "
    \ . "    <buffer=" . s:viewBufNr . ">"

endfunction

" Checks whether buffer exists and if it's 
" currently visible in a window in the tab
" ('cause it might exist but in a window in 
"  a different tab)
function s:HCT_IsTableVisibleInTab()

  let viewWinNr = bufwinnr(s:viewBufNr)

  let isVisible = 0
  if -1 != viewWinNr
    let isVisible = 1
  endif

  return isVisible

endfunction

" CloseViewBuffer switches to the buffer from
" which this script was invoked. This causes the 
" table buffer to be automatically deleted. If 
" the table is not in the current window, the 
" window containing the buffer is also closed.
function s:CloseViewBuffer()

  " Make sure there's really a buffer to delete
  if -1 != s:viewBufNr

    " If we can restore to a working buffer, 
    " we should also restore the cursor
    let doResetCursor = 0

    " Check if the lookup is in the current 
    " window or not
    let curBufNr = winbufnr(0)
    if s:viewBufNr != curBufNr
      " The lookup is in another window; get 
      " the first window its in (it could be in 
      " many, but we'll let the user figure 
      " that out; i.e., call this multiple times)
      let viewWinNr = bufwinnr(s:viewBufNr)
      " Close the first window we find that's 
      " displaying the table 
      " NOTE Another behavior would be to just 
      "      close the table buffer but leave 
      "      the window intact, but I think 
      "      most users will want the window 
      "      closed
      if -1 != viewWinNr
        " Goto the window first
        execute viewWinNr . "wincmd w"
        " Now close it
        execute viewWinNr . "wincmd c"
        " (It doesn't work otherwise.)
      else
        " This lookup is always visible in a 
        " window, but that window is not 
        " necessarily in the current tab.
        " However, HCT_IsTableVisibleInTab 
        " should make sure we don't try to 
        " close the table from a tab in 
        " which it's not being displayed.
        " As such, this code path *should*
        " be unreachable. throw('oops!'):
        call confirm("Error in HtmlCharTable" 
          \ . ".vim: Unexpected code path "
          \ . "(-1 == viewWinNr) / bufexists(" 
          \ . s:viewBufNr . ")="
          \ . bufexists(s:viewBufNr))
        if bufexists(s:viewBufNr)
          execute "bdelete " . s:viewBufNr
        endif
      endif
    else
      " The lookup is in the same window as the 
      " cursor, so try switching back to the 
      " buffer the user was previously using
      if s:startBufNr != s:viewBufNr
        if bufexists(s:startBufNr)
          execute "buffer! " . s:startBufNr
          let doResetCursor = 1
        else
          " Hmm, the user must've wiped it!
          execute "enew"
        endif
      else
        " When s:startBufNr == s:viewBufNr
        " it means the user was on a new 
        " (empty) buffer when they created 
        " the table. So just go back to it
        " (meaning: create a new buffer).
        execute "enew"
      endif
    endif

    " Restore the cursor
    if 1 == doResetCursor
      call cursor(s:startPos[1], s:startPos[2])
    endif

  endif

endfunction

" Set some buffer-local command mappings so the 
" user can interact with the entity table when 
" the cursor is in the buffer's window. 
" Specifically, allow the user to (1) exit the 
" table buffer, (2) cycle forwards and backwards 
" through the set of available bases (i.e., dec, 
" hex, and ent), and (3) yank the entity nearest 
" the cursor and put it in the user's last buffer
function s:SetLocalKeyMappings()

  " Use 'q' to close the table buffer and 
  " switch to the previously used buffer
  nnoremap <buffer> <silent> q 
    \ :call <SID>HCT_Exit()<CR>

  " Use 'b' to cycle forwards through set 
  " of bases
  nnoremap <buffer> <silent> b 
    \ :call <SID>HCT_ToggleBase(1)<CR>

  " Use 'B' to cycle backwards through set 
  " of bases
  nnoremap <buffer> <silent> B 
    \ :call <SID>HCT_ToggleBase(-1)<CR>

  " Use 'r' to 'rip' the current entity 
  " and paste it in the previously used 
  " buffer. (Really, 'rip' isn't any 
  " better than calling this 'yank' and 
  " using the 'y' key, but I wanted to 
  " keep this and other commands on the 
  " left-side of the keyboard). 
  nnoremap <buffer> <silent> r 
    \ :call <SID>HCT_YankExitAndPut()<CR>
 
  " Also map double-click to 'rip'
  nnoremap <buffer> <silent> <2-leftmouse> 
    \ :call <SID>HCT_YankExitAndPut()<CR>

  " Also map <CR> to 'rip'
  nnoremap <buffer> <silent> <CR> 
    \ :call <SID>HCT_YankExitAndPut()<CR>

  " Alias <ESC> to 'q'
  " ... everybody's favorite key!
  nnoremap <buffer> <silent> <ESC> 
    \ :call <SID>HCT_Exit()<CR>

endfunction

" Setup syntax-highlighting so that entities 
" and column dividers are colorfully displayed
function s:SetupSyntaxHighlighting()

  " Bail now if (this build of) Vim doesn't 
  " support syntax highlighting
  if !has('syntax')
    return
  endif
  " (Otherwise, even if "syntax off" in the 
  "  current buffer, we'll still be colorful.)

  " Comments begin at the start of a line 
  " with the quote symbol
  syntax match hctComment  "^\".*"

  " Each cell of the table contains either 
  " the start of a line followed by an entity,
  " or the start of a cell (i.e., the pipe '|')
  " followed by an entity.
  syn match hctSeparatorAndEntity
        \ "\(^\||\)[ ]\+&#\?x\?[0-9A-Za-z]\+;" 
        \   contains=hctCode,hctSeparator
  " Sometimes, an entity may not be printed 
  " (if the user changes to base "ent" and the 
  "  entity only has a numeric representation);
  "  -- this matches when the last column does 
  "     not have an entity reference and the 
  "     symbol is a space (or whitespace)
  syn match hctSeparatorAndEntity2 
        \ "| [ ]\+$" 
        \   contains=hctCode,hctSeparator
  "  -- and this matches when the column does 
  "     not have an entity reference but is 
  "     displaying a symbol
  syn match hctSeparatorAndEntity3 
        \ "\(^\||\) [ ]\+[^\s]\+$" 
        \   contains=hctCode,hctSeparator
    
  " This matches an entity of the form 
  " &this;, &#that; or &#xother;
  syn match hctCode "&#\?x\?[0-9A-Za-z]\+;" 
        \ contained

  " This matches the column separator symbol 
  " (and not the pipe sign when it's an 
  "  entity symbol)
  syn match hctSeparator "|[^$]" contained

  " Wire the highlighting rules to the 
  " highlighting engine
  if !exists('g:hct_syntaxHighInit')
    let g:hct_syntaxHighInit = 0
    hi def link hctComment     Comment
    hi def link hctCode        String
    hi def link hctSeparator   Comment
  endif

endfunction

" Table Builder Fcns.
" ------------------------

" Use prefix to experiment with indentation;
" but really, none is best
let s:prefix = ""

" Starts the table buffer with a header and 
" a short list of available user commands
function s:MakeHeader()
  let s:txt =         "\"" . s:prefix .
    \ "     HTML Character Entity Table   \n"
  let s:txt = s:txt . "\"" . s:prefix .
    \ "   =============================== \n"
  let s:txt = s:txt . "\"" . s:prefix .
    \ "    b : base | r : rip | q : quit  \n"
  let s:txt = s:txt . "\"" . s:prefix .
    \ "                                   \n"
  let s:txt = s:txt . "\"" . s:prefix .
    \ " See also :digraph, e.g., - <BS> M \n"
endfunction

" Creates the HTML Character Entity table
function s:MakeCharTable()

  " First display the most commonly used 
  " Entities, i.e., those with a decimal 
  " value of < 126. We can format these 
  " numeric refs. to be 6 chars wide (i.e., 
  " to accomodate &#126; which is &#x7E; 
  " which is 6 chars wide). The format of 
  " the symbol field is small, i.e., 3 
  " chars -- most entities' symbols are 
  " just one character, but whitespace 
  " entities are described otherwise, i.e., 
  " TAB, CR, etc. The description width is 
  " 0 because these entities can be 
  " described easily with just their symbol.
  let s:txt = s:txt . "\n\"" . s:prefix . 
    \ "          Common Entities\n\n"
  let hctLookup = s:GetHctLookup_7bits()
  let s:txt = s:txt . 
    \ s:MakeCharTableFromLookup(
    \   hctLookup, 3, 6, 3, 0)

  " Next, display the remaining Entities.
  " The entity with the largest numeric 
  " ref. is &#10004; a/k/a &#x2714; there-
  " fore, the entity format width is 10. The 
  " number of columns is just one, because each 
  " entity's description is rather long, and 
  " so each entity gets its own line. The 
  " symbol width is also just one, because we're
  " not using synonyms like TAB or CR to describe 
  " these entities. Finally, the minimum 
  " description width is set to 12, but really 
  " this doesn't do much, since each entity's 
  " description is longer than that.
  let s:txt = s:txt . "\n\"" . s:prefix 
    \ . "             The Rest\n\n"
  let hctLookup = s:GetHctLookup_14bits()
  let s:txt = s:txt . 
    \ s:MakeCharTableFromLookup(
    \   hctLookup, 1, 10, 1, 12)

endfunction

" Formats the given character table lookup 
" according to the specified parameters. The 
" caller can specify how many columns wide to 
" print the table, as well as the minimum widths 
" for the entity, symbol, and description fields.
function s:MakeCharTableFromLookup(theLookup, 
    \ numColumns, codeWidth, symWidth, descWidth)

  let theLookup = a:theLookup
  let numColumns = a:numColumns
  let codeWidth = a:codeWidth
  let symWidth = a:symWidth
  let descWidth = a:descWidth

  let tableStrng = ""

  let index = 0

  " Set the number of rows according to 
  " the number of columns and number of 
  " items to display
  let nRows = len(theLookup) / numColumns
  if 0 != (len(theLookup) % numColumns)
    " Add a row if there was a remainder
    let nRows = nRows + 1
  endif

  " Build the table line-by-line, left to right
  let row  = 0  

  while row < nRows

    let column = 0

    while column < numColumns

      let index = row + column * nRows

      if index < len(theLookup)

        " The entity lookup is a list of 
        " dictionaries. Each dictionary has four 
        " keys: 'nbr', 'sym', 'ent', and 'desc'

        " Add character entity reference or 
        " numeric character reference, as 
        " determined by base
        let tableStrng = tableStrng . " "
        if "ent" != g:hct_base
          let tableStrng = tableStrng . 
            \ s:Nr2HctItem(
            \   theLookup[index]["nbr"], 
            \   g:hct_base, codeWidth)
        else
          let tableStrng = tableStrng . 
            \ s:StringRightJustify(
            \   theLookup[index]["ent"], 
            \   codeWidth)
        endif
        let tableStrng = tableStrng . " "

        " Add the entity's character symbol
        if ("?" != theLookup[index]["sym"])
              \ || (63 == theLookup[index]["nbr"])
          let tableStrng = tableStrng . 
            \ s:StringRightJustify(
            \   theLookup[index]["sym"], 
            \   symWidth)
        else
          let tableStrng = tableStrng . " "
        endif

        " Add entity description
        if ( ("" != theLookup[index]["desc"])
            \ && (0 < descWidth) )
          let tableStrng = tableStrng . " " . 
            \ s:StringAddPadding(
            \   theLookup[index]["desc"], 
            \   descWidth)
        endif

      else
        " Index is greater than size of lookup;
        " just show blanks

        let tableStrng = tableStrng . " " . 
            \ s:StringRightJustify("", codeWidth)
        let tableStrng = tableStrng . " " . 
            \ s:StringAddPadding("", symWidth)

      endif

      " Show the column separator (vertical pipe)
      " if this isn't the right-most column
      let tableStrng = tableStrng . 
        \ ( (column == (numColumns - 1)) 
        \   ? "" : " |" )

      let column = column + 1
    endwhile

    let tableStrng = tableStrng . "\n"

    let row = row + 1
  endwhile

  return tableStrng

endfunction

" Table User Fcns.
" ------------------------

" Cycle forwards or backwards through set of 
" base displays. I.e., user can choose whether 
" entities are display in base-10, base-16, or 
" by their friendly name
function <SID>HCT_ToggleBase(direction)

  " Save the current cursor position, since 
  " we're re-writing the buffer from scratch.
  " NOTE Saving and restoring the cursor causes 
  "      the cursor to be centered, which causes
  "      the screen to scroll. So we need to also 
  "      take into account the first and last 
  "      visible buffer line in the window
  let cursorLineNr = line(".")
  let firstVisibleLineNr = line("w0")
  let lastVisibleLineNr = line("w$")

  " If direction is positive, cycle 
  " forward through the list, i.e., 
  " dec -> hex -> ent -> dec -> etc.
  if 0 < a:direction
    if g:hct_base == "dec"
      let g:hct_base = "hex"
    elseif g:hct_base == "hex"
      let g:hct_base = "ent"
    elseif g:hct_base == "ent"
      let g:hct_base = "dec"
    endif
  " If direction is negative, cycle 
  " backward through the list, i.e., 
  " dec -> ent -> hex -> dec -> etc.
  elseif 0 > a:direction
    if g:hct_base == "dec"
      let g:hct_base = "ent"
    elseif g:hct_base == "hex"
      let g:hct_base = "dec"
    elseif g:hct_base == "ent"
      let g:hct_base = "hex"
    endif
  endif

  " Redraw the table using the new base
  call <SID>HCT_HtmlCharTable()

  " Restore the cursor position.
  " NOTE Calling just cursor() centers the cursor 
  "      within the screen, but the user probably 
  "      didn't have the cursor visually centered
  "      within the window. So, in order to use 
  "      cursor() to position the screen as it 
  "      was before the base change, we need to 
  "      figure out the middle of the screen 
  "      using the first and last visible lines.

  " Start by counting the number of visible lines
  let visibleLineCount = 
    \ (lastVisibleLineNr - firstVisibleLineNr + 1)
  " Next, determine the center-most line number
  let midVisibleLineNr = firstVisibleLineNr + 
    \ (visibleLineCount / 2)
  " and subtract one if there's an even number of 
  " lines (otherwise we're off by one and the 
  " window scrolls by one line)
  if 0 == (visibleLineCount % 2)
    let midVisibleLineNr = midVisibleLineNr - 1
  endif
  " Finally, position the cursor.
  " NOTE We can't just position the cursor -- 
  "      Vim has its own idea how to position
  "      the window when we do so. Rather, 
  "      after positioning the cursor, we 
  "      need to center the screen around 
  "      the cursor using the 'zz' command.
  call cursor(midVisibleLineNr, 1)
  execute "normal " . "zz"

  " At this point, the first and last visible 
  " lines are the same as they were before the 
  " base change, but the cursor has been moved 
  " to the middle of the screen

endfunction

" This functions yanks the entity under the 
" cursor (or nearest the cursor), closes 
" the entity table, and puts the yanked 
" text into the last-used buffer.
" TODO If the user has the table open in a 
"      separate window and is cycling through
"      numerous buffers before running this 
"      command, I'm sure it'll not work as 
"      expected.
function <SID>HCT_YankExitAndPut()
  " Here's a map option that almost 
  " implements what we want:
  "
  "    nnoremap <buffer> <silent> p 
  "     \ ?&[#a-zA-Z0-9]\+;<CR>"xy/;<CR>
  "     \ :call <SID>HCT_Exit()<CR>"xpa;<ESC>
  "
  " Alas, it's a little more complicated than
  " that. For the short list of common entities, 
  " there are multiple columns, so we gotta be 
  " careful about how we search. Also, we need 
  " to be able to search forward and backward, 
  " as we can't assume the user has placed the 
  " cursor on the entity itself -- it might 
  " precede it or follow it.

  " Use the search command to see if the entity 
  " starts before (or at) the current cursor 
  " position.
  "   flags: 'b' - search backward
  "          'c' - accept match at cursor position
  "   stopline: restricts search to current line
  let matchLine = search(
          \ '&[#a-zA-Z0-9]\+;', 'bc', line("."))
  if 0 == matchLine
    " there was no match! try forwards
    let matchLine = search(
          \ '&[#a-zA-Z0-9]\+;', '', line("."))
  endif
  if 0 == matchLine
    " still no match? just do a visual bell...
    execute "normal ". '|f<CR>'
  else
    " The cursor now sits on an ampersand; 
    " we want to copy text from here up to 
    " the semi-colon
    "
    " NOTE You'd think you could just yank
    "      what you want straight from the 
    "      buffer, but -- what gives? -- 
    "      this does not work:
    "
    "         setlocal modifiable
    "         execute 'normal "xy/;<CR>'
    "
    "      I also tried marking cursor 
    "      positions with mk and "ay'k but 
    "      that still grabs the whole line, 
    "      not just the part we want.
    " 
    " So, whatever, grab the whole line and 
    " go from there.
    "
    " We also need the start and ending column
    " numbers of the entity, so that we may 
    " grab it using strpart, which extracts a 
    " substring from a string.

    " NOTE search() returns the line number of 
    "      the match, but not the column number.
    "      However, since it moves the cursor, 
    "      we can just ask the cursor where it's 
    "      at.
    let startCol = col('.')

    " Now find where the entity ends (by looking 
    " for its semi-colon)
    let matchLine = search(';', '', line("."))
    " Again, ask the cursor where it's at
    let finalCol = col('.')

    " Calculate the length of the substring
    " (and add one cause of inclusivity)
    let numColumns = finalCol - startCol + 1

    " Finally, get the substring
    let ln = getline(line('.'))
    " NOTE col() returns a 1-based column number,
    "      but strpart uses 0-based numbering!
    "      So substract one from the startCol.
    let match = strpart(
                  \ ln, startCol - 1, numColumns)

    " Assign text to some register ('x' works!)
    let @x = match

    " Lastly, close the table buffer and plop, 
    " er, *put* the yanked text into the buffer
    call <SID>HCT_Exit()
    execute "normal " . '"xp'

  endif
endfunction

" Job is done. Clean up.
function <SID>HCT_Exit()
  " Close the lookup table buffer and window
  " and reposition the cursor
  call s:CloseViewBuffer()
endfunction

" ------------------------------------------
" QuickLookup

" The QuickLookup lets the user quickly type 
" just the character they want translated, and 
" the entity referece is then inserted into their 
" buffer. The table is not displayed at all.
function s:QuickLookup()
  let match = ""
  " Ask the user for a character to translate
  echo "HTML Entity Translator >> "
        \ . "Please enter a character: "
  let ch = nr2char(getchar())
  " Get the common entity lookup and 
  " check there first
  let ref = s:QuickLookup_TryLookup(
    \ ch, s:GetHctLookup_7bits())
  if {} == ref
    " Not found; Try the other lookup
    let ref = s:QuickLookup_TryLookup(
      \ ch, s:GetHctLookup_14bits())
  endif
  " Paste 'em if we got 'em
  if {} != ref
    " Use the entity abbrev. in one exists
    if "" != ref['ent']
      let match = ref['ent']
    else
      " Otherwise, just use the decimalized form
      let match = s:Nr2String(ref['nbr'], 'dec')
      let match = s:String2HCTFormat(
                              \ match, 'dec', 0)
    endif
    " Finally, set the match to a register
    " so we can put it in the user's buffer.
    let @x = match
    execute "normal " . '"xp'
    " TODO The earlier echo ("Please enter...")
    "      is still displayed, but you can't call
    "      echo '' -- the user still has to hit
    "      enter to acknowledge the (blank) echo
  else
    " Not found!
    echo "Sorry, the HTML entity for '" 
        \ . ch . "' was not found!"
  endif
endfunction

" Helper function; tries to find character 
" ch in the entity lookup table hctLookup.
" Returns a dictionary reference to the entity 
" if found, otherwise returns the empty string
function s:QuickLookup_TryLookup(ch, hctLookup)
  let ref = {}
  for ent in a:hctLookup
    if ent['sym'] == a:ch
      let ref = ent
      break
    endif
  endfor
  return ref
endfunction

" ------------------------------------------
" Utility Functions

" Nr2String converts the number nr to a 
" string according to the desired base, 
" i.e., 10 for base-10, or 16 for base-16.
function s:Nr2String(nr, base)

  let nr   = a:nr
  let base = a:base

  " get base as a number
  if (a:base == "dec")
    let base = 10
  else
    let base = 16
  endif

  " convert number to string
  let strng = (nr == 0) ? "0" : ""

  while nr
    let strng = '0123456789ABCDEF'[nr % base] 
                  \ . strng
    let nr = nr / base
  endwhile

  return strng

endfunction

" Converts a non-negative integer to 
" an HTML Numeric Character Reference.
" For base-10, this is of the form, 
"    &decimal; 
" For base-16, this is of the form, 
"    &#xhexidecimal; 
" I.e., &#65; == &#x41; 
function s:Nr2HctItem(nr, base, width)

  let strng = s:Nr2String(a:nr, a:base)
  let strng = s:String2HCTFormat(
               \ strng, a:base, a:width)
  return strng

endfunction

" String2HCTFormat prepends strng with the 
" appropriate HTML entity escape sequence, 
" i.e., &# or &#x, depending on whether 
" base is "dec" or "hex", prepends a semi-
" colon, and then right-justifies the result 
" to be at least width wide.
function s:String2HCTFormat(strng, base, width)

  " Choose the prefix according to base
  " a/k/a all your prefixes are belong to us
  if (a:base == "dec")
    let prefix = '&#'
  else "if (a:base == "hex")
    let prefix = '&#x'
  endif

  " Prepend the escape and append a semi-colon
  " to make the reference.
  let strng = prefix . a:strng . ';'

  " Right-align the result so it looks pretty 
  " in the table
  let strng = s:StringRightJustify(strng, a:width)

  return strng

endfunction

" StringAddPadding appends strng with 
" spaces until it's at least width wide.
function s:StringAddPadding(strng, width)

  let strng = a:strng

  let spaces = a:width - strlen(strng)
  if spaces > 0
    while spaces
      let strng = strng . ' '
      let spaces = spaces - 1
    endwhile
  endif

  return strng

endfunction

" StringRightJustify prepends strng with 
" spaces until it's at least width wide.
function s:StringRightJustify(strng, width)

  let strng = a:strng

  let spaces = a:width - strlen(strng)

  if spaces > 0
    while spaces
      let strng = ' ' . strng
      let spaces = spaces - 1
    endwhile
  endif

  return strng

endfunction

" ------------------------------------------
" The Lookup Tables

" HTML Entities <= 0x7F
" ------------------------
"  These entities are easily describable by 
"  their symbol, and most symbols (all but the 
"  non-space whitespace ones) can be represented 
"  in Vim, so these items take up less space when 
"  displayed, such that the table can have more 
"  than one column. I.e., the entities <= 0x7F 
"  are easier to describe than those > 0x7F, 
"  hence we split the two groups into separate
"  lookups.
function s:GetHctLookup_7bits()

  let HctLookup = [ 
    \ {'nbr':  09, 'sym': 'TAB', 'desc': '', 'ent': ''}, 
    \ {'nbr':  10, 'sym':  'LF', 'desc': '', 'ent': ''}, 
    \ {'nbr':  13, 'sym':  'CR', 'desc': '', 'ent': ''}, 
    \ {'nbr':  32, 'sym':   "'", 'desc': '', 'ent': ''}, 
    \ {'nbr':  33, 'sym':   '!', 'desc': '', 'ent': ''}, 
    \ {'nbr':  34, 'sym':   '"', 'desc': '', 'ent': '&quot;'}, 
    \ {'nbr':  35, 'sym':   '#', 'desc': '', 'ent': ''}, 
    \ {'nbr':  36, 'sym':   '$', 'desc': '', 'ent': ''}, 
    \ {'nbr':  37, 'sym':   '%', 'desc': '', 'ent': ''}, 
    \ {'nbr':  38, 'sym':   '&', 'desc': '', 'ent': '&amp;'}, 
    \ {'nbr':  39, 'sym':   "'", 'desc': '', 'ent': ''}, 
    \ {'nbr':  40, 'sym':   '(', 'desc': '', 'ent': ''}, 
    \ {'nbr':  41, 'sym':   ')', 'desc': '', 'ent': ''}, 
    \ {'nbr':  42, 'sym':   '*', 'desc': '', 'ent': ''}, 
    \ {'nbr':  43, 'sym':   '+', 'desc': '', 'ent': ''}, 
    \ {'nbr':  44, 'sym':   ',', 'desc': '', 'ent': ''}, 
    \ {'nbr':  45, 'sym':   '-', 'desc': '', 'ent': ''}, 
    \ {'nbr':  46, 'sym':   '.', 'desc': '', 'ent': ''}, 
    \ {'nbr':  47, 'sym':   '/', 'desc': '', 'ent': ''}, 
    \ {'nbr':  58, 'sym':   ':', 'desc': '', 'ent': ''}, 
    \ {'nbr':  59, 'sym':   ';', 'desc': '', 'ent': ''}, 
    \ {'nbr':  60, 'sym':   '<', 'desc': '', 'ent': '&lt;'}, 
    \ {'nbr':  61, 'sym':   '=', 'desc': '', 'ent': ''}, 
    \ {'nbr':  62, 'sym':   '>', 'desc': '', 'ent': '&gt;'}, 
    \ {'nbr':  63, 'sym':   '?', 'desc': '', 'ent': ''}, 
    \ {'nbr':  64, 'sym':   '@', 'desc': '', 'ent': ''}, 
    \ {'nbr':  91, 'sym':   '[', 'desc': '', 'ent': ''}, 
    \ {'nbr':  92, 'sym':   '\', 'desc': '', 'ent': ''}, 
    \ {'nbr':  93, 'sym':   ']', 'desc': '', 'ent': ''}, 
    \ {'nbr':  94, 'sym':   '^', 'desc': '', 'ent': ''}, 
    \ {'nbr':  95, 'sym':   '_', 'desc': '', 'ent': ''}, 
    \ {'nbr':  96, 'sym':   '`', 'desc': '', 'ent': ''}, 
    \ {'nbr': 123, 'sym':   '{', 'desc': '', 'ent': ''}, 
    \ {'nbr': 124, 'sym':   '|', 'desc': '', 'ent': ''}, 
    \ {'nbr': 125, 'sym':   '}', 'desc': '', 'ent': ''}, 
    \ {'nbr': 126, 'sym':   '~', 'desc': '', 'ent': ''}, 
    \ ] 

  return HctLookup

endfunction

" HTML Entities > 0x7F
" ------------------------
"  These entities' symbols are generally 
"  not displayable in Vim, their entity 
"  names are rather long, and the description 
"  of the symbol is also quite verbose, so 
"  these entities get displayed one per line.
function s:GetHctLookup_14bits()

  let lineWrapSpace = "\n              "

  let HctLookup = [ 
    \ {'nbr': 160, 'sym': ' ', 'ent': '&nbsp;', 'desc': "no-break space, non-breaking space"}, 
    \ {'nbr': 161, 'sym': '¡', 'ent': '&iexcl;', 'desc': "inverted exclamation mark"}, 
    \ {'nbr': 162, 'sym': '¢', 'ent': '&cent;', 'desc': "Cent sign"}, 
    \ {'nbr': 163, 'sym': '£', 'ent': '&pound;', 'desc': "Pound sterling"}, 
    \ {'nbr': 164, 'sym': '¤', 'ent': '&curren;', 'desc': "General currency sign"}, 
    \ {'nbr': 165, 'sym': '¥', 'ent': '&yen;', 'desc': "yen sign, yuan sign"}, 
    \ {'nbr': 166, 'sym': '¦', 'ent': '&brvbar;', 'desc': "pipe or broken (vertical) bar"}, 
    \ {'nbr': 167, 'sym': '§', 'ent': '&sect;', 'desc': "Section sign"}, 
    \ {'nbr': 168, 'sym': '¨', 'ent': '&uml;', 'desc': "diaeresis, spacing diaeresis"}, 
    \ {'nbr': 169, 'sym': '©', 'ent': '&copy;', 'desc': "copyright sign"}, 
    \ {'nbr': 170, 'sym': 'ª', 'ent': '&ordf;', 'desc': "feminine ordinal indicator"}, 
    \ {'nbr': 171, 'sym': '«', 'ent': '&laquo;', 'desc': "left-pointing double angle quotation" . lineWrapSpace . "mark, left pointing guillemet"}, 
    \ {'nbr': 172, 'sym': '¬', 'ent': '&not;', 'desc': "not sign"}, 
    \ {'nbr': 173, 'sym': '', 'ent': '&shy;', 'desc': "soft hyphen, discretionary hyphen"}, 
    \ {'nbr': 174, 'sym': '®', 'ent': '&reg;', 'desc': "registered (trade mark) sign"}, 
    \ {'nbr': 175, 'sym': '¯', 'ent': '&macr;', 'desc': "spacing macron, overline, APL overbar"}, 
    \ {'nbr': 176, 'sym': '°', 'ent': '&deg;', 'desc': "degree sign"}, 
    \ {'nbr': 177, 'sym': '±', 'ent': '&plusmn;', 'desc': "plus-minus sign, plus-or-minus sign"}, 
    \ {'nbr': 178, 'sym': '²', 'ent': '&sup2;', 'desc': "superscript (digit) two, squared"}, 
    \ {'nbr': 179, 'sym': '³', 'ent': '&sup3;', 'desc': "superscript (digit) three, cubed"}, 
    \ {'nbr': 180, 'sym': '´', 'ent': '&acute;', 'desc': "acute accent, spacing acute"}, 
    \ {'nbr': 181, 'sym': 'µ', 'ent': '&micro;', 'desc': "micro sign"}, 
    \ {'nbr': 182, 'sym': '¶', 'ent': '&para;', 'desc': "pilcrow sign, paragraph sign"}, 
    \ {'nbr': 183, 'sym': '·', 'ent': '&middot;', 'desc': "(Greek) middle dot, Georgian comma"}, 
    \ {'nbr': 184, 'sym': '¸', 'ent': '&cedil;', 'desc': "(spacing) cedilla"}, 
    \ {'nbr': 185, 'sym': '¹', 'ent': '&sup1;', 'desc': "superscript (digit) one"}, 
    \ {'nbr': 186, 'sym': 'º', 'ent': '&ordm;', 'desc': "masculine ordinal indicator"}, 
    \ {'nbr': 187, 'sym': '»', 'ent': '&raquo;', 'desc': "right-pointing double angle quotation" . lineWrapSpace . "mark, right pointing guillemet"}, 
    \ {'nbr': 188, 'sym': '¼', 'ent': '&frac14;', 'desc': "(vulgar) fraction one quarter"}, 
    \ {'nbr': 189, 'sym': '½', 'ent': '&frac12;', 'desc': "(vulgar) fraction one half"}, 
    \ {'nbr': 190, 'sym': '¾', 'ent': '&frac34;', 'desc': "(vulgar) fraction three quarters"}, 
    \ {'nbr': 191, 'sym': '¿', 'ent': '&iquest;', 'desc': "inverted/turned question mark"}, 
    \ {'nbr': 192, 'sym': 'À', 'ent': '&Agrave;', 'desc': "latin capital letter A with grave"}, 
    \ {'nbr': 193, 'sym': 'Á', 'ent': '&Aacute;', 'desc': "latin capital letter A with acute"}, 
    \ {'nbr': 194, 'sym': 'Â', 'ent': '&Acirc;', 'desc': "latin capital letter A w/ circumflex"}, 
    \ {'nbr': 195, 'sym': 'Ã', 'ent': '&Atilde;', 'desc': "latin capital letter A with tilde"}, 
    \ {'nbr': 196, 'sym': 'Ä', 'ent': '&Auml;', 'desc': "latin capital letter A with diaeresis"}, 
    \ {'nbr': 197, 'sym': 'Å', 'ent': '&Aring;', 'desc': "latin capital letter A w/ ring above"}, 
    \ {'nbr': 198, 'sym': 'Æ', 'ent': '&AElig;', 'desc': "latin capital letter/ligature AE"}, 
    \ {'nbr': 199, 'sym': 'Ç', 'ent': '&Ccedil;', 'desc': "latin capital letter C with cedilla"}, 
    \ {'nbr': 200, 'sym': 'È', 'ent': '&Egrave;', 'desc': "latin capital letter E with grave"}, 
    \ {'nbr': 201, 'sym': 'É', 'ent': '&Eacute;', 'desc': "latin capital letter E with acute"}, 
    \ {'nbr': 202, 'sym': 'Ê', 'ent': '&Ecirc;', 'desc': "latin capital letter E w/ circumflex"}, 
    \ {'nbr': 203, 'sym': 'Ë', 'ent': '&Euml;', 'desc': "latin capital letter E with diaeresis"}, 
    \ {'nbr': 204, 'sym': 'Ì', 'ent': '&Igrave;', 'desc': "latin capital letter I with grave"}, 
    \ {'nbr': 205, 'sym': 'Í', 'ent': '&Iacute;', 'desc': "latin capital letter I with acute"}, 
    \ {'nbr': 206, 'sym': 'Î', 'ent': '&Icirc;', 'desc': "latin capital letter I w/ circumflex"}, 
    \ {'nbr': 207, 'sym': 'Ï', 'ent': '&Iuml;', 'desc': "latin capital letter I with diaeresis"}, 
    \ {'nbr': 208, 'sym': 'Ð', 'ent': '&ETH;', 'desc': "latin capital letter ETH"}, 
    \ {'nbr': 209, 'sym': 'Ñ', 'ent': '&Ntilde;', 'desc': "latin capital letter N with tilde"}, 
    \ {'nbr': 210, 'sym': 'Ò', 'ent': '&Ograve;', 'desc': "latin capital letter O with grave"}, 
    \ {'nbr': 211, 'sym': 'Ó', 'ent': '&Oacute;', 'desc': "latin capital letter O with acute"}, 
    \ {'nbr': 212, 'sym': 'Ô', 'ent': '&Ocirc;', 'desc': "latin capital letter O w/ circumflex"}, 
    \ {'nbr': 213, 'sym': 'Õ', 'ent': '&Otilde;', 'desc': "latin capital letter O with tilde"}, 
    \ {'nbr': 214, 'sym': 'Ö', 'ent': '&Ouml;', 'desc': "latin capital letter O with diaeresis"}, 
    \ {'nbr': 215, 'sym': '×', 'ent': '&times;', 'desc': "multiplication sign"}, 
    \ {'nbr': 216, 'sym': 'Ø', 'ent': '&Oslash;', 'desc': "latin cap. letter O w/ stroke/slash"}, 
    \ {'nbr': 217, 'sym': 'Ù', 'ent': '&Ugrave;', 'desc': "latin capital letter U with grave"}, 
    \ {'nbr': 218, 'sym': 'Ú', 'ent': '&Uacute;', 'desc': "latin capital letter U with acute"}, 
    \ {'nbr': 219, 'sym': 'Û', 'ent': '&Ucirc;', 'desc': "latin capital letter U w/ circumflex"}, 
    \ {'nbr': 220, 'sym': 'Ü', 'ent': '&Uuml;', 'desc': "latin capital letter U with diaeresis"}, 
    \ {'nbr': 221, 'sym': 'Ý', 'ent': '&Yacute;', 'desc': "latin capital letter Y with acute"}, 
    \ {'nbr': 222, 'sym': 'Þ', 'ent': '&THORN;', 'desc': "latin capital letter THORN"}, 
    \ {'nbr': 223, 'sym': 'ß', 'ent': '&szlig;', 'desc': "Small sharp s, German (sz ligature)"}, 
    \ {'nbr': 223, 'sym': 'ß', 'ent': '&szlig;', 'desc': "latin small letter sharp s, ess-zed"}, 
    \ {'nbr': 224, 'sym': 'à', 'ent': '&agrave;', 'desc': "latin small letter a (with) grave"}, 
    \ {'nbr': 225, 'sym': 'á', 'ent': '&aacute;', 'desc': "latin small letter a with acute"}, 
    \ {'nbr': 226, 'sym': 'â', 'ent': '&acirc;', 'desc': "latin small letter a w/ circumflex"}, 
    \ {'nbr': 227, 'sym': 'ã', 'ent': '&atilde;', 'desc': "latin small letter a with tilde"}, 
    \ {'nbr': 228, 'sym': 'ä', 'ent': '&auml;', 'desc': "latin small letter a with diaeresis"}, 
    \ {'nbr': 229, 'sym': 'å', 'ent': '&aring;', 'desc': "latin small letter a with ring above"}, 
    \ {'nbr': 230, 'sym': 'æ', 'ent': '&aelig;', 'desc': "latin small letter/ligature ae"}, 
    \ {'nbr': 231, 'sym': 'ç', 'ent': '&ccedil;', 'desc': "latin small letter c with cedilla"}, 
    \ {'nbr': 232, 'sym': 'è', 'ent': '&egrave;', 'desc': "latin small letter e with grave"}, 
    \ {'nbr': 233, 'sym': 'é', 'ent': '&eacute;', 'desc': "latin small letter e with acute"}, 
    \ {'nbr': 234, 'sym': 'ê', 'ent': '&ecirc;', 'desc': "latin small letter e with circumflex"}, 
    \ {'nbr': 235, 'sym': 'ë', 'ent': '&euml;', 'desc': "latin small letter e with diaeresis"}, 
    \ {'nbr': 236, 'sym': 'ì', 'ent': '&igrave;', 'desc': "latin small letter i with grave"}, 
    \ {'nbr': 237, 'sym': 'í', 'ent': '&iacute;', 'desc': "latin small letter i with acute"}, 
    \ {'nbr': 238, 'sym': 'î', 'ent': '&icirc;', 'desc': "latin small letter i with circumflex"}, 
    \ {'nbr': 239, 'sym': 'ï', 'ent': '&iuml;', 'desc': "latin small letter i with diaeresis"}, 
    \ {'nbr': 240, 'sym': 'ð', 'ent': '&eth;', 'desc': "latin small letter eth"}, 
    \ {'nbr': 241, 'sym': 'ñ', 'ent': '&ntilde;', 'desc': "latin small letter n with tilde"}, 
    \ {'nbr': 242, 'sym': 'ò', 'ent': '&ograve;', 'desc': "latin small letter o with grave"}, 
    \ {'nbr': 243, 'sym': 'ó', 'ent': '&oacute;', 'desc': "latin small letter o with acute"}, 
    \ {'nbr': 244, 'sym': 'ô', 'ent': '&ocirc;', 'desc': "latin small letter o with circumflex"}, 
    \ {'nbr': 245, 'sym': 'õ', 'ent': '&otilde;', 'desc': "latin small letter o with tilde"}, 
    \ {'nbr': 246, 'sym': 'ö', 'ent': '&ouml;', 'desc': "latin small letter o with diaeresis"}, 
    \ {'nbr': 247, 'sym': '÷', 'ent': '&divide;', 'desc': "division sign"}, 
    \ {'nbr': 248, 'sym': 'ø', 'ent': '&oslash;', 'desc': "latin small letter o w/ stroke/slash"}, 
    \ {'nbr': 249, 'sym': 'ù', 'ent': '&ugrave;', 'desc': "latin small letter u with grave"}, 
    \ {'nbr': 250, 'sym': 'ú', 'ent': '&uacute;', 'desc': "latin small letter u with acute"}, 
    \ {'nbr': 251, 'sym': 'û', 'ent': '&ucirc;', 'desc': "latin small letter u with circumflex"}, 
    \ {'nbr': 252, 'sym': 'ü', 'ent': '&uuml;', 'desc': "latin small letter u with diaeresis"}, 
    \ {'nbr': 253, 'sym': 'ý', 'ent': '&yacute;', 'desc': "latin small letter y with acute"}, 
    \ {'nbr': 254, 'sym': 'þ', 'ent': '&thorn;', 'desc': "latin small letter thorn"}, 
    \ {'nbr': 255, 'sym': 'ÿ', 'ent': '&yuml;', 'desc': "Small y, dieresis or umlaut mark"}, 
    \ {'nbr': 338, 'sym': 'Œ', 'ent': '&OElig;', 'desc': "latin capital ligature OE"}, 
    \ {'nbr': 339, 'sym': 'œ', 'ent': '&oelig;', 'desc': "latin small ligature oe"}, 
    \ {'nbr': 352, 'sym': 'Š', 'ent': '&Scaron;', 'desc': "latin capital letter S with caron"}, 
    \ {'nbr': 353, 'sym': 'š', 'ent': '&scaron;', 'desc': "latin small letter s with caron"}, 
    \ {'nbr': 376, 'sym': 'Ÿ', 'ent': '&Yuml;', 'desc': "latin capital letter Y with diaeresis"}, 
    \ {'nbr': 402, 'sym': 'ƒ', 'ent': '&fnof;', 'desc': "latin sm. f w/ hook, function, florin"}, 
    \ {'nbr': 710, 'sym': 'ˆ', 'ent': '&circ;', 'desc': "modifier letter circumflex accent"}, 
    \ {'nbr': 732, 'sym': '˜', 'ent': '&tilde;', 'desc': "small tilde"}, 
    \ {'nbr': 913, 'sym': '?', 'ent': '&Alpha;', 'desc': "greek capital letter alpha"}, 
    \ {'nbr': 914, 'sym': '?', 'ent': '&Beta;', 'desc': "greek capital letter beta"}, 
    \ {'nbr': 915, 'sym': 'G', 'ent': '&Gamma;', 'desc': "greek capital letter gamma"}, 
    \ {'nbr': 916, 'sym': '?', 'ent': '&Delta;', 'desc': "greek capital letter delta"}, 
    \ {'nbr': 917, 'sym': '?', 'ent': '&Epsilon;', 'desc': "greek capital letter epsilon"}, 
    \ {'nbr': 918, 'sym': '?', 'ent': '&Zeta;', 'desc': "greek capital letter zeta"}, 
    \ {'nbr': 919, 'sym': '?', 'ent': '&Eta;', 'desc': "greek capital letter eta"}, 
    \ {'nbr': 920, 'sym': 'T', 'ent': '&Theta;', 'desc': "greek capital letter theta"}, 
    \ {'nbr': 921, 'sym': '?', 'ent': '&Iota;', 'desc': "greek capital letter iota"}, 
    \ {'nbr': 922, 'sym': '?', 'ent': '&Kappa;', 'desc': "greek capital letter kappa"}, 
    \ {'nbr': 923, 'sym': '?', 'ent': '&Lambda;', 'desc': "greek capital letter lambda"}, 
    \ {'nbr': 924, 'sym': '?', 'ent': '&Mu;', 'desc': "greek capital letter mu"}, 
    \ {'nbr': 925, 'sym': '?', 'ent': '&Nu;', 'desc': "greek capital letter nu"}, 
    \ {'nbr': 926, 'sym': '?', 'ent': '&Xi;', 'desc': "greek capital letter xi"}, 
    \ {'nbr': 927, 'sym': '?', 'ent': '&Omicron;', 'desc': "greek capital letter omicron"}, 
    \ {'nbr': 928, 'sym': '?', 'ent': '&Pi;', 'desc': "greek capital letter pi"}, 
    \ {'nbr': 929, 'sym': '?', 'ent': '&Rho;', 'desc': "greek capital letter rho"}, 
    \ {'nbr': 931, 'sym': 'S', 'ent': '&Sigma;', 'desc': "greek capital letter sigma"}, 
    \ {'nbr': 932, 'sym': '?', 'ent': '&Tau;', 'desc': "greek capital letter tau"}, 
    \ {'nbr': 933, 'sym': '?', 'ent': '&Upsilon;', 'desc': "greek capital letter upsilon"}, 
    \ {'nbr': 934, 'sym': 'F', 'ent': '&Phi;', 'desc': "greek capital letter phi"}, 
    \ {'nbr': 935, 'sym': '?', 'ent': '&Chi;', 'desc': "greek capital letter chi"}, 
    \ {'nbr': 936, 'sym': '?', 'ent': '&Psi;', 'desc': "greek capital letter psi"}, 
    \ {'nbr': 937, 'sym': 'O', 'ent': '&Omega;', 'desc': "greek capital letter omega"}, 
    \ {'nbr': 945, 'sym': 'a', 'ent': '&alpha;', 'desc': "greek small letter alpha"}, 
    \ {'nbr': 946, 'sym': 'ß', 'ent': '&beta;', 'desc': "greek small letter beta"}, 
    \ {'nbr': 947, 'sym': '?', 'ent': '&gamma;', 'desc': "greek small letter gamma"}, 
    \ {'nbr': 948, 'sym': 'd', 'ent': '&delta;', 'desc': "greek small letter delta"}, 
    \ {'nbr': 949, 'sym': 'e', 'ent': '&epsilon;', 'desc': "greek small letter epsilon"}, 
    \ {'nbr': 950, 'sym': '?', 'ent': '&zeta;', 'desc': "greek small letter zeta"}, 
    \ {'nbr': 951, 'sym': '?', 'ent': '&eta;', 'desc': "greek small letter eta"}, 
    \ {'nbr': 952, 'sym': '?', 'ent': '&theta;', 'desc': "greek small letter theta"}, 
    \ {'nbr': 953, 'sym': '?', 'ent': '&iota;', 'desc': "greek small letter iota"}, 
    \ {'nbr': 954, 'sym': '?', 'ent': '&kappa;', 'desc': "greek small letter kappa"}, 
    \ {'nbr': 955, 'sym': '?', 'ent': '&lambda;', 'desc': "greek small letter lambda"}, 
    \ {'nbr': 956, 'sym': 'µ', 'ent': '&mu;', 'desc': "greek small letter mu"}, 
    \ {'nbr': 957, 'sym': '?', 'ent': '&nu;', 'desc': "greek small letter nu"}, 
    \ {'nbr': 958, 'sym': '?', 'ent': '&xi;', 'desc': "greek small letter xi"}, 
    \ {'nbr': 959, 'sym': '?', 'ent': '&omicron;', 'desc': "greek small letter omicron"}, 
    \ {'nbr': 960, 'sym': 'p', 'ent': '&pi;', 'desc': "greek small letter pi"}, 
    \ {'nbr': 961, 'sym': '?', 'ent': '&rho;', 'desc': "greek small letter rho"}, 
    \ {'nbr': 962, 'sym': '?', 'ent': '&sigmaf;', 'desc': "greek small letter final sigma"}, 
    \ {'nbr': 963, 'sym': 's', 'ent': '&sigma;', 'desc': "greek small letter sigma"}, 
    \ {'nbr': 964, 'sym': 't', 'ent': '&tau;', 'desc': "greek small letter tau"}, 
    \ {'nbr': 965, 'sym': '?', 'ent': '&upsilon;', 'desc': "greek small letter upsilon"}, 
    \ {'nbr': 966, 'sym': 'f', 'ent': '&phi;', 'desc': "greek small letter phi"}, 
    \ {'nbr': 967, 'sym': '?', 'ent': '&chi;', 'desc': "greek small letter chi"}, 
    \ {'nbr': 968, 'sym': '?', 'ent': '&psi;', 'desc': "greek small letter psi"}, 
    \ {'nbr': 969, 'sym': '?', 'ent': '&omega;', 'desc': "greek small letter omega"}, 
    \ {'nbr': 977, 'sym': '?', 'ent': '&thetasym;', 'desc': "greek small letter theta symbol"}, 
    \ {'nbr': 978, 'sym': '?', 'ent': '&upsih;', 'desc': "greek upsilon with hook symbol"}, 
    \ {'nbr': 982, 'sym': '?', 'ent': '&piv;', 'desc': "greek pi symbol"}, 
    \ {'nbr': 8194, 'sym': ' ', 'ent': '&ensp;', 'desc': "en space"}, 
    \ {'nbr': 8195, 'sym': ' ', 'ent': '&emsp;', 'desc': "em space"}, 
    \ {'nbr': 8201, 'sym': '?', 'ent': '&thinsp;', 'desc': "thin space"}, 
    \ {'nbr': 8204, 'sym': '?', 'ent': '&zwnj;', 'desc': "zero width non-joiner"}, 
    \ {'nbr': 8205, 'sym': '?', 'ent': '&zwj;', 'desc': "zero width joiner"}, 
    \ {'nbr': 8206, 'sym': '?', 'ent': '&lrm;', 'desc': "left-to-right mark"}, 
    \ {'nbr': 8207, 'sym': '?', 'ent': '&rlm;', 'desc': "right-to-left mark"}, 
    \ {'nbr': 8211, 'sym': '–', 'ent': '&ndash;', 'desc': "en dash"}, 
    \ {'nbr': 8212, 'sym': '—', 'ent': '&mdash;', 'desc': "em dash"}, 
    \ {'nbr': 8216, 'sym': '‘', 'ent': '&lsquo;', 'desc': "left single quotation mark"}, 
    \ {'nbr': 8217, 'sym': '’', 'ent': '&rsquo;', 'desc': "right single quotation mark"}, 
    \ {'nbr': 8218, 'sym': '‚', 'ent': '&sbquo;', 'desc': "single low-9 quotation mark"}, 
    \ {'nbr': 8220, 'sym': '“', 'ent': '&ldquo;', 'desc': "left double quotation mark"}, 
    \ {'nbr': 8221, 'sym': '”', 'ent': '&rdquo;', 'desc': "right double quotation mark"}, 
    \ {'nbr': 8222, 'sym': '„', 'ent': '&bdquo;', 'desc': "double low-9 quotation mark"}, 
    \ {'nbr': 8224, 'sym': '†', 'ent': '&dagger;', 'desc': "dagger"}, 
    \ {'nbr': 8225, 'sym': '‡', 'ent': '&Dagger;', 'desc': "double dagger"}, 
    \ {'nbr': 8226, 'sym': '•', 'ent': '&bull;', 'desc': "bullet, black small circle"}, 
    \ {'nbr': 8230, 'sym': '…', 'ent': '&hellip;', 'desc': "horizontal ellipsis, three dot leader"}, 
    \ {'nbr': 8240, 'sym': '‰', 'ent': '&permil;', 'desc': "per mille sign"}, 
    \ {'nbr': 8242, 'sym': "'", 'ent': '&prime;', 'desc': "prime, minutes, feet"}, 
    \ {'nbr': 8243, 'sym': '?', 'ent': '&Prime;', 'desc': "double prime, seconds, inches"}, 
    \ {'nbr': 8249, 'sym': '‹', 'ent': '&lsaquo;', 'desc': "single left-pointing angle quotation"}, 
    \ {'nbr': 8250, 'sym': '›', 'ent': '&rsaquo;', 'desc': "single right-pointing angle quotation"}, 
    \ {'nbr': 8254, 'sym': '?', 'ent': '&oline;', 'desc': "overline, spacing overscore"}, 
    \ {'nbr': 8260, 'sym': '/', 'ent': '&frasl;', 'desc': "fraction slash"}, 
    \ {'nbr': 8364, 'sym': '€', 'ent': '&euro;', 'desc': "euro sign"}, 
    \ {'nbr': 8465, 'sym': 'I', 'ent': '&image;', 'desc': "blackletter capital I, imaginary part"}, 
    \ {'nbr': 8472, 'sym': 'P', 'ent': '&weierp;', 'desc': "scrpt cap P, power set, Weierstrass p"}, 
    \ {'nbr': 8476, 'sym': 'R', 'ent': '&real;', 'desc': "blackletter cap. R, real part symbol"}, 
    \ {'nbr': 8482, 'sym': '™', 'ent': '&trade;', 'desc': "trade mark sign"}, 
    \ {'nbr': 8501, 'sym': '?', 'ent': '&alefsym;', 'desc': "alef sym., first transfinite cardinal"}, 
    \ {'nbr': 8592, 'sym': '?', 'ent': '&larr;', 'desc': "leftwards arrow"}, 
    \ {'nbr': 8593, 'sym': '?', 'ent': '&uarr;', 'desc': "upwards arrow"}, 
    \ {'nbr': 8594, 'sym': '?', 'ent': '&rarr;', 'desc': "rightwards arrow"}, 
    \ {'nbr': 8595, 'sym': '?', 'ent': '&darr;', 'desc': "downwards arrow"}, 
    \ {'nbr': 8596, 'sym': '?', 'ent': '&harr;', 'desc': "left right arrow"}, 
    \ {'nbr': 8629, 'sym': '?', 'ent': '&crarr;', 'desc': "down-and-leftwards arrow, CR symbol"}, 
    \ {'nbr': 8656, 'sym': '?', 'ent': '&lArr;', 'desc': "leftwards double arrow"}, 
    \ {'nbr': 8657, 'sym': '?', 'ent': '&uArr;', 'desc': "upwards double arrow"}, 
    \ {'nbr': 8658, 'sym': '?', 'ent': '&rArr;', 'desc': "rightwards double arrow"}, 
    \ {'nbr': 8659, 'sym': '?', 'ent': '&dArr;', 'desc': "downwards double arrow"}, 
    \ {'nbr': 8660, 'sym': '?', 'ent': '&hArr;', 'desc': "left right double arrow"}, 
    \ {'nbr': 8704, 'sym': '?', 'ent': '&forall;', 'desc': "for all"}, 
    \ {'nbr': 8706, 'sym': '?', 'ent': '&part;', 'desc': "partial differential"}, 
    \ {'nbr': 8707, 'sym': '?', 'ent': '&exist;', 'desc': "there exists"}, 
    \ {'nbr': 8709, 'sym': 'Ø', 'ent': '&empty;', 'desc': "empty set, null set, diameter"}, 
    \ {'nbr': 8711, 'sym': '?', 'ent': '&nabla;', 'desc': "nabla, backward difference"}, 
    \ {'nbr': 8712, 'sym': '?', 'ent': '&isin;', 'desc': "element of"}, 
    \ {'nbr': 8713, 'sym': '?', 'ent': '&notin;', 'desc': "not an element of"}, 
    \ {'nbr': 8715, 'sym': '?', 'ent': '&ni;', 'desc': "contains as member"}, 
    \ {'nbr': 8719, 'sym': '?', 'ent': '&prod;', 'desc': "n-ary product, product sign"}, 
    \ {'nbr': 8721, 'sym': '?', 'ent': '&sum;', 'desc': "n-ary sumation"}, 
    \ {'nbr': 8722, 'sym': '-', 'ent': '&minus;', 'desc': "minus sign"}, 
    \ {'nbr': 8727, 'sym': '*', 'ent': '&lowast;', 'desc': "asterisk operator"}, 
    \ {'nbr': 8730, 'sym': 'v', 'ent': '&radic;', 'desc': "square root, radical sign"}, 
    \ {'nbr': 8733, 'sym': '?', 'ent': '&prop;', 'desc': "proportional to"}, 
    \ {'nbr': 8734, 'sym': '8', 'ent': '&infin;', 'desc': "infinity"}, 
    \ {'nbr': 8736, 'sym': '?', 'ent': '&ang;', 'desc': "angle"}, 
    \ {'nbr': 8743, 'sym': '?', 'ent': '&and;', 'desc': "logical and, wedge"}, 
    \ {'nbr': 8744, 'sym': '?', 'ent': '&or;', 'desc': "logical or, vee"}, 
    \ {'nbr': 8745, 'sym': 'n', 'ent': '&cap;', 'desc': "intersection, cap"}, 
    \ {'nbr': 8746, 'sym': '?', 'ent': '&cup;', 'desc': "union, cup"}, 
    \ {'nbr': 8747, 'sym': '?', 'ent': '&int;', 'desc': "integral"}, 
    \ {'nbr': 8756, 'sym': '?', 'ent': '&there4;', 'desc': "therefore"}, 
    \ {'nbr': 8764, 'sym': '~', 'ent': '&sim;', 'desc': "tilde operator, varies w/, similar to"}, 
    \ {'nbr': 8773, 'sym': '?', 'ent': '&cong;', 'desc': "approximately equal to"}, 
    \ {'nbr': 8776, 'sym': '˜', 'ent': '&asymp;', 'desc': "almost equal to, asymptotic to"}, 
    \ {'nbr': 8800, 'sym': '?', 'ent': '&ne;', 'desc': "not equal to"}, 
    \ {'nbr': 8801, 'sym': '=', 'ent': '&equiv;', 'desc': "identical to"}, 
    \ {'nbr': 8804, 'sym': '=', 'ent': '&le;', 'desc': "less-than or equal to"}, 
    \ {'nbr': 8805, 'sym': '=', 'ent': '&ge;', 'desc': "greater-than or equal to"}, 
    \ {'nbr': 8834, 'sym': '?', 'ent': '&sub;', 'desc': "subset of"}, 
    \ {'nbr': 8835, 'sym': '?', 'ent': '&sup;', 'desc': "superset of"}, 
    \ {'nbr': 8836, 'sym': '?', 'ent': '&nsub;', 'desc': "not a subset of"}, 
    \ {'nbr': 8838, 'sym': '?', 'ent': '&sube;', 'desc': "subset of or equal to"}, 
    \ {'nbr': 8839, 'sym': '?', 'ent': '&supe;', 'desc': "superset of or equal to"}, 
    \ {'nbr': 8853, 'sym': '?', 'ent': '&oplus;', 'desc': "circled plus, direct sum"}, 
    \ {'nbr': 8855, 'sym': '?', 'ent': '&otimes;', 'desc': "circled times, vector product"}, 
    \ {'nbr': 8869, 'sym': '?', 'ent': '&perp;', 'desc': "up tack, orthogonal to, perpendicular"}, 
    \ {'nbr': 8901, 'sym': '·', 'ent': '&sdot;', 'desc': "dot operator"}, 
    \ {'nbr': 8968, 'sym': '?', 'ent': '&lceil;', 'desc': "left ceiling, apl upstile"}, 
    \ {'nbr': 8969, 'sym': '?', 'ent': '&rceil;', 'desc': "right ceiling"}, 
    \ {'nbr': 8970, 'sym': '?', 'ent': '&lfloor;', 'desc': "left floor, apl downstile"}, 
    \ {'nbr': 8971, 'sym': '?', 'ent': '&rfloor;', 'desc': "right floor"}, 
    \ {'nbr': 9001, 'sym': '<', 'ent': '&lang;', 'desc': "left-pointing angle bracket, bra"}, 
    \ {'nbr': 9002, 'sym': '>', 'ent': '&rang;', 'desc': "right-pointing angle bracket, ket"}, 
    \ {'nbr': 9674, 'sym': '?', 'ent': '&loz;', 'desc': "lozenge"}, 
    \ {'nbr': 9824, 'sym': '?', 'ent': '&spades;', 'desc': "black spade suit"}, 
    \ {'nbr': 9827, 'sym': '?', 'ent': '&clubs;', 'desc': "black club suit, shamrock"}, 
    \ {'nbr': 9829, 'sym': '?', 'ent': '&hearts;', 'desc': "black heart suit, valentine"}, 
    \ {'nbr': 9830, 'sym': '?', 'ent': '&diams;', 'desc': "black diamond suit"}, 
    \ {'nbr': 10004, 'sym': '?', 'ent': '', 'desc': "check mark"}, 
    \ {'nbr': 146, 'sym': '’', 'ent': '', 'desc': "non-standard: use &#8217; instead" . lineWrapSpace . "(right single quotation mark)"}, 
    \ {'nbr': 150, 'sym': '–', 'ent': '', 'desc': "non-standard: use &#8211; instead" . lineWrapSpace . "(en dash)"}, 
    \ {'nbr': 151, 'sym': '—', 'ent': '', 'desc': "non-standard: use &#8212; instead" . lineWrapSpace . "(em dash)"}, 
    \ ] 

  return HctLookup

endfunction

" ------------------------------------------
" ----------------------------------- EOF --

