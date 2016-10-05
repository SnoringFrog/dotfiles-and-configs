" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let vundle_readme= $HOME . "/.vim/bundle/vundle/README.md"
if filereadable(vundle_readme)
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
	Plugin 'benmills/vimux' "Better vim/tmux interaction
	Plugin 'ktonga/vim-follow-my-lead' "Displays <Leader> mappings with descriptions with <leader>fml
	Plugin 'qpkorr/vim-bufkill' "Allow deleting a buffer while preserving splits
	Plugin 'ap/vim-css-color' "Highlight CSS colors with the color they represent
	Plugin 'mjbrownie/swapit' "C-a/C-x swap cycle like true/false yes/no
	Plugin 'luochen1990/rainbow' "Rainbow parentheses to differtiate nested levels
	let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

	" Vim scripts
	Plugin 'vim-scripts/matchparenpp' " Echo line of matching (), {}, etc
	Plugin 'vim-scripts/AutoComplPop' " Autocomplete popup suggestions
	Plugin 'vim-scripts/highlight.vim' " Highlight various lines with <C-h><C-h>

	call vundle#end()
endif
unlet vundle_readme

filetype plugin indent on

" === Leaders ===
let mapleader=","
let maplocalleader="\\"

" Just in case I wanted original , functionality
nnoremap <leader>, ,


" === Mappings with no category that might confuse people if they don't notice them ===
"Swap : and ; 
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" === Yank/Delete ===
" Y operates to end of line (like D and C)
noremap Y y$

" dl/yl operate like dd/yy, but they do not yank the newline
noremap dl ^D"_dd
noremap yl ^y$


if !has("autocmd")
	set autoindent
endif


" Switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif


" Vim needs a more POSIX compatible shell, fish is not one
if &shell =~# 'fish$'
	set shell=sh
endif


if !has('nvim')
	set backspace=indent,eol,start	"allow backspacing over everything in insert mode
	set history=10000	"keep x lines of command line history
	set hlsearch	"highlight last used search pattern
	set incsearch		" do incremental searching
	set wildmenu
	"set clipboard=unnamed

	"Use better encryption algorithm
	set cryptmethod=blowfish2

	" Enabling the mouse for:
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
endif


if has('nvim')
	"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif


" === Tabs width/settings ===
set tabstop=4 "The width of a tab is 4
set shiftwidth=4 "Indents will have a width of 4
set shiftround " > and < round to multiples of shiftwidth
set softtabstop =4 "Sets the number of columns for a tab


" === Searching ===
"Clear current search hilighting
nnoremap <silent> ,/ :nohlsearch<CR> 

"Going to next search result centers on the line the result is in
noremap N Nzz
noremap n nzz

"Ignore case when searching unless capital letters are used
set ignorecase
set smartcase


" === Misc basic settings=== 
set formatoptions=tcqnl " :help fo-table
set matchpairs+=<:> "Set matchpairs for commands like ci 
set hidden " Hide buffers instead of closing them when another buffer is opened
set omnifunc=syntaxcomplete#Complete " Enable autocompletion with <C-x><C-o>
set scrolloff=2 " Top cursor position is 2 lines from top/bottom of screen
set title " Change the terminal's title
set undolevels=2500 " Allow more levels of undo
set viewdir=~/.vim//view  " For saving folds
set whichwrap+=<,>,h,l,[,] " left/right movement wraps to next line
set wildmode=list,full

		
" === Backup options ===
if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	" TODO: make sure backupdir, directory, undodir and viewdir exist
	set backup		" keep a backup file (restore to previous version)
	set undofile		" keep an undo file (undo changes after closing)
	set backupdir=~/.vim//backup "extra slash saves full path name with % for /
	set directory=~/.vim//tmp "extra slash saves full path name with % for /
	set undodir=~/.vim/undo
endif

" Fix 'temp file must be edited in place' error with crontab
if $VIM_CRONTAB == "true"
	set nobackup
	set nowritebackup
endif


" Tell vim to remember certain things when we exit (:help 'viminfo')
" http://vimdoc.sourceforge.net/htmldoc/options.html#'viminfo'
set viminfo='100,%,h,f1,r/tmp,n~/.vim/viminfo
"           |    | | |  |     + viminfo file location
"           |    | | |  + do not save marks on this path
"           |    | | + storn file marks
"           |    | + disable the effect of 'hlsearch' when loading viminfo
"           |    + save/restore buffer list
"           + save marks for the last 100 files

augroup restoreCursorPos
	autocmd!
	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END


" === Line Numbers ===
"Show absolute line number for current line and relative line numbers otherwise
set number
set relativenumber


" === Displayed info/file status ===
set showcmd		" display incomplete commands
set showmode	" Show current mode

"Highlight the current line (dark grey)
set cursorline
hi CursorLine term=none cterm=none ctermbg=233

if has('statusline')
	if version >= 700
		" Fancy status line.
		set statusline =
		set statusline+=%n								   " buffer number
		set statusline+=%{'/'.len(filter(range(1,bufnr('$')),'buflisted(v:val)'))} " total open/listed buffers
		set statusline+=%{'/'.bufnr('$')}\                 " highest numbered buffer (includes unlisted)
		set statusline+=%f%m\                              " file name and modified flag
		set statusline+=(%{strlen(&ft)?&ft:'none'})		   " file type
		set statusline+=%=								   " indent right
		set statusline+=U+%04B\                            " Unicode char under cursor
		set statusline+=%-6.(%l/%{line('$')},%c%V%)\ %<%P  " position (line/col[-virtual-col (if diff from col)] percent)
	endif

	"hi StatusLine term=none, cterm=none, gui=none 
	hi StatusLine term=none, cterm=undercurl, gui=none 
	set laststatus=2
else
	" Use ruler instead of statusline
	set ruler		" show the cursor position all the time
	set rulerformat=%l/%L,%c%V%=%P " position (line/col[-virtual-col (if diff from col)] percent)
endif


" === Splits ===
set splitright "when splitting horizontally, put new window on right
set splitbelow "when splitting vertically, put new window below current window 

" Smart way to move between splits
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" === Folds ===
"Press space in normal mode to toggle a fold; otherwise do default behavior
 nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

"In visual mode, space creates a fold
 vnoremap <Space> zf

 augroup saveFolds
	 autocmd!
	 "Make saving/restoring folds automatic
	 au BufWritePost,BufLeave,WinLeave ?* silent! mkview
	 au BufWinEnter ?* silent! loadview
 augroup END "saveFolds
 
function! HasFolds()
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
augroup hasFolds
	autocmd!
	autocmd CursorHold,BufWinEnter ?* call HasFolds()
augroup END "hasFounds


" === Tabs ===
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

" Change tabs
nnoremap <leader>n :tabn<cr>
"nnoremap <leader>p :tabp<cr>


" === Buffers ===
" Close current buffer
nnoremap <leader>bd :bd<CR>
" Wipeout current buffer
nnoremap <leader>bw :bw<CR>
" Write all buffers
command W bufdo w


" === Movement ===
" emacs movement for insert/normal mode (from: https://github.com/rtomayko/dotfiles) and command line
noremap <C-e> $
noremap <C-a> 0

inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$

cnoremap <C-a> <Home>
cnoremap <C-e> <End>


"Clear current line
nnoremap <leader>d O<Esc>jddk

" Paste from clipboard in paste mode (prevents crazy indent issues)
nnoremap <leader>p :set paste<CR>o<esc>"+]p:set nopaste<cr>

" === Making newlines from normal mode ===
"Add newlines and stay in normal mode
nnoremap <silent> <C-j> o<Esc>
nnoremap <silent> <C-k> O<Esc>

" Insert blank line in normal mode
nnoremap <cr> o<ESC>
augroup enterNewline 
	autocmd!
	autocmd CmdwinEnter * nnoremap <CR> <CR>
	autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END "enterNewline


" === Commenting ===
" TODO: make thus run if Nerdcommenter isn't installed
"Comment out a line (uneeded now that I use NerdCommenter)
"augroup commentLineGroup
	"autocmd!
	"autocmd FileType javascript,c nnoremap <buffer> <leader>c I//<esc> 
	"autocmd FileType python,sh,ruby nnoremap <buffer> <leader>c I#<esc> 
	"autocmd FileType vim nnoremap <buffer> <leader>c I"<esc> 
"augroup END
"
"
" === Handling case ===
" Convert word to lowercase
nnoremap <leader>lc mqviwu`q
" Convert word to uppercase
nnoremap <leader>uc mqviwU`q 
" Uncapitalize word
nnoremap <leader>LC mqgewvu`q
" Capitalize word
nnoremap <leader>UC mqgewvU`q


" === Wrapping words with (),[], etc ===

" Wrap a word in double quotes, single quotes, backticks, parens, brackets, braces
" Uses a custom text object (requires kana/vim-textobj-user) to treat bash/php style $variables as a word
" <M-p> needed to toggle off vim-scripts/matchparenpp if enabled (otherwise marks get duplicated)
" AcpLock/AcpUnlock makes shortcut compatible with AutoComplPop
" Because of my ; -> : mapping, have to start Acp commands with ;

try
" define av/iv to select a bash variable: (vim-textobj-user)
call textobj#user#plugin('bash', {
        \  'avar': {
        \   'pattern': '\$\?\w\+\>',
        \   'select': [ 'aw'],
        \  },
        \  'var': {
        \   'pattern': ['\${', '}'],
        \   'select-i': [ 'iv'],
        \   'select-a': [ 'av'],
        \  },
        \ })

	" Wrap a word in double quotes (bash/php vars treated as word)
	nmap <leader>" ;AcpLock<CR><M-p>vaw<esc>`>a"<esc>`<i"<esc>f"<M-p>;AcpUnlock<CR>
	" Wrap a word in single quotes (bash/php vars treated as word)
	nmap <leader>' ;AcpLock<CR><M-p>vaw<esc>`>a'<esc>`<i'<esc>f'<M-p>;AcpUnlock<CR>
	" Wrap a word in backticks (bash/php vars treated as word)
	nmap <leader>` ;AcpLock<CR><M-p>vaw<esc>`>a`<esc>`<i`<esc>f`<M-p>;AcpUnlock<CR>
catch
	nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
	nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
	nnoremap <leader>` viw<esc>a`<esc>hbi`<esc>lel
endtry

" Not sure why I'm saving these still...need to find out
"nmap <leader>( vaw<esc>`>a)<esc>`<i(<esc>f)
"nmap <leader>) vaw<esc>`>a)<esc>`<i(<esc>f)
"nmap <leader>[ vaw<esc>`>a]<esc>`<i[<esc>f]
"nmap <leader>] vaw<esc>`>a]<esc>`<i[<esc>f]
"nmap <leader>{ vaw<esc>`>a}<esc>`<i{<esc>f}
"nmap <leader>} vaw<esc>`>a}<esc>`<i{<esc>f}

" Wrap a word in parentheses
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
" Wrap a word in parentheses
nnoremap <leader>) viw<esc>a)<esc>hbi(<esc>lel
" Wrap a word in brackets
nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
" Wrap a word in brackets
nnoremap <leader>] viw<esc>a]<esc>hbi[<esc>lel
" Wrap a word in braces
nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel
" Wrap a word in braces
nnoremap <leader>} viw<esc>a}<esc>hbi{<esc>lel

"For bash style variables ($var)
"nnoremap <leader>"" viw<esc>a"<esc>hbi"<esc>lelBxp 


" === Assorted Functions ===

"Show spaces and tabs as middot and dagger (requires vim to be compiled with +conceal option)
"Might be nice to set this up to run automatically for Whitespace files
function! ToggleWhitespace()
	if (&conceallevel == 0)
		syn match WhiteSpace / / containedin=ALL conceal cchar=·
		syn match WhiteSpace /	/ containedin=ALL conceal cchar=†
		setl conceallevel=2 concealcursor=nv
	else
		setl conceallevel=0
	endif
endfunction
command ToggleWhitespace call ToggleWhitespace()

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

augroup Mkdir
	" When saving file to dir that does not exist yet, create the directory
	autocmd!
	autocmd BufWritePre *
		\ if !isdirectory(expand("<afile>:p:h")) |
			\ call mkdir(expand("<afile>:p:h"), "p") |
		\ endif
augroup END


" === Plugin Configs ===

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
	\ map(split(system('figlet "vim-startify"'), '\n'), '"   ". v:val') + ['   Mark with [b] to open in buffer, [s] for split, [t] for tab.','']

let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ $VIMRUNTIME .'/doc',
	\ 'bundle/.*/doc',
	\ '\.DS_Store'
	\ ]

let g:startify_custom_indices = ['a', 'n', 'o'] " these only really make sense in Colemak
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1
" End Vim-Startify config

" vimux configs:
" Run arbitrary command in pane (vimux)
nnoremap <leader>rp :VimuxPromptCommand<cr> 
" Close runner pane (vimux)
nnoremap <leader>rq :VimuxCloseRunner<cr>
" Focus runner pane (in copy mode) (vimux)
nnoremap <leader>ri :VimuxInspectRunner<cr>
" End vimux configs


" === Filetype Specific (need to be moved to .vim/ftplugin) ===
"
augroup treatAsZip
	autocmd!
	"Treat these filetypes as zip 
	"(.jar, .war removed because they were being opened twice per browser for some reason)
	au BufReadCmd *.ear,*.sar,*.rar,*.sublime-package,*.xpi call zip#Browse(expand("<amatch>"))
augroup END

"Enable spellcheck for certain filetypes
augroup spellcheck
	autocmd!
	autocmd FileType gitcommit,gitrebase,ghmarkdown,markdown,txt,md set spell spelllang=en_us
augroup END

augroup matchPairs
	autocmd!
	au FileType c,cpp,java set mps+==:; "c-style var assignments
augroup END "matchPairs
 
augroup filetype_latex
   autocmd!
	"add Latex quotes to matching pair highlighting   
	autocmd FileType tex,plaintex set mps+=`:' 

	"Wrap a word in Latex style quotes
	autocmd FileType tex,plaintex nnoremap <leader>` viw<esc>a`<esc>hbi'<esc>lel

	"For autopairs plugin (disables backtick matching in favor of `')
	autocmd FileType tex,plaintex let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"'"} 

	" Enable [y|d|c][a|q]['|"] for LaTeX quotes (Unecessary due to vim-textobject-latex plugin) 
	"autocmd FileType tex,plaintex onoremap a' :<c-u>normal! muF`vf'<cr>`u
	"autocmd FileType tex,plaintex onoremap i' :<c-u>normal! muT`vt'<cr>`u
	"autocmd FileType tex,plaintex onoremap a" :<c-u>normal! mu2F`v2f'<cr>`u
	"autocmd FileType tex,plaintex onoremap i" :<c-u>normal! mu2T`v2t'<cr>`u
augroup END "Latex

augroup filetype_vim
	autocmd!
	"Disable double quote pair completion from AutoPairs plugin
	autocmd FileType vim let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'", "`":"`"} 
augroup END "Vim

augroup filetype_markdown
	autocmd!
	" Operator pending mappings to delete in/around headers
	autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-]\\{2,}$\r:nohlsearch\rkvg_"<cr>
	autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-]\\{2,}$\r:nohlsearch\rg_vk0"<cr>
augroup END "Markdown

augroup pythonAutoComplete
	autocmd!
	autocmd FileType python set omnifunc=pythoncomplete#Complete
augroup END "pythonAutoComplete

augroup labyrinth
	autocmd!
	autocmd FileType labyrinth let b:AutoPairs = {}
augroup END

" === External .vimrc files ===
" q-free specific vimrc
let vimrc_qfree = $HOME . "/.vimrc.d/.vimrc-qfree"
if filereadable(vimrc_qfree)
	execute "source" . vimrc_qfree
endif
unlet vimrc_qfree
