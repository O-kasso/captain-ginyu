####################
#      SETUP       #
####################

# iterm2 shell integration
# shellcheck source=/dev/null
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# default editor
export EDITOR=vim

# FZF keybindings
# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# setup ruby
eval "$(rbenv init -)"

# setup python
# eval "$(pyenv init -)"

# setup golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# don't send analytics to homebrew
export HOMEBREW_NO_ANALYTICS=1

####################
#    APPEARANCE    #
####################

# pretty prompt
ORANGE=$(tput setaf 9)
VIOLET=$(tput setaf 13)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)
export PS1='\[$VIOLET\]{\@}\[$CYAN\]{\w\[$ORANGE\]$(__git_ps1)\[$CYAN\]} $ \[$RESET\]'
export PS2="${VIOLET}\[\@\]${CYAN} > ${RESET}"

source ~/git-completion.bash # completion
source ~/git-prompt.sh # prompt
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

####################
#      ALIASES     #
####################

## navigating
alias ls='ls -Gh'
alias ll='ls -Glha'
alias dropb='cd ~/Dropbox'
alias tree='tree -C -L 3'
alias bashp='vim ~/.bash_profile'
alias desk='cd ~/Desktop'
alias code='cd ~/Code'
alias ok='cd ~/Code/o-kasso'
alias sob='source ~/.bash_profile'

## vim
alias vimsp='vim $1 +sp $2 +n'
alias vimvsp='vim $1 +vsp $2 +n'
alias vimrc='vim ~/.vimrc'

## git
alias gst='git status'
alias gcm='git checkout master'
alias gpull='git pull && ctags -R --languages=ruby,javascript --exclude=.git --exclude=log .'
alias gcmp='gcm && gpull'
alias grb='git_rebase_latest_master'
alias gup='git_push_branch_up_to_remote_and_open_in_browser'
alias gopen='git_open_project'
alias gconf='git diff --name-only --diff-filter=U' # view all merge conflicts
alias glog='git_pretty_log $1'
alias gdiff='git_diff_since'

alias goops='git checkout -- $1'
alias gdang='git_dangling_commits_tree' # view lost commits and stashes
alias gdamn='git commit --amend --no-edit'
alias gshit='git_interactive_rebase_x_commits_ago $1'
alias gfuck='git_commit_amend_all_and_force_push'
alias gresync='git_reset_origin_master_to_upstream_master'
alias gnuke='git_nuke_repo'

## web dev
alias ber='bundle exec rails'
alias bers='bundle exec rails server'
alias berc='bundle exec rails console'
alias berd='bundle exec rails dbconsole'
alias berg='bundle exec rails generate'
alias killpuma='pgrep -f puma | xargs kill -9'
alias serv='serve_static_site'

###################
#    FUNCTIONS    #
###################

# rename current iterm2 tab
function title { echo -ne "\033]0;"$*"\007"; }

# display a tree of all dangling commits
function git_dangling_commits_tree {
  git log --graph --oneline --decorate $( git fsck --no-reflog | awk '/dangling commit/ {print $3}' );
}

# force push all changes on top of previous commit
function git_commit_amend_all_and_force_push {
  read -p "Are you sure you want to force-push everything to $(git symbolic-ref --short HEAD)? [y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then git commit -a --amend --no-edit && git push -f; fi;
}

# update to latest master and rebase current branch on top of it
function git_rebase_latest_master {
  gstatus=$(git status --porcelain) && \
    if [ "$gstatus" != "" ] ; then git stash --include-untracked ; fi && \
    git fetch origin master:master && \
    git rebase master && \
    if [ "$gstatus" != "" ] ; then git stash pop ; fi;
}

# push to new upstream branch with same name as local branch, then open default browser to Github page for new branch
function git_push_branch_up_to_remote_and_open_in_browser {
  cd "$(git rev-parse --show-toplevel)" && \
  git push --set-upstream origin "$(git symbolic-ref --short HEAD)" && \
  git_open_project
}

function git_interactive_rebase_x_commits_ago {
  if [[ $1 =~ ^[0-9]+$ ]] ; then git rebase -i "HEAD~$1" ; fi;
}

function git_pretty_log {
  if [[ $1 =~ ^[0-9]+$ ]] ; then
    git log "-$1" --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
  else
    git log -20 --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
  fi
}

function git_diff_since {
  if [[ $1 =~ ^[0-9]+$ ]] ; then
    git diff -w "HEAD~$1"
  else
    git diff -w
  fi
}

function git_open_project {
  open "https://github.com/$(basename -- "$(dirname "$PWD")")/$(basename "$PWD")";
}

function git_reset_origin_master_to_upstream_master {
  repo_name=$(basename "$(git rev-parse --show-toplevel)")
  read -p "Are you sure you want to revert origin/master back to upstream/master? All work that hasn't been pushed upstream will be lost forever. [y/n]: " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git remote update && \
    git checkout -f master \
    git reset --hard upstream/master -- \
    git clean -fd \
    git push origin +master
  fi
}

function git_nuke_repo {
  origin_url=$(git config --get remote.origin.url)
  toplevel=$(git rev-parse --show-toplevel)

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
    read -p "Are you sure you want to delete the $(basename "$toplevel") repository and start fresh? All work that hasn't been pushed to a remote will be lost forever. [y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      cd "$toplevel" && cd .. && rm -rf "$toplevel"

      if [ "$1" = "recursive" ] ; then
        git clone "$origin_url" --recursive
      else
        git clone "$origin_url"
      fi

      cd "$toplevel" || return
    fi
  fi
}

function serve_static_site {
  port=$1

  if [[ $port =~ ^[0-9]+$ ]]; then
    open http://localhost:"$port" && \
    ruby -run -ehttpd . -p"$port"
  else
    echo "Please provide a port number to serve from."
  fi
}
