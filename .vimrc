if has("syntax")
	syntax on
endif

"-----------------------------------------------------------------------"
" 기본 설정
"-----------------------------------------------------------------------"
set number    " line 표시
set ai    " auto indent
set si " smart indent
set cindent    " c style indent
set shiftwidth=4    " 자동 공백 채움 시 4칸
set tabstop=4    " tab을 4칸 공백으로
set ignorecase    " 검색 시 대소문자 무시
set hlsearch    " 검색 시 하이라이트
set nocompatible    " 방향키로 이동 가능
set fileencodings=utf-8,euc-kr    " 파일 저장 인코딩 : utf-8, euc-kr
set fencs=ucs-bom,utf-8,euc-kr    " 한글 파일은 euc-kr, 유니코드는 유니코드
set bs=indent,eol,start    " backspace 사용가능
set ruler    " 상태 표시줄에 커서 위치 표시
set title    " 제목 표시
set showmatch    " 다른 코딩 프로그램처럼 매칭되는 괄호 보여줌
set wmnu    " tab 을 눌렀을 때 자동완성 가능한 목록
set mouse=a
set ttymouse=sgr
set encoding=utf-8

"-----------------------------------------------------------------------"
" Vundle 설정
"-----------------------------------------------------------------------"
if empty(glob('~/.vim/bundle/Vundle.vim'))
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  autocmd VimEnter * ++once PluginInstall
endif

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'				" VIM 플러그인 관리 플러그인

Plugin 'ctrlpvim/ctrlp.vim'				" 하위 디렉토리 파일 찾기
Plugin 'chrisbra/NrrwRgn'				" 라인 범위 지정 후 수정
Plugin 'MultipleSearch'					" 여러 문자열 동시에 강조
Plugin 'terryma/vim-multiple-cursors'			" 여러 커서에서 동시 수정
Plugin 'vim-syntastic/syntastic'			" 구문 체크
Plugin 'airblade/vim-gitgutter'				" Git으로 관리하는 파일의 변경된 부분을 확인
Plugin 'scrooloose/nerdtree'				" 파일트리
Plugin 'scrooloose/nerdcommenter'			" 주석
Plugin 'bling/vim-airline'				" 상태바(Vim 사용자의 하단 상태바를 변경)
Plugin 'xuhdev/SingleCompile'				" 하나의 파일 컴파일 후 실행
Plugin 'Lokaltog/vim-easymotion'			" 한 화면에서 커서 이동
Plugin 'surround.vim'					" 소스 버전 컨트롤
Plugin 'iwataka/ctrlproj.vim'				" 지정된 위치 프로젝트 파일 찾기
Plugin 'Quich-Filter'					" 라인 필터링
Plugin 'mattn/emmet-vim'				" HTML, CSS 코드 단축 입력
Plugin 'rking/ag.vim'					" 문자열 찾기
Plugin 'majutsushi/tagbar'				" ctags 결과 표시
Plugin 'mhinz/vim-signify'				" 버전 관리 파일 상태 표시
Plugin 'tommcdo/vim-lion'				" 라인 정렬
Plugin 'tpope/vim-fugitive'				" Vim에서 git 명령어 사용
Plugin 'AutoComplPop'					" 자동 완성(Ctrl + P)를 누르지 않음
Plugin 'sheerun/vim-polyglot'			" 여러 언어 문법 강조
"Plugin 'github/copilot.vim'             " GitHub Copilot

call vundle#end()


"-----------------------------------------------------------------------"
" ctrlp.vim 설정
"-----------------------------------------------------------------------"
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|public$\|log$\|tmp$\|vendor$',
  \ 'file': '\v\.(exe|so|dll)$'
\ }

filetype plugin indent on				" 파일 종류에 따른 구문강조

"-----------------------------------------------------------------------"
" NERD Tree Key 설정
"-----------------------------------------------------------------------"
let NERDTreeWinPos = "left"		" NERD Tree위치 = 왼쪽
nmap  <C-f> :NERDTreeFind<CR> " Ctrl + f  NERDtree Toggle
nmap  <C-e> :NERDTreeToggle<CR> " Ctrl+ e  NERDtree Toggle


" NERDTree 트리 구조 기호 설정
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeShowHidden=1	"숨겨진 파일 및 폴더 보기

"-----cscope 설정-----"
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

if filereadable("./cscope.out")
cs add cscope.out
else
cs add /usr/src/linux/cscope.out
endif
set csverb

"-----ctags 설정-----"
set tags=./tags,../tags,../../tags,../../../tags,../../../../tags
" set tags+=/home/project/DAI-Metep-v0.9.2.1/tags
" set tags+=/home/hyunho.son/Desktop/project/DAI-Metep-v0.9.2.1/tags
set tags+=/home/hyunho.son/Desktop/project/Metep/tags
set tags+=/home/hyunho.son/Desktop/project/llama.cpp/tags
"-----vim 파일 구조-----"
autocmd BufNewFile,BufRead *.tpp set filetype=cpp
 

"------------------------------------------------------------------------"
" VIM C++ 설정
"------------------------------------------------------------------------"
"set rtp+=~/.vim/erics_vim_syntax_and_color_highlighting
"hi String ctermfg=140          " 터미널 모드에서 문자열(String) 색상 = 140 (보라색 계열)
"hi CursorLine ctermbg=235      " 터미널 모드에서 커서 라인 배경색 = 235 (어두운 회색)
hi CursorLine guibg=#D3D3D3 cterm=none
                               " GUI 모드에서 커서 라인 배경 = 연회색, 터미널
							   " 모드에서는 속성 없음

autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

:se bg=dark
