autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
  #ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  #echo "${ref#refs/heads/}"

  ref=$($git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  if [ $ref = "HEAD" ]
  then
    ref="detached HEAD"
  fi

  echo "$ref"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

untracked () {
  $git status --porcelain 2>/dev/null | grep "^??" | wc -l | sed 's/^ *//'
}

need () {
  ut=$(untracked)
  up=$(unpushed)
  if [[ $up == "" && $ut -eq 0 ]]
  then
    echo " "
  else
    items=()
    if [[ $up != "" ]]
    then
      items+=(' unpushed')
    fi
    if [[ $ut -ne 0 ]]
    then
      items+=(" $ut untracked")
    fi

    # %{$fg_bold[magenta]%}unpushed%{$reset_color%}"

    output=$(join ", " "%{$fg_bold[magenta]%}${items[@]}%{$reset_color%}")
    output=" with$output"
    echo "$output"
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  else
    echo ""
  fi
}

node_version() {
  [ -f $HOME/.nvm/nvm.sh ] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  echo "node ${nvm_prompt}"
}

node_prompt() {
  if ! [[ -z "$(node_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(node_version)%{$reset_color%} "
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%~%{$reset_color%}"
}

# with node or ruby version
#export PROMPT=$'\n$(rb_prompt)$(node_prompt)in $(directory_name) $(git_dirty)$(need)\n› '

export PROMPT=$'\nin $(directory_name) $(git_dirty)$(need)\n› '

set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}