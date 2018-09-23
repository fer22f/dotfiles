#!/usr/bin/env sh
export PERL5LIB=$PWD/stow/share/perl
export PATH=$PATH:$PWD/stow/bin
alias stow='stow -t $HOME'
