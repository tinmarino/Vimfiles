#!/usr/bin/env bash

# Guard: if not Bash exit
if [ -z "$BASH_VERSION" ]; then
  exit
fi

# DEBUG
export BASHPROFILE_SOURCED=1
echo "Sourcing bash profile at $(date)" >> /tmp/bash_profile

# Init, Variables
  # Set OS
  export h="$HOME"
  # shellcheck disable=SC2088
  uname=$(uname -a)
  uname=${uname,,}
  case $uname in
  *"android"*)
    export os="termux"
    export v="$HOME/.vim"
    ;;
  *"linux"*)
    export os="unix"
    export v="$HOME/.vim"
    ;;
  *"mingw"*)
    export os="windows"
    export v="$HOME/vimfiles"
    ;;
  esac

  # Man
  if [[ ! "$USER" == "jim" ]]; then
    export PAGER="vman"
  fi
  export TEXMFHOME="$HOME/Program/Tlmgr"


# Path
  # Save
  export path_save=$PATH
  export PATH=""
  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/bin" ] ; then
      PATH="$HOME/bin:$PATH"
  fi
  
  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/.local/bin" ] ; then
      PATH="$HOME/.local/bin:$PATH"
  fi

    # Windows fast
  export PATH="$PATH:/c/Program Files/Vim/vim82"
  # My script
  export PATH=$PATH:$HOME/.vim/bin
  export PATH=$PATH:$HOME/Bin
  # Node after npm config set prefix ~/.npm
  export PATH=$PATH:$HOME/.npm/bin
  # Perl6
  export RAKUDOLIB=$HOME/.raku
  export PATH=$PATH:$HOME/Program/Raku/Doc/bin
  export PATH=$PATH:$HOME/Program/Raku/Repo/install/bin
  export PATH=$PATH:$HOME/Program/Raku/Repo/install/share/perl6/site/bin
  export PATH=$PATH:$HOME/Program/Raku/Z/bin
  export PATH=$PATH:$HOME/.raku/share/perl6/site/bin
  export PATH=$PATH:$HOME/.raku/bin
  # Python
  #export PATH=$PATH:$HOME/Program/Conda/bin
  export PATH=$PATH:$HOME/.local/usr/local/bin
  # Rust
  export PATH=$PATH:$HOME/.cargo/bin
  # Android sdk
  export PATH=$PATH:$HOME/Program/Android/Sdk/Tools/sdk-tools-linux-4333796/tools
  export PATH=$PATH:$HOME/Program/Android/Sdk/Tools/sdk-tools-linux-4333796/tools/bin
  export PATH=$PATH:$HOME/Program/Eclipse/eclipse
  export ANDROID_HOME=$HOME/Program/Android/Sdk/Tools/sdk-tools-linux-4333796
  export ANDROID_SDK=$HOME/Program/Android/Sdk/Tools/sdk-tools-linux-4333796
  # Programs
  export PATH=$PATH:/usr/local/cuda-10.0/bin
  export PATH=$PATH:$HOME/Program/Metapixel/metapixel
  # Readd
  export PATH=$PATH:$path_save

  # Lib
  export LD_LIBRARY_PATH=$HOME/Bin:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$HOME/Program/Gecode:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu:$LD_LIBRARY_PATH
  export NDK=$HOME/Program/Ndk/Current

  # Perl
  export PATH="/home/tourneboeuf/perl5/bin${PATH:+:${PATH}}"
  export PERL5LIB="/home/tourneboeuf/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
  export PERL_LOCAL_LIB_ROOT="/home/tourneboeuf/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
  export PERL_MB_OPT="--install_base \"/home/tourneboeuf/perl5\""
  export PERL_MM_OPT="INSTALL_BASE=/home/tourneboeuf/perl5"



# Preferences
  # Enable directory with $
  # shopt -s direxpand
  # Avoid c-s freezing
  stty -ixon

  # Vi as default `git commit`
  export EDITOR='vim'
  # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
  shopt -s checkwinsize

  # French characters
  stty cs8 -istrip -parenb
  bind 'set convert-meta off'
  bind 'set meta-flag on'
  bind 'set output-meta on'

# Prompt
  # Save history after each executed line
  export PROMPT_COMMAND+='history -a;'


# Fzf functions
  #_vim_escaped2='let out = map(fzf#vim#_recent_files(), \"substitute(v:val, \\\"\\\\\\\\~\\\", \\\"'$HOME'\\\", \\\"\\\")\")'
  _vim_escaped2='let out = fzf#vim#_recent_files()'
  _fzf_cmds="bash -c \"
    vim -NEs
      +'redir>>/dev/stdout | packadd fzf.vim'
      +'$_vim_escaped2'
      +'echo join(out, \\\"\\\\n\\\")'
      +'redir END | q';
    rg --color always --files \\\".\\\";
    cd \\\"$HOME\\\" && rg --color always --files | awk '{print \\\"~/\\\" \\\$0}';
    cd \\\"$v\\\" && rg --color always --files | awk '{print \\\"$v/\\\" \\\$0}';
  \""
  export FZF_DEFAULT_COMMAND="${_fzf_cmds//$'\n'/}"
  # shellcheck disable=SC2206,SC2191
  fzf_opts=(
    # Enable exact match
    #--exact
    --ansi
    # Multi Selection
    --multi
    --reverse
    # First olfiles
    #--no-sort
    --preview-window=right:50% --height 100%
    #--preview \"$v/bin/_tinrc-fzf-preview.sh {}\"
    --bind ?:toggle-preview
    --bind ctrl-space:toggle-preview
    --bind ctrl-j:down
    --bind ctrl-k:up
    --bind ctrl-u:half-page-up
    --bind ctrl-d:half-page-down
    --bind ctrl-s:toggle-sort
    --bind alt-u:preview-half-page-up
    --bind alt-d:preview-half-page-down
    #--bind ctrl-y:preview-up
    #--bind ctrl-e:preview-down
  )
  export FZF_DEFAULT_OPTS="${fzf_opts[*]}"
  # ForGit plugin
  export FORGIT_LOG_FZF_OPTS="$FZF_DEFAULT_OPTS"
  export FORGIT_DIFF_FZF_OPTS="$FZF_DEFAULT_OPTS"
  export FORGIT_DIFF_FZF_OPTS="$FZF_DEFAULT_OPTS"
  # From: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
  export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_CTRL_R_OPTS="--sort --exact --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Include

# Source bashrc ?
  if [ -n "$BASH_VERSION" ]; then
      # include .bashrc if it exists
      if [ -f "$HOME/.bashrc" ]; then
      # shellcheck source=/home/tourneboeuf/.bashrc
  	  source "$HOME/.bashrc"
      fi
  fi


# vim:sw=2:ts=2:foldignore=:
source "$HOME/.cargo/env"
