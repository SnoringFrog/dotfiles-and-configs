" Sorry this is such a mess. I'll get around to organizing it one day.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'dag/vim-fish' " Syntax highlighting and other tweaks for .fish files
Plugin 'dahu/vim-fanfingtastic' " Allow F, f, T, t, ; commands to wrap over lines
Plugin 'kana/vim-textobj-user' " Simpler user created text objects
Plugin 'rbonvall/vim-textobj-latex' " LaTeX text objects; requires kana/vim-textobj-user
Plugin 'scrooloose/nerdcommenter' " Simpler commenting
Plugin 'gregsexton/MatchTag' " Highlights matching HTMl/XML tags when cursor is on a tag
Plugin 'jiangmiao/auto-pairs' " Automatically insert matching (), {}, etc.
Plugin 'mhinz/vim-startify' "Vim splash screen showing recently edited files

" Vim scripts
Plugin 'vim-scripts/matchparenpp' " Echo line of matching (), {}, etc
Plugin 'vim-scripts/AutoComplPop' " Autocomplete popup suggestions

call vundle#end()
filetype plugin indent on


" Vim needs a more POSIX compatible shell, fish is not one
if &shell =~# 'fish$'
	set shell=sh
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
"set rulerformat=%l/%L,%c%V%=%P
set rulerformat=%l/%L,%c%V%=%P           " position
set showcmd		" display incomplete commands
set showmode	" Show current mode
set incsearch		" do incremental searching
			
" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make ctrl-U, ctrl-u, and ctrl-w undoable
inoremap <C-U> <C-G>u<C-U>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<c-w>

" In many terminal emulators the mouse works just fine, thus enable it.
" n = Normal mode
" v = Visual mode
" i = Insert mode
" c = Command Line mode
" h = all of the above (when editing a help file)
" a = all of the above
" r = left-click works for 'press enter' type prompts
if has('mouse')
  "set mouse=vic " Stops clicking window to regain focus from moving cursor most of the time
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		"autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		" Also don't do it when the mark is in the first line, that is the default
		" position when opening a file.

		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

	augroup END

else
	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
		
"Personal additions
"Fixing tab width
set tabstop=4 "The width of a tab is 4
set shiftwidth=4 "Indents will have a width of 4
set shiftround " > and < round to multiples of shiftwidth
set softtabstop =4 "Sets the number of columns for a tab

"Add newlines and stay in normal mode
nnoremap <silent> <C-j> o<Esc>
nnoremap <silent> <C-k> O<Esc>

"Pulled from internet
set scrolloff=2 "Top cursor position is 2 lines from top/bottom of screen

"Clear current search with ,/
nnoremap <silent> ,/ :nohlsearch<CR> 

"Going to next search result centers on the line the result is in
noremap N Nzz
noremap n nzz

"Ignore case when searching unless capital letters are used
set ignorecase
set smartcase

"Swap : and ; (to eliminate pressing shift to enter ex commands)
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Highlight the current line (dark grey)
set cul
hi CursorLine term=none cterm=none ctermbg=233

"Place backups and temp files in their own directory
set backup
set backupdir=~/.vim//backup "extra slash saves full path name with % for /
set directory=~/.vim//tmp "extra slash saves full path name with % for /
set viewdir=~/.vim//view 
set undodir=~/.vim/undo

set hidden "Hide buffers instead of closing them
set undolevels=2500 "Allow more levels of undo
set title "Change the terminal's title

set splitright "when splitting horizontally, put new window on right
set splitbelow "when splitting vertically, put new window below current window 

if has('statusline')
	if version >= 700
		" Fancy status line.
		set statusline =
		set statusline+=%n								   " buffer number
		set statusline+=%{'/'.len(filter(range(1,bufnr('$')),'buflisted(v:val)'))} " open/listed buffers
		set statusline+=%{'/'.bufnr('$')}\                 " total buffers
		set statusline+=%f%m\                              " file name and modified flag
		set statusline+=(%{strlen(&ft)?&ft:'none'})		   " file type
		set statusline+=%=								   " indent right
		set statusline+=U+%04B\                            " Unicode char under cursor
		set statusline+=%-6.(%l/%{line('$')},%c%V%)\ %<%P  " position
	endif
endif

"hi StatusLine term=none, cterm=none, gui=none 
hi StatusLine term=none, cterm=undercurl, gui=none 
set laststatus=2

function MyTabLine()
	let tabstring = ''
	for i in range(tabpagenr('$'))
		let file = ''
		" select the highlighting
		if i + 1 == tabpagenr()
			let tabstring .= '%#TabLineSel#'
		else
			let tabstring .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let tabstring .= '%' . (i + 1) . 'T'

		let file .= bufname(tabpagebuflist(i+1)[tabpagewinnr(i) - 1])  "Gets file name
		let file = fnamemodify(file,":t") "File basename only

		"<index>:<filename>[modified] | <index>:<2ndfilename>[modified] etc
		if i + 1 == tabpagenr('$')
			"No pipe after final tab name
			let tabstring .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#TabLine#' 
		else
			let tabstring .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#TabLine# | ' 
		endif
		"let s .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#Normal# | ' 
	endfor

	" after the last tab fill with TabLineFill 
	let tabstring .= '%#TabLine#%T'
	"let s .= '%#TabLineFill#%T'

	return tabstring
endfunction

hi TabLine term=NONE cterm=NONE
hi TabLineSel ctermfg=White ctermbg=DarkGray
"hi TabLineFill term=NONE cterm=NONE
set tabline=%!MyTabLine()

" Tell vim to remember certain things when we exit
" For explanation run :help 'viminfo'
set viminfo='100,%,h

"Show spaces and tabs as middot and dagger (requires vim to be compiled with +conceal option)
"Might be nice to set this up to run automatically for Whitespace files
function ToggleWhitespace()
	if (&conceallevel == 0)
		syn match WhiteSpace / / containedin=ALL conceal cchar=·
		syn match WhiteSpace /	/ containedin=ALL conceal cchar=†
		setl conceallevel=2 concealcursor=nv
	else
		setl conceallevel=0
	endif
endfunction
command ToggleWhitespace call ToggleWhitespace()

filetype plugin on
set omnifunc=syntaxcomplete#Complete
autocmd FileType python set omnifunc=python3complete#Complete

"Treat these filetypes as zip 
"(.jar, .war removed because they were being opened twice per browser for some reason)
 au BufReadCmd *.ear,*.sar,*.rar,*.sublime-package,*.xpi call zip#Browse(expand("<amatch>"))

 "Enable line numbers by default
 set nu

"Press space in normal mode to toggle a fold; otherwise do default behavior
 nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

"In visual mode, space creates a fold
 vnoremap <Space> zf

"Make saving/restoring folds automatic
 au BufWritePost,BufLeave,WinLeave ?* mkview
 au BufWinEnter ?* silent loadview

 "Set matchpairs for commands like ci 
set mps+=<:>
au FileType c,cpp,java set mps+==:; "c-style var assignments

let mapleader=","
let maplocalleader="\\"

"Clear current line
nnoremap <leader>d O<Esc>jddk

"Comment out a line (uneeded now that I use NerdCommenter)
"augroup commentLineGroup
	"autocmd!
	"autocmd FileType javascript,c nnoremap <buffer> <leader>c I//<esc> 
	"autocmd FileType python,sh,ruby nnoremap <buffer> <leader>c I#<esc> 
	"autocmd FileType vim nnoremap <buffer> <leader>c I"<esc> 
"augroup END

"Change vim tabs
nnoremap <leader>n :tabn<cr>
nnoremap <leader>p :tabp<cr>

"Wrap a word in double quotes, single quotes, backticks, parens, brackets, braces
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>` viw<esc>a`<esc>hbi`<esc>lel
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>) viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>] viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader>} viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader><leader>} viw<esc>a{<esc>hbi}<esc>lel

augroup filetype_latex
   autocmd!
	"add Latex quotes to matching pair highlighting   
	au FileType tex,plaintex set mps+=`:' 

	"Wrap a word in Latex style quotes
	au FileType tex,plaintex nnoremap <leader>` viw<esc>a`<esc>hbi'<esc>lel

	"For autopairs plugin (disables backtick matching in favor of `')
	au FileType tex,plaintex let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"'"} 

	" Enable [y|d|c][a|q]['|"] for LaTeX quotes (Unecessary due to vim-textobject-latex plugin) 
	"au FileType tex,plaintex onoremap a' :<c-u>normal! muF`vf'<cr>`u
	"au FileType tex,plaintex onoremap i' :<c-u>normal! muT`vt'<cr>`u
	"au FileType tex,plaintex onoremap a" :<c-u>normal! mu2F`v2f'<cr>`u
	"au FileType tex,plaintex onoremap i" :<c-u>normal! mu2T`v2t'<cr>`u
augroup END "Latex

augroup filetype_vim
	autocmd!
	"Disable double quote pair completion from AutoPairs plugin
	au FileType vim let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'", "`":"`"} 
augroup END "Vim


" github.com/mathiasbynens/dotfiles
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure


function HasFolds()
	"Attempt to move between folds, checking line numbers to see if it worked.
	"If it did, there are folds.
	
	function! HasFoldsInner()
		let origline=line('.')	
		:norm zk
		if origline==line('.')
			:norm zj
			if origline==line('.')
				return 0
			else
				return 1
			endif
		else
			return 1
		endif
		return 0
	endfunction

	set visualbell t_vb= "disable error bell
	let l:winview=winsaveview() "save window and cursor position
	let foldsexist=HasFoldsInner()
	if foldsexist
		set foldcolumn=1
	else
		"Move to the end of the current fold and check again in case the
		"cursor was on the sole fold in the file when we checked
		if line('.')!=1
			:norm [z
			:norm k
		else
			:norm ]z
			:norm j
		endif
		let foldsexist=HasFoldsInner()
		if foldsexist
			set foldcolumn=1
		else
			set foldcolumn=0
		endif
	end
	call winrestview(l:winview) "restore window/cursor position
	set visualbell& t_vb& "return error bells to defaults
endfunction
au CursorHold,BufWinEnter ?* call HasFolds()

" Vim-Startify config
let g:startify_list_order = [
	\ ['   Recent files:'],
	\ 'files',
	\ ['   Recent files (this dir):'],
	\ 'dir',
	\ ['   Sessions:'],
	\ 'sessions',
	\ ['   Bookmarks:'],
	\ 'bookmarks',
	\ ]

let g:startify_bookmarks = ['~/.vimrc', '~/.bashrc', '~/.config/fish/config.fish']
let g:startify_custom_header = 
	\ map(split(system('figlet "vim-startify"'), '\n'), '"   ". v:val') + ['','']

let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ $VIMRUNTIME .'/doc',
	\ 'bundle/.*/doc',
	\ '\.DS_Store'
	\ ]

let g:startify_custom_indices = ['a', 'n', 'o']
" End Vim-Startify config

" Paste in paste mode (prevents crazy indent issues)
nnoremap <leader>p :set paste<CR>o<esc>"+]p:set nopaste<cr>

" Close current buffer
nnoremap <leader>b :bd<CR>

" Write all buffers
command W bufdo w

" Like windo but restore the current window.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Like bufdo but restore the current buffer.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Like tabdo but restore the current tab.
function! TabDo(command)
  let currTab=tabpagenr()
  execute 'tabdo ' . a:command
  execute 'tabn ' . currTab
endfunction
com! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" Insert blank line in normal mode
noremap <Enter> o<ESC>
noremap <S-Enter> O<ESC>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" uppercase / lowercase convert (LC/UC = first letter, lc/uc = whole word)
nmap <leader>LC mQgewvu`Q
nmap <leader>UC mQgewvU`Q
nmap <leader>lc mQviwu`Q
nmap <leader>uc mQviwU`Q 
