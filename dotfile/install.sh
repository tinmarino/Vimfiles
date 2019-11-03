# Get script path
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
echo "[*] Dotfile path is $scriptpath"

# Get OS
uname=$(uname -a)
uname=${uname,,}
case $uname in
  *"android"*)
    export os="termux";;
  *"linux"*)
    export os="unix";;
  *"mingw"*)
    export os="windows";;
esac
echo "[*] OS is $os"


# Helper: 
function convert_path_to_windows {
  echo "$1" | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^./\0:/'
}

# Helper: https://stackoverflow.com/questions/13701218/windows-path-to-posix-path-conversion-in-bash
function convert_path_to_unix {
  echo "/$1" | sed -e 's/\\/\//g' -e 's/://'
}

# Helper: Make symbolic link
function try_link {
    target="$1"
    link="$2"
    if [ -f "$target" ] ; then
        echo "[-] $target already exists"
    else
        if [ "$os" = "windows" ] ; then
            target=$(convert_path_to_windows "$target")
            link=$(convert_path_to_windows "$link")
            echo mklink $link $target  # && echo "[+] $2 created"
        else
            ln -s $target $link && echo "[+] $link created"
        fi
    fi
}


# Git
try_link $scriptpath/gitconfig  ~/.gitconfig

# Tmux
try_link $scriptpath/tmux.conf  ~/.tmux.conf

# Termux
[ -d ~/.termux ] || mkdir ~/.termux
try_link $scriptpath/termux.properties ~/.termux/termux.properties

# Vim
try_link $scriptpath/vimrc ~/.vimrc
# # Create undodir
undo_path=$(dirname $scriptpath)/undo
if [ -d $undo_path ] ; then
    echo "[-] $undo_path already exists"
else
    mkdir ~/.vim/undo
    echo "[+] $undo_path created"
fi

# Perl
try_link $scriptpath/replyrc ~/.replyrc
try_link $scriptpath/perlrc.pl ~/.perlrc.pl
try_link $scriptpath/Tool.pm ~/Software/Perl/Lib/Tool.pm

# Bash
try_link $scriptpath/bash_aliases.sh ~/.bash_aliases.sh
try_link $scriptpath/bashrc ~/.bashrc
try_link $scriptpath/inputrc ~/.inputrc
