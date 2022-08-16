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
alias norg="gron --ungron"
alias ungron="gron --ungron"

if command -v mutool >/dev/null; then
  alias pdftotext="mutool draw 2>/dev/null -F txt"
fi

export PATH=~/.local/bin/:$PATH

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
MAGENTA="$(tput setaf 5)"
RESET="$(tput sgr0)"
TITLE="$(echo -en "\033]0;")"
TITLEEND="$(echo -en "\007")"
if [ -n "$SSH_CLIENT" ]; then
  BGCOLOR="#04143a"
else
  BGCOLOR="#000000"
fi

function update_background_color {
  printf %b '\e]11;'$BGCOLOR'\a'
}

update_background_color

function cool_prompt {
  update_background_color

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

  # title
  STARTPS1="\[${TITLE}$COMPUTER\w$TITLEEND\]"
  # lambda
  STARTPS1+="$LAMBDA "

  ENDPS1="\[${MAGENTA}\]$COMPUTER\[$YELLOW\]\w\[$RESET\] :"

  __git_ps1 "$STARTPS1" "$ENDPS1" '%s '
}

PROMPT_COMMAND=cool_prompt

pdfrg () {
  mutool draw 2>/dev/null -F txt $1 |  # convert pdf into text with no stderr
    tr '\n\f' ' \n' |                  # convert newlines to space, form feeds to newlines
    rg --line-number --pretty "${@:2}" # run ripgrep with line numbers
}

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"

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

alias e=$EDITOR
alias ge="neovide --multiGrid --maximized >/dev/null 2>/dev/null --"
alias o="xdg-open >/dev/null 2>/dev/null"

source $XDG_CONFIG_HOME/bash/z/z.sh

if [[ -f $XDG_CONFIG_HOME/bash/local.sh ]]; then
  source $XDG_CONFIG_HOME/bash/local.sh
fi

export PATH=$PATH:~/.cabal/bin
export PATH=$PATH:~/.local/flutter/bin

alias dcr="docker-compose run --rm"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

complete -F _fzf_path_completion -o default -o bashdefault e

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'

detach () {
  bash -c "$@" &>/dev/null </dev/null & disown
}

bind '"\C-l":vi-movement-mode'

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

comp () {
  g++ -std=c++17 -O2 -static $1
}

alias vim=e
alias units='units --history "$XDG_DATA_HOME"/units_history'
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias sshkeys="ssh-add ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/maratona ~/.ssh/caad"
