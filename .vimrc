syntax enable
set hidden
set history=100
set number
set incsearch
set hlsearch
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set cursorline
set cursorcolumn
set wrap
set nocompatible
set t_Co=256
set timeout timeoutlen=5000 ttimeoutlen=100
set wildmenu
set relativenumber
set colorcolumn=100

" display only filename
set wmh=0

" keep formatting when pasting text 
set pastetoggle=<F3>

" natural moving of the cursor (not jumping around on wrapped line)
nnoremap j gj
nnoremap k gk

" easy navigation between windows, ctrl + j instead of ctrl+w+j
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

highlight ColorColumn ctermbg=235 guibg=#2c2d27

" different background at 120 chars
let &colorcolumn="80,".join(range(120,999),",")

hi Cursor guifg=white guibg=black

let g:indent_guides_auto_colors = 1

call plug#begin()
Plug 'scwood/vim-hybrid'
call plug#end()
set background=dark

colorscheme hybrid
filetype indent plugin on
"hi CursorLine cterm=none ctermbg=Black
"hi CursorColumn cterm=none ctermbg=Black
"

nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>
map <Enter> o<ESC>

" control + o, add one line at the top
map <C-o> O<ESC>j

" control + p, add one line at the bottom
map <C-p> o<ESC>k

noremap <silent> <c-a> :nohls<cr><c-a>
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

"open nerd tree"
map <F2> :NERDTreeToggle<CR>

"F8 runs go code"
map <F8> :exec '!go run' shellescape(@%,1)<CR>
execute pathogen#infect()

"F7 builds go code
map <F7> :exec '!go build' shellescape(@%,1)<CR>

"tab = 4 visually in go
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

" autoclosing brackets - see vim wikia for more
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Vim plugin for showing matching html tags.
" Maintainer:  Greg Sexton <gregsexton@gmail.com>
" Credits: Bram Moolenar and the 'matchparen' plugin from which this draws heavily.

if exists("b:did_ftplugin")
    finish
endif

augroup matchhtmlparen
  autocmd! CursorMoved,CursorMovedI,WinEnter <buffer> call s:Highlight_Matching_Pair()
augroup END

fu! s:Highlight_Matching_Pair()
    " Remove any previous match.
    if exists('w:tag_hl_on') && w:tag_hl_on
        2match none
        let w:tag_hl_on = 0
    endif

    " Avoid that we remove the popup menu.
    " Return when there are no colors (looks like the cursor jumps).
    if pumvisible() || (&t_Co < 8 && !has("gui_running"))
        return
    endif

    "get html tag under cursor
    let tagname = s:GetCurrentCursorTag()
    if tagname == ""|return|endif

    if tagname[0] == '/'
        let position = s:SearchForMatchingTag(tagname[1:], 0)
    else
        let position = s:SearchForMatchingTag(tagname, 1)
    endif
    call s:HighlightTagAtPosition(position)
endfu

fu! s:GetCurrentCursorTag()
    "returns the tag under the cursor, includes the '/' if on a closing tag.

    let c_col  = col('.')
    let matched = matchstr(getline('.'), '\(<[^<>]*\%'.c_col.'c.\{-}>\)\|\(\%'.c_col.'c<.\{-}>\)')
    if matched == "" || matched =~ '/>$'
        return ""
    endif

    let tagname = matchstr(matched, '<\zs.\{-}\ze[ >]')
    return tagname
endfu

fu! s:SearchForMatchingTag(tagname, forwards)
    "returns the position of a matching tag or [0 0]

    let starttag = '<'.a:tagname.'.\{-}/\@<!>'
    let midtag = ''
    let endtag = '</'.a:tagname.'.\{-}'.(a:forwards?'':'\zs').'>'
    let flags = 'nW'.(a:forwards?'':'b')

    " When not in a string or comment ignore matches inside them.
    let skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
                \ '=~?  "htmlString\\|htmlCommentPart"'
    execute 'if' skip '| let skip = 0 | endif'

    " Limit the search to lines visible in the window.
    let stopline = a:forwards ? line('w$') : line('w0')
    let timeout = 300

    " The searchpairpos() timeout parameter was added in 7.2
    if v:version >= 702
      return searchpairpos(starttag, midtag, endtag, flags, skip, stopline, timeout)
    else
      return searchpairpos(starttag, midtag, endtag, flags, skip, stopline)
    endif
endfu

fu! s:HighlightTagAtPosition(position)
    if a:position == [0, 0]
        return
    endif

    let [m_lnum, m_col] = a:position
    exe '2match MatchParen /\(\%' . m_lnum . 'l\%' . m_col .  'c<\zs.\{-}\ze[ >]\)\|'
                \ .'\(\%' . line('.') . 'l\%' . col('.') .  'c<\zs.\{-}\ze[ >]\)\|'
                \ .'\(\%' . line('.') . 'l<\zs[^<> ]*\%' . col('.') . 'c.\{-}\ze[ >]\)\|'
                \ .'\(\%' . line('.') . 'l<\zs[^<>]\{-}\ze\s[^<>]*\%' . col('.') . 'c.\{-}>\)/'
    let w:tag_hl_on = 1
endfu
