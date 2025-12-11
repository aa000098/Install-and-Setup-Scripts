# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# pip path
#PATH=$PATH:~/.local/bin
export PATH="/home/hyunho.son/local/vim/bin:$PATH"

# env settings
export LANGUAGE=ko_KR.UTF-8
export LANG=ko_KR.UTF-8
export PATH="$HOME/program/python3.10/bin:$PATH"
# export LD_PRELOAD=/lib/x86_64-linux-gnu/libtcmalloc.so
export XAUTHORITY=$HOME/.Xauthority

# LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HOME/local/opencv/lib/:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/Desktop/project/Metep/build/lib/:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH="$HOME/Desktop/project/Metep-didimdol/build/lib/:$LD_LIBRARY_PATH"
# export LD_LIBRARY_PATH="$HOME/local/gcc-9.5.0/lib64:$LD_LIBRARY_PATH"
# export LD_LIBRARY_PATH="/home/hyunho.son/Desktop/project/DAI-Metep-v0.9.2.1-share/build/lib/:$LD_LIBRARY_PATH"
# export LD_LIBRARY_PATH="/usr/local/cuda/targets/x86_64-linux/lib/"

export CPATH="$HOME/Desktop/project/Metep/include:$CPATH"
#export CPATH="$HOME/Desktop/project/Metep-didimdol/include:$CPATH"
export CPATH="$HOME/local/opencv/include/opencv4/:$CPATH"

#export PYTHONPATH="$PYTHONPATH:${HOME}/local/opencv/lib/

export PKG_CONFIG_PATH="$HOME/local/opencv/lib/pkgconfig:$PKG_CONFIG_PATH"

# Metep Env settings
export METEP_NUM_THREADS=4
export METEP_CPU_AFFINITY="3 6"

# cuda
# export PATH="/usr/local/cuda/bin:$PATH"
#export CUDA_LOCAL_DIR="$HOME/local/cuda"
#export PATH="$CUDA_LOCAL_DIR/bin:$PATH"
#export LD_LIBRARY_PATH="$CUDA_LOCAL_DIR/lib64:\$LD_LIBRARY_PATH"
#export C_INCLUDE_PATH="$CUDA_LOCAL_DIR/include:\$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="$CUDA_LOCAL_DIR/include:\$CPLUS_INCLUDE_PATH"


# virtual env auto activation
if [ -d "$HOME/local/venv" ]; then
    source "$HOME/local/venv/bin/activate"
fi

# alias settings
#alias vi="/usr/bin/vim.gtk3"
#alias vi="~/program/vim-9.1-gtk3/bin/vim"
#alias vi="~/local/vim/bin/vim"
alias vi='vim'
alias t1='tmux has-session -t session1 2>/dev/null && tmux attach -t session1 || tmux new -s session1'
alias t2='tmux has-session -t session2 2>/dev/null && tmux attach -t session2 || tmux new -s session2'
alias t3='tmux has-session -t session3 2>/dev/null && tmux attach -t session3 || tmux new -s session3'
alias t4='tmux has-session -t session4 2>/dev/null && tmux attach -t session4 || tmux new -s session4'
alias t5='tmux has-session -t session5 2>/dev/null && tmux attach -t session5 || tmux new -s session5'
alias python="python3"

if [[ -n "$VIRTUAL_ENV" ]]; then
    # 1) pip는 현재 venv꺼로 고정
#    if [[ -x "$VIRTUAL_ENV/bin/pip" ]]; then
#        alias pip="$VIRTUAL_ENV/bin/pip"
#    fi

    if command -v trash-put >/dev/null 2>&1; then
        alias rm="trash-put"
    else
        unalias rm 2>/dev/null
    fi
else
    unalias pip 2>/dev/null
    unalias rm 2>/dev/null
fi

#alias llama-cli="~/Desktop/project/llama.cpp/build/bin/llama-cli"

alias gcc9.5="~/local/gcc-9.5.0/bin/gcc"
alias g++9.5="~/local/gcc-9.5.0/bin/g++"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# QNN Setup
qnn() {
    QNN_ROOT="/home/hyunho.son/install_files/qairt_2.40.0.251030/qairt/2.40.0.251030/"
    QNN_BIN="$QNN_ROOT/bin"
    source "$QNN_BIN/envsetup.sh"
    source "$QNN_ROOT/qnn_venv/bin/activate"
    alias python="$QNN_ROOT/qnn_venv/bin/python"
    alias pip="$QNN_ROOT/qnn_venv/bin/pip"

    tensorflowLocation=$(python -m pip show tensorflow | grep '^Location: ' | awk '{print $2}')
    export TENSORFLOW_HOME="$tensorflowLocation/tensorflow"
}

#RKNN
export GCC_COMPILER="/usr/bin/aarch64-linux-gnu"

