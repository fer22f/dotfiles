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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.config/bash/LS_COLORS/LS_COLORS && eval "$(dircolors -b ~/.config/bash/LS_COLORS/LS_COLORS)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -lAFh'
alias la='ls -ACF'
alias l='ls -CF'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=nvim
alias e="f -e $EDITOR"
alias o="a -e xdg-open"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias pdftotext="mutool draw 2>/dev/null -F txt"

export PATH=$PATH:~/.local/bin/

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
MAGENTA="$(tput setaf 5)"
RESET="$(tput sgr0)"
TITLE="$(echo -en "\033]0;")"
TITLEEND="$(echo -en "\007")"

function cool_prompt {
  P_EXIT="$?"
  if [ $P_EXIT -eq 0 ]; then
    P_EXIT=""
  fi

  if [ $UID -eq 0 ]; then
    LAMBDA="\[$RED\]Λ\[$RESET\]"
  else
    LAMBDA="\[$GREEN\]λ\[$RESET\]"
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

  __git_ps1 "\[${TITLE}$COMPUTER\w$TITLEEND\]\[$(tput sc; printf "$RED%*s$RESET" $COLUMNS "$P_EXIT "; tput rc)\]$LAMBDA " "\[${MAGENTA}\]$COMPUTER\[$YELLOW\]\w\[$RESET\] :" '%s '
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
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

source $XDG_CONFIG_HOME/bash/git-prompt.sh

cd () { builtin cd "$@" && ls -CF; }

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

take () {
  mkdir -p $1 && cd $1
}

source $XDG_CONFIG_HOME/bash/gt.sh

# fasd setup
export PATH=$PATH:~/.config/bash/fasd
eval "$(fasd --init auto)"
