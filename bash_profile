# ---- color settings for ls ----
export TERM='xterm'
txtblk='\033[0;30m'
txtred='\033[31m'
txtgrn='\033[32m'
txtplain='\033[1m'
txtylw='\033[33m'
end='\033[0m'

# ---- git branch name and status for prompt ----
GIT_PS1_SHOWSTASHSTATE=1

if [ -f /usr/local/git/contrib/completion/git-prompt.sh ]; then
	source /usr/local/git/contrib/completion/git-prompt.sh
fi
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
	source /usr/local/git/contrib/completion/git-completion.bash
fi


function parse_git {
  branch="$(__git_ps1 "%s")"
  if [[ -z $branch ]]; then
    return
  fi

  status="$(git status 2>/dev/null)"

  if [[ $status =~ "Untracked files" ]]; then
    branch="${txtred}(${branch})${end}"
  elif [[ $status =~ "Changes not staged for commit" ]]; then
    branch="${txtred}(${branch})${end}"
  elif [[ $status =~ "Changes to be committed" ]]; then
    branch="${txtylw}(${branch})${end}"
  elif [[ $status =~ "Your branch is ahead" ]]; then
    branch="${txtylw}(${branch})${end}"
  elif [[ $status =~ "nothing to commit" ]]; then
    branch="${txtplain}(${branch})${end}"
  fi

  echo -e $branch
}

parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

# ---- command prompt ----
# for all directories higher in the tree than the current directory,
# only show the first character of their name
PROMPT_COMMAND="echo -ne \"\033]0;$1 ($USER)\007\""
PS1='[\u \[\e[34m\]\w\[\e[m\] $(parse_git)]\n--> '
