#
# ~/.bashrc

# if not running interactively, abandon further processing of this file
[[ $- != *i* ]] && return

# my locale settings
export LANG=en_US.UTF-8

# 2013-06-03 archlinux merges all binaries into a unified /usr/bin directory
PATH=/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/cuda/bin
PATH=$PATH:$HOME/bin:$HOME/.rvm/bin:$HOME/.cabal/bin:/usr/local/heroku/bin
export PATH
export EDITOR="vim -g --servername GVIM --remote-silent"
export TERM=xterm-256color
export _JAVA_AWT_WM_NONREPARENTING=1

# aliases
alias ls='ls --color=auto'
alias dmenu_run='dmenu_run -i -p "> " -nb "#eee8d5" -nf "#2aa198" -sb "#fdf6e3" -sf "#d33682"'
alias sudo='sudo env PATH=$PATH'

# bash completions
source /usr/share/git/completion/git-completion.bash
source ~/.files/bash/scripts/completion-ruby/completion-ruby-all

# custom colors
source ~/.files/bash/scripts/custom-colors
eval `dircolors ~/.files/bash/scripts/ls-colors-solarized/dircolors`

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

ps1_titlebar()
{
  case $TERM in
    (xterm*|rxvt*)
      printf "%s" "\033]0;\\u@\\h: \W\\007"
      ;;
  esac
}

ps1_identity()
{
  if (( $UID == 0 )) ; then
    printf "%s" '\[\e[32;30m\][\[\e[1;36;34m\]\u@\[\e[0m\]\[\e[1;36;5m\]\h\[\e[0m\] \[\e[35m\]\W\[\e[0m\]\[\e[32;30m\]]\[\e[1;36m\]'
  else
    printf "%s" '\[\e[32;30m\][\[\e[1;36;34m\]\u@\[\e[0m\]\[\e[1;36;5m\]\h\[\e[0m\] \[\e[35m\]\W\[\e[0m\]\[\e[32;30m\]]\[\e[1;36m\]'
  fi
}

ps1_git()
{
  local branch="" sha1="" line="" attr="" color=0

  shopt -s extglob # Important, for our nice matchers

  command -v git >/dev/null 2>&1 || {
    printf " \033[1;37m\033[41m[git not found]\033[m "
    return 0
  }

  branch=$(git symbolic-ref -q HEAD 2>/dev/null) || return 0 # Not in git repo.
  branch=${branch##refs/heads/}

  # Now we display the branch.
  sha1=$(git rev-parse --short --quiet HEAD)

  case "${branch:-"(no branch)"}" in
   master) attr="1;37;5m\033[" ; color=41 ;; # red
   release)                      color=31 ;; # red
   hotfix)                       color=33 ;; # yellow
   integration)                  color=34 ;; # blue
   *)                            color=36 ;; # cyan
   *)

    if [[ -n "${branch}" ]] ; then # Feature Branch :)
       color=32 # green
     else
       color=0 # reset
     fi
     ;;
  esac

  [[ $color -gt 0 ]] &&
    printf "\[\033[${attr}${color}m\](git:${branch}$(ps1_git_status):$sha1)\[\033[0m\] "
}

ps1_git_status()
{
  local git_status="$(git status 2>/dev/null)"

  [[ "${git_status}" = *deleted* ]]                    && printf "%s" "-"
  [[ "${git_status}" = *Untracked[[:space:]]files:* ]] && printf "%s" "+"
  [[ "${git_status}" = *modified:* ]]                  && printf "%s" "*"
}

ps1_rvm()
{
  command -v rvm-prompt >/dev/null 2>&1 && printf "%s" "\[\e[32;30m\][\[\e[1;36;34m\] $(rvm-prompt) \[\e[0m\]\[\e[32;30m\]]\[\e[0m\]"
}

ps1_update()
{
  local prompt_char='$ \[\e[0m\]' separator="\n" notime=0

  (( $UID == 0 )) && prompt_char='# \[\e[0m\]'

  while [[ $# -gt 0 ]] ; do
    local token="$1" ; shift

    case "$token" in
      --trace)
        export PS4="+ \${BASH_SOURCE##\${rvm_path:-}} : \${FUNCNAME[0]:+\${FUNCNAME[0]}()}  \${LINENO} > "
        set -o xtrace
        ;;
      --prompt)
        prompt_char="$1 \[\e[0m\]"
        #prompt_char="$1"
        shift
        ;;
      --noseparator)
        separator=""
        ;;
      --separator)
        separator="$1"
        shift
        ;;
      --notime)
        notime=1
        ;;
      *)
        true # Ignore everything else.
        ;;
    esac
  done

  if (( notime > 0 )) ; then
    PS1="$(ps1_titlebar)$(ps1_git)$(ps1_rvm)${separator}$(ps1_identity)${prompt_char} "
  else
    PS1="$(ps1_titlebar)\D{%H:%M:%S} $(ps1_git)$(ps1_rvm)${separator}$(ps1_identity)${prompt_char} "
  fi
}

ps2_set()
{
  PS2="  \[\033[0;40m\]\[\033[0;33m\]> \[\033[1;37m\]\[\033[1m\]"
}

ps4_set()
{
  export PS4="+ \${BASH_SOURCE##\${rvm_path:-}} : \${FUNCNAME[0]:+\${FUNCNAME[0]}()}  \${LINENO} > "
}

PROMPT_COMMAND="ps1_update $@"

rvm reload


