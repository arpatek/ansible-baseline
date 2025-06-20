# ┌────────────────────────────────────────────────────────────────────┐
# │ GG3 DevNet – gg3.zsh-theme                                         │
# │ Custom Oh My Zsh prompt for automation-friendly environments.      │
# │ Two-line prompt showing:                                           │
# │   - Python virtualenv (if active)                                  │
# │   - user@host                                                      │
# │   - shortened path (last 3 dirs max)                               │
# │   - Git branch + SHA + status                                      │
# │ Designed for easy reading, color-coded scanning, and vgrep logs.   │
# └────────────────────────────────────────────────────────────────────┘

# ─────────────────────────────
# Virtualenv appearance config
# ─────────────────────────────
ZSH_THEME_VIRTUALENV_PREFIX="%{$fg[white]%}(%{$fg[magenta]%}"  # Opening (venv) with color
ZSH_THEME_VIRTUALENV_SUFFIX="%{$fg[white]%})%{$reset_color%}"  # Closing ) with reset color

# ─────────────────────────────
# Git status symbols with colors
# ─────────────────────────────
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} +"         # Staged files
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✱"    # Modified files
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"        # Deleted files
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"       # Renamed files
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"   # Merge conflicts
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%} ✈"     # Untracked files
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"     # SHA prefix
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"    # Reset after SHA

# ─────────────────────────────
# Show (venv) if active
# ─────────────────────────────
custom_virtualenv_prompt_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "${ZSH_THEME_VIRTUALENV_PREFIX}$(basename "$VIRTUAL_ENV")${ZSH_THEME_VIRTUALENV_SUFFIX}"
  fi
}

# ─────────────────────────────
# Git prompt with branch and short SHA
# ─────────────────────────────
function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo " %B[${ref#refs/heads/}$(git_prompt_short_sha)$( git_prompt_status )%{$reset_color%}%b%B]%b "
  fi
}

# ─────────────────────────────
# Smart path shortening for prompt
# Shows ~/ or .../last/3/parts
# ─────────────────────────────
prompt_truncated_pwd() {
  local path="${PWD/#$HOME/~}"  # Replace $HOME with ~
  if [[ "$path" == "~" ]]; then
    echo "$path"
  else
    local -a dirs
    dirs=("${(s:/:)path}")      # Split path into array
    if (( ${#dirs[@]} > 3 )); then
      local last_three=("${dirs[@]: -3}")
      echo ".../$(IFS=/; echo "${last_three[*]}")"  # Keep only last 3 parts
    else
      echo "$path"
    fi
  fi
}

# ─────────────────────────────
# Two-line terminal prompt
# First line: user@host, path, venv, git
# Second line: command input (starts with ▪)
# ─────────────────────────────
PROMPT=$'%{\e[0;31m%}%B┌─[%{\e[1;34m%}%B%n%{\e[0m%}%b%{\e[1;37m%}@%{\e[0;32m%}%B%m%{\e[0m%}%b%{\e[0;31m%}]%b%{\e[0;31m%}[%{\e[0;33m%}$(prompt_truncated_pwd)%{\e[0;31m%}]%b %{$fg[magenta]%}$(custom_virtualenv_prompt_info)%{$reset_color%}$(mygit)
%{\e[0;31m%}%B└─▪%b%{\e[0;37m%}$ %b'

# PS2 = continuation prompt (e.g., for multi-line input)
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
