# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#shouldn't be setting term manually!
#export TERM=xterm-256color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -A --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export VISUAL=vim;
export EDITOR=vim;
export GREP_OPTIONS='--color=auto'

alias g="git"

color_NOCL="\033[0m"
color_LINS="\033[0;31m"
color_BARS="\033[0;31m"
color_USER="\033[0;33m"
color_HOST="\033[0;33m"
color_ATSG="\033[0;31m"
color_CDIR="\033[0;34m"
color_PROM="\033[0;32m"
color_BNCH="\033[0;36m"
color_DRTY="\033[1;33m"

if [[ `hostname -s` = debby* ]]; then
    color_LINS="\033[0;32m"
    color_BARS="\033[0;32m"
    color_PROM="\033[0;35m"
elif [[ `hostname -s` = plato ]]; then
    color_LINS="\033[0;34m"
    color_BARS="\033[0;34m"
    color_PROM="\033[0;35m"
elif [[ `hostname -s` = *mac* ]]; then
    color_LINS="\033[0;36m"
    color_BARS="\033[0;36m"
    color_USER="\033[0;32m"
    color_HOST="\033[0;32m"
    color_ATSG="\033[0;35m"
    color_PROM="\033[0;35m"
fi

if [ -f ~/.gitcompletion.sh ]; then
    source ~/.gitcompletion.sh
fi

function parse_git_dirty {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -n "$(git status --porcelain)" ]; then
            echo -ne "$color_DRTY";
        fi
    fi
}

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

retval() {
    es=$?
    if [ $es -eq 0 ]
    then
        echo ""
    else
        echo "☹"
    fi
}

PROMPT_COMMAND='exitS=$(retval)'

export PS1="\[${color_LINS}\]┌─\[${color_BARS}\][\[${color_USER}\]\u\[${color_ATSG}\]@\[${color_HOST}\]\h\[${color_BARS}\]]\[${color_LINS}\]──\[${color_BARS}\][\[${color_CDIR}\]\w\[${color_BARS}\]]\n\[${color_LINS}\]└──\[${color_BNCH}\]\$(__git_ps1 '(%s)\[${color_LINS}\]──')\[${color_PROM}\]\[\$(parse_git_dirty)\]>>\[${color_NOCL}\]\${exitS} "

#listen &
case $TERM in
    rxvt*)
        tailf ~/.config/color &
        ;;
esac