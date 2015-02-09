" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2014 Feb 05
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
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
  autocmd FileType text setlocal textwidth=78

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
set softtabstop =4 "Sets the number of columns for a tab

"Add newlines and stay in normal mode
nnoremap <silent> <C-j> o<Esc>
nnoremap <silent> <C-k> O<Esc>

"Pulled from internet
set scrolloff=2 "Top cursor position is 2 lines from top/bottom of screen

"Going to next search result centers on the line the result is in
map N Nzz
map n nzz

"Swap : and ; (to eliminate pressing shift to enter ex commands)
nnoremap ; :
nnoremap : ;

"Highlight the current line (dark grey)
set cul
hi CursorLine term=none cterm=none ctermbg=233

"Place backups and temp files in their own directory
set backup
set backupdir=~/.vim//backup "extra slash saves full path name with % for /
set directory=~/.vim//tmp "extra slash saves full path name with % for /
set undodir=~/.vim/undo

set hidden "Hide buffers instead of closing them
set undolevels=1000 "Allow 1000 levels of undo
set title "Change the terminal's title

"Clear current search with ,/
nnoremap <silent> ,/ :nohlsearch<CR> 

function MyTabLine()
	  let s = ''
	  for i in range(tabpagenr('$'))
		let file = ''
	    " select the highlighting
	    if i + 1 == tabpagenr()
	      let s .= '%#TabLineSel#'
	    else
	      let s .= '%#TabLine#'
	    endif

	    " set the tab page number (for mouse clicks)
	    let s .= '%' . (i + 1) . 'T'

		let file .= bufname(tabpagebuflist(i+1)[tabpagewinnr(i) - 1])  "Gets file name
		let file = fnamemodify(file,":t") "File basename only

		"<index>:<filename>[modified] | <index>:<2ndfilename>[modified] etc
		if i + 1 == tabpagenr('$')
			"No pipe after final tab name
			let s .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#TabLine#' 
		else
			let s .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#TabLine# | ' 
		endif
		"let s .= (i + 1) . ':' . file . (getbufvar(file, "&mod")?'*':'') . '%#Normal# | ' 
		
	  endfor

	  " after the last tab fill with TabLineFill 
	  let s .= '%#TabLine#%T'
	  "let s .= '%#TabLineFill#%T'

	  return s
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
 au BufReadCmd *.jar,*.war,*.ear,*.sar,*.rar,*.tar,*.sublime-package,*.xpi call zip#Browse(expand("<amatch>"))

 "Enable line numbers by default
 set nu
