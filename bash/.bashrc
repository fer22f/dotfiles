# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# HISTORY

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command
shopt -s checkwinsize

# automatic cd
shopt -s autocd
# autocorrect typos in cd
shopt -s cdspell
# autocorrect typos in directory completion
shopt -s dirspell
# extended glob
shopt -s extglob

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# We have color support; assume it's compliant with Ecma-48
# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# a case would tend to support setf rather than setaf.)
  color_prompt=yes
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
    test -r ~/.config/bash/LS_COLORS/LS_COLORS && eval "$(dircolors -b ~/.config/bash/LS_COLORS/LS_COLORS)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. /usr/share/autojump/autojump.sh

export EDITOR=nvim
alias e=$EDITOR
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias pdftotext="mutool draw 2>/dev/null -F txt"

export PATH=$PATH:~/.local/bin/

GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
RED="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
RESET="$(tput sgr0)"

function cool_prompt {
  if [ $? -eq 0 ]; then
    P_EXIT=""
  else
    P_EXIT="$?"
  fi

  if [ $UID -eq 0 ]; then
    LAMBDA="$REDΛ$RESET"
  else
    LAMBDA="$GREENλ$RESET"
  fi

  if [ -n "$SSH_CLIENT" ]; then
    COMPUTER='\h/'
  else
    COMPUTER=''
  fi

  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_STATESEPARATOR=""
  GIT_PS1_SHOWCOLORHINTS=true

  __git_ps1 '\[$(tput sc; printf "%*s" $COLUMNS $P_EXIT; tput rc)\]$LAMBDA ' '${MAGENTA}$COMPUTER$YELLOW\w$RESET :' '%s '
}

PROMPT_COMMAND=cool_prompt

pdfrg () {
  mutool draw 2>/dev/null -F txt $1 |  # convert pdf into text with no stderr
    tr '\n\f' ' \n' |                  # convert newlines to space, form feeds to newlines
    rg --line-number --pretty "${@:2}" # run ripgrep with line numbers
}

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"

export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.vim" | source $MYVIMRC'
export VIMDOTDIR="$XDG_CONFIG_HOME/nvim"

export PROMPT_DIRTRIM=3

source $XDG_CONFIG_HOME/bash/git-prompt.sh

cd () { builtin cd "$@" && ls -CF; }
