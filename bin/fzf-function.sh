#!/usr/bin/env bash
# Function definition to use git with fzf
# From: https://github.com/junegunn/fzf/wiki/Examples


# Variable helper

  _git_log_line_to_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
  _view_log_line="$_git_log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
  _view_log_line_unfancy="$_git_log_line_to_hash | xargs -I % sh -c 'git show %'"

# Variable fzf
  _fzf_size='--preview-window=right:60% --height 100%'
  # TODO see filter for file
  _fzf_eval_gcpreview=$'func() {
    set -- \$('$_git_log_line_to_hash');
    [ \$# -eq 0 ] || git show --color=always %; }; func {}'
  _fzf_bind=(
    --bind j:down
    --bind k:up
    --bind q:abort
    --bind ctrl-b:preview-page-up
    --bind ctrl-f:preview-page-down
    --bind alt-j:preview-down
    --bind alt-k:preview-up
    --bind "alt-v:execute:$_view_log_line_unfancy | vim -"
  )

# System TODO cd

# Git

fbr() {
  local branches branch
  branches=$(git --no-pager branch -vv && git --no-pager branch -rvv) &&
  branch=$(echo "$branches" |
    fzf +m \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "$_fzf_eval_gcpreview" \
  ) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}


# Log Interface
fli() {
  # From: https://gist.github.com/junegunn/f4fca918e937e6bf5bad#gistcomment-2981199
  # Log ideas: --date-order --date=short  => Ugly for AlmaSW
  local filter
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi


  git log \
    --graph --color=always --abbrev=7 --format='%C(auto)%h %an %C(blue)%s %C(yellow)%cr' $@ | \
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}" \
      $_fzf_size \
      "${_fzf_bind[@]}"
}

      #--bind "ctrl-m:execute:
      #          (grep -o '[a-f0-9]\{7\}' | head -1 |
      #          xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      #          {}
      #          FZF-EOF" \

      #--bind "ctrl-m:execute:
      #        (grep -o '[a-f0-9]\{7\}' | head -1 |
      #        xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      #        {}
      #        FZF-EOF"

# PickAce
fpickace(){
  # From https://github.com/junegunn/fzf/issues/1645#issuecomment-586161109
  git log --color=always --pretty=oneline --no-abbrev-commit --decorate \
  | fzf --phony --bind="change:reload:git log -G{q} --color=always --pretty=oneline --no-abbrev-commit --decorate" \
    --preview="git show --color=always {1}" \
    --preview-window right:80% \
    --with-nth=2.. --layout=reverse --no-sort --ansi \
  | awk '{print $1}'
}

# vim: sw=2
