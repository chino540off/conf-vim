"
" Vars
"
let my_name = "Olivier Detour"					" name 
let my_email = "detour.olivier@gmail.com"			" email

"
" General
"
set nocompatible						" no vi-compatible mode
filetype on							" detect the ype of the file
filetype plugin on						" load filetypes plugin
set history=500							" history
set cf								" enable error files and erro jumping

"
" Backup
"
set backup							" enable backup
set backupdir=~/.vim/backup					" backup files
set directory=~/.vim/temp					" temp files
set makeef=error.err						" error files

"
" Vim UI
"
set lsp=0
set wildmenu							" display list for completion mode
set wildchar=<Tab>
set wildmode=longest,list

set ruler							" display cursor position
set cmdheight=2							" command line uses 2 screen line
set number							" display line numbers
set lz								" do not redraw while running macro
set showcmd							" display the current command
set backspace=indent,eol,start					" enable a nice backspace
set whichwrap=<,>,[,],b,s,h,l					" enable keys to move cursor
set mouse=a							" enable mouse uses everywhere
set shortmess=atI						" shortens messages
set report=0							" report anything
set noerrorbells						" no beep

"
" Visual
"
syntax on							" enable syntax highlighting
set showmatch							" show matching brackets
set mat=5							" show matching brackets for 5 tenth of secs
"set nohlsearch							" no highlight for searched phrases
set incsearch							" display matching pattern as typing
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$	" :set list
set so=5							" keep 10 lines for scope
set novisualbell						" do not blink
set t_Co=256
if has("gui_running")
	set guioptions-=m					" no menu bar
	set guioptions-=T					" no toolbar
	set guioptions-=r					" no right-hand scrollbar
	set guioptions-=L					" no left-hand scrollbar
	set hlsearch						" highlight search matches
endif

"
" Text formatting
"
"set fo=tcrqn
"set autoindent							" autoindent
"set smartindent							" smartindent
"set cindent							" c-style indenting
set tabstop=8
"set softtabstop=4
set shiftwidth=2
set expandtab
"set nowrap
"set smarttab
set cindent
set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
set shiftwidth=2
set softtabstop=2
set fo-=ro fo+=cql
set fileencoding=utf8
set encoding=utf8
set gfn=Mono\ 8

"
" Folding
"
set foldenable							" enable folding
set foldmethod=indent
set foldlevel=0
set foldopen-=search
set foldopen-=undo

"
" Misc
"
set wig=*.o
let c_space_errors=1

"
" Autocmd
"
if has("autocmd")
	" jump to the  last known cursor position
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\	exe "normal g`\"" |
				\ endif
endif

"
" file headers
"
aug coding
	au!

	au BufNewFile	{M,m}akefile		call MakefileNew(		'###',  '##', '##', '###')
	au BufNewFile	*.c{,c,++,pp,xx}	call HeaderNew("c",		'/**',  ' *', '**', ' */')
	au BufNewFile	*.h{,h,++,pp,xx}	call HeaderNew('h',		'/**',  ' *', '**', ' */')
	au BufNewFile	index.{html,php}	call HeaderNew('index',		'<!--', '--', '--', '-->')
aug END

function Replace(cs, cm, cd, ce)
	execute "% s,@CS@," . a:cs . ",ge"
	execute "% s,@CM@," . a:cm . ",ge"
	execute "% s,@CD@," . a:cd . ",ge"
	execute "% s,@CE@," . a:ce . ",ge"
	execute "% s,@DATE-STAMP@," . strftime("%c") . ",ge"
	execute "% s,@FILE-NAME@," . expand('%:t') . ",ge"
	execute "% s,@FILE-HEADER@," . substitute(substitute(expand('%:t'), "\\.c", "\\.h", "g"), "\\.hc", "\\.hh", "g") . ",ge"
	execute "% s,@LARGE-FILE-NAME@," . substitute(toupper(expand('%:t')), "\\.", "_", "g") . ",ge"
	execute "% s,@PART@," . expand("%:p:h:t") . ",ge"
	execute "% s,@PROJECT@," . expand("%:p:h:t") . ",ge"
	execute "% s,@USER-LOGIN@," . g:my_name . ",ge"
	execute "% s,@EMAIL@," . g:my_email . ",ge"
endfun

function HeaderNew(type, cs, cm, cd, ce)
	let header = confirm("Add header?", "&None\n&Thales\n&Epita\n&Default")

	if header == 2
		exec "0r ~/.vim/skel/thales.tpl"
		exec "22r ~/.vim/skel/" . a:type . ".tpl"
	endif
	if header == 3
		exec "0r ~/.vim/skel/epita.tpl"
		exec "10r ~/.vim/skel/" . a:type. ".tpl"
	endif
	if header == 4
		exec "0r ~/.vim/skel/" . a:type. ".tpl"
	endif
	if header >= 2
		call Replace(a:cs, a:cm, a:cd, a:ce)
		normal 2G3W
	endif
endfun

function MakefileNew(cs, cm, cd, ce)
	let type = confirm("Which Makefile?", "&None\n&User\n&Kernel")

	if type == 2
	       call HeaderNew('uMakefile', a:cs, a:cm, a:cd, a:ce)
	endif
	if type == 3
	       call HeaderNew('kMakefile', a:cs, a:cm, a:cd, a:ce)
	endif
endfun

function HeaderWWWNew()
	let header = confirm("Use default structure?", "&Yes\n&No")
	if header == 1
		exec "0r ~/.vim/skel/index.tpl"
		call Replace('<!--', ' -', '--', ' -->')
		normal 2G3W
	endif
endfun

" Move into splits
map <SPACE><up> <C-w><up>
map <SPACE><down> <C-w><down>
map <SPACE><right> <C-w><right>
map <SPACE><left> <C-w><left>

" Menu
set mousemodel=popup
set wildmenu

" Spell Mapping
let SpellActivity = "off"

function ChangeSpellActivity()
	if (g:SpellActivity == "off")						" change to french spelling
		let g:SpellActivity = "fr"
		setlocal spell spelllang=fr
		echo "Spelling on in French"
	elseif (g:SpellActivity == "fr")					" change to english us spelling
		let g:SpellActivity = "us"
		setlocal spell spelllang=en_us
		echo "Spelling on in English"
	else									" switch off spelling
		let g:SpellActivity = "off"
		setlocal nospell
		echo "Spelling off"
	endif
endfunction

set spellsuggest=8
map <F2> :call ChangeSpellActivity()<CR>
map <F3> z=

hi SpellBad	ctermbg=Blue	ctermfg=Black guifg=Blue cterm=underline gui=underline term=reverse
hi SpellCap	ctermbg=Green	ctermfg=Black guifg=Blue cterm=underline gui=underline term=reverse
hi SpellRare	ctermbg=Yellow	ctermfg=Black guifg=Blue cterm=underline gui=underline term=reverse
hi SpellLocal	ctermbg=Red	ctermfg=Black guifg=Blue cterm=underline gui=underline term=reverse

set nocompatible								" be iMproved
filetype off									" required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" required!: let Vundle manage Vundle
Bundle 'VundleVim/Vundle.vim'

" C/C++/C#/Objective-C/Objective-C++ Completion
Bundle 'Valloric/YouCompleteMe'
let g:ycm_key_list_select_completion = ['<Enter>', '<Down>']
" Remove preview window
set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0
let g:ycm_collect_identifiers_from_tags_files=1

nmap <Space>d :YcmCompleter GoTo<CR><CR>

" DoxygenToolkit
Bundle 'vim-scripts/DoxygenToolkit.vim'
let g:load_doxygen_syntax=1
nmap <SPACE>D :Dox<CR>


" BufExplorer
Bundle 'jlanzarotta/bufexplorer'
nmap <silent> <unique> <SPACE>o :BufExplorer<CR>

" Molokai theme
Bundle 'tomasr/molokai'
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

" Awesome Git plugin
Bundle 'tpope/vim-fugitive'

Bundle 'vim-scripts/Conque-GDB'
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly

" Robotframework syntax
Bundle 'mfukar/robotframework-vim'

" Ardiuno Synthax
Bundle 'sudar/vim-arduino-syntax'

" SnipMate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"
"imap <C-J>	<Plug>snipMateNextOrTrigger

" Syntastic
Bundle "scrooloose/syntastic"

" PlantUML syntax
Bundle "aklt/plantuml-syntax"
" Groovy syntax
Bundle "vim-scripts/groovy.vim"
" Flex/Bison syntax
Bundle "justinmk/vim-syntax-extra"
" Dockerfile syntax
Bundle 'ekalinin/Dockerfile.vim'

" Notes
Bundle "xolox/vim-misc"
Bundle "xolox/vim-notes"
let g:notes_directories = [ '~/work/notes' ]

Bundle "bling/vim-airline"
Bundle 'vim-airline/vim-airline-themes'
set laststatus=2
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_theme='molokai'

" rust syntax
Bundle 'rust-lang/rust.vim'

" extend c++ syntax
Bundle 'octol/vim-cpp-enhanced-highlight'
let g:cpp_concepts_highlight = 1

filetype plugin indent on							" required!
