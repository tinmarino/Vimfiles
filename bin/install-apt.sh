#!/usr/bin/env bash

# Init
pg=()

pg+=(
# Operational
git
gitk
tmux
bash-completion
vlc
vim-gtk  # For system clipboard
exuberant-ctags
ssh
mosh
xterm
fzf
bat  # syntax hi in fzf

# Linters
shellcheck

# Language
python3 jupyter-console python3-pip
perl
bash
npm

# LaTex
texlive-latex-extra latex-mk latexmk
pandoc
pdf2svg

# Program
gimp
firefox
pdftk
imagemagick
virtual-box

# System
ubuntu-drivers-common
gnome-terminal
wine
linux-headers-generic
)

# npm install -g diff-so-fancy

# Print out
echo -n "sudo apt install "
for prog in "${pg[@]}" ; do echo -n "$prog " ; done
echo
