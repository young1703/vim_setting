" vim runtime configuration file
set hlsearch 
set ts=4
set sw=4
set nu
set paste
"set complete
set ai
set cindent
set smartindent
set expandtab
" setting for statusline
set laststatus=2 " 상태바 표시를 항상한다
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

" setting for Vundle
set rtp+=~/.vim/bundle/vundle/
 
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'Valloric/YouCompleteMe'

" setting for ctags
set tags=./tags

syntax enable
filetype on
filetype plugin on
colorscheme ron
filetype indent on
let Tlist_Auto_Open = 0
let Tlist_WinSize = 25

"setting for nerdtree
let g:NERDTreeDirArrows=0
let NERDTreeWinPos="right"
let NERDTreeWinSize=50

Plugin 'The-NERD-Tree'
Plugin 'taglist-plus'
Plugin 'cscope.vim'
Plugin 'SrcExpl.vim'
Plugin 'Conque-Shell'
"Plugin 'Powerline'
let mapleader=","

nmap <Leader>rc :rightbelow vnew $MYVIMRC<CR>
nmap <F7> :TlistToggle<CR>
nmap <F8> :SrcExplToggle<CR>
nmap <F9> :NERDTreeToggle<CR>
"nmap <C-F> :NERDTreeFind<CR>
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-q> <C-w>q
nmap <Leader>1 viw:Highlight 1<CR>
nmap <Leader>2 viw:Highlight 2<CR>
nmap <Leader>3 viw:Highlight 3<CR>
nmap <Leader>4 viw:Highlight 4<CR>
nmap <Leader>5 viw:Highlight 5<CR>
nmap <Leader>6 viw:Highlight 6<CR>
nmap <Leader>7 viw:Highlight 7<CR>
nmap <Leader>8 viw:Highlight 8<CR>
nmap <Leader>9 viw:Highlight 9<CR>
nmap <Leader>0 viw:Hclear <CR>
nmap <Leader>t :ConqueTermSplit bash<CR><esc><C-w>Ji
nmap zs <Leader>1 :cs find s <cword><CR>:botright :cw<CR>
vnoremap zf y/<c-r>"<CR>:vimgrep /<c-r>"/g **<CR><c-w>v:botright :cw<CR>

nnoremap zd :call SearchAllReferences()<CR>:vimgrep /<c-r>"/g **<CR><c-w>v:botright :cw<CR>

"nmap zg :.cc<CR>

nmap <C-m> :cn<CR>zz
nmap <C-n> :cp<CR>zz
nmap <C-b> :botright :cw<CR>

" cscope 설정
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
set cscopequickfix=s+,c+,d+,i+,t+,e+

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>


if filereadable("./cscope.out")
cs add cscope.out
endif
set csverb

"src expl
let g:SrcExpl_winHeight = 15

"you complete me
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_auto_trigger = 1
let g:ycm_collect_identifiers_from_tags_files = 1    " tags 파일을 사용합니다. 성능상 이익이 있는걸로 알고 있습니다.
let g:ycm_show_diagnostics_ui = 0

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction



" Dim inactive windows using 'colorcolumn' setting
" This tends to slow down redrawing, but is very useful.
" Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" XXX: this will only work with lines containing text (i.e. not '~')
" from 
if exists('+colorcolumn')
  function! s:DimInactiveWindows()
    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
      let l:range = ""
      if i != winnr()
        if &wrap
         " HACK: when wrapping lines is enabled, we use the maximum number
         " of columns getting highlighted. This might get calculated by
         " looking for the longest visible line and using a multiple of
         " winwidth().
         let l:width=256 " max
        else
         let l:width=winwidth(i)
        endif
        let l:range = join(range(1, l:width), ',')
      endif
      call setwinvar(i, '&colorcolumn', l:range)
    endfor
  endfunction
  augroup DimInactiveWindows
    au!
    au WinEnter * call s:DimInactiveWindows()
    au WinEnter * set cursorline
    au WinLeave * set nocursorline
  augroup END
endif


" 사용자의 입력을 받아서 레지스터에 저장 하는 함수=========
function! SearchAllReferences()
    call inputsave()
    let findtext = input('Enter text:')
    call inputrestore()
    let @@ = findtext
endfunction
"============================================================
