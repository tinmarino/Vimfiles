#!/usr/bin/env bash

# Init, Variables
  # If not running interactively, don't do anything
  [[ -z "$PS1" ]] && return

  # Goto home, not /
  if [[ "$PWD" == / ]] ; then cd "$HOME" || : ; fi

  # Set USER
  [[ -z "$USER" ]] && command -v whoami > /dev/null && USER=$(whoami) && export USER

# Do I need to load .bash_profile
  if [[ -z "$os" && -z "$v" && -f "$HOME/.bash_profile" ]]; then
      # shellcheck source=/home/tourneboeuf/.bashrc
    echo Sourcing Profile
  	source "$HOME/.bash_profile"
  fi

# Execute tmux
  if command -v tmux &> /dev/null \
      && [[ -z "$TMUX" \
      &&  ! "$TERM" =~ screen  && ! "$TERM" =~ "screen-256color" \
      &&  ! "$TERM" =~ tmux  &&  ! "$TERM" =~ "tmux-256color" ]] \
      ; then
    # for ALMA but some glinch in scroll vim
    # exec env TERM=xterm-256color tmux
    # For bold and italic
    exec env TERM=tmux-256color tmux
  fi

# Head
  # clear
  # Nowrap
  printf '\e[?7l'
  cat << '  EOF'
                             \  |  /
                              \_|_/
                  /|\     ____/   \____
                 / | \        \___/
                /  |  \       / | \
               /___|___\     /  |  \
              _____|_____
              \_________/
   ~~^^~~^~^~~^^~^^^^~~~~^~^~^~^^^^^^^

        |\   \\\\__     o
        | \_/    o_\    o
        >  _  (( <_  oo
        | / \__+___/
        |/     |/

  EOF
  # Reset wrap
  printf '\e[?7h'

# Fast
  # Add "substitute" mnemonic, which the info file left out.
  export PATH="/home/tourneboeuf/Program/GitFuzzy/bin:$PATH"

# PS1
  # Title: Host: CD
  PS1='\[\e]0;\]`parse_title`\007'
  # CD (green)
  PS1+='\[\e[32m\]\w'
  # Git Branch (yellow)
  PS1+='\[\e[33m\]'
  PS1+='`parse_git_branch`'
  PS1+='\[\e[00m\]'
  # New line
  PS1+='\n$ '
  export PS1


# Include, Source, Extension
  # Alias
  if [[ -f "$HOME/.bash_aliases.sh" ]]; then
    # shellcheck source=/home/tourneboeuf/.bash_aliases.sh
    source "$HOME/.bash_aliases.sh"
  fi


# Bind
  # Enable Readline not waiting for additional input when a key is pressed.
  set keyseq-timeout 10
  bind -x '"\ee":fo'
  bind -x '"\er":fzf_dir ~/wiki/rosetta/Lang'


# vim:sw=2:ts=2:foldignore=:
