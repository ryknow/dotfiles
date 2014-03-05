# .bashrc

export TERM=xterm-256color

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

stty -ixon -ixoff

if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi

if [ -f ~/.git-completion.sh ]; then
    . ~/.git-completion.sh
fi

# Misc aliases
alias ll='ls -l'
alias more='less'
alias clr='clear'
alias set_ctags='ctags --extra=+f --exclude=.git --exclude=log -R * `rvm gemdir`/gems/*'

# Git aliases
alias gcm='git commit -m'

# Functions
function g {
    if [ $1 ]; then
        git "$@"
    else
        git status
    fi
}

function git-full-branch-name {
    echo $(git symbolic-ref HEAD 2>/dev/null | awk -Frefs/heads/ {'print $NF'})
}

alias gp='git push origin $(git-full-branch-name)'

function rgrep {
    find -L -type f -name \*.*rb -exec grep -n -i -H --color "$1" {} \;
}

function jgrep {
    find -L -type f -name \*.*js -exec grep -n -i -H --color "$1" {} \;
}

function git-branch-name {
    echo $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

function git-unpushed {
    brinfo=$(git branch -v | grep `git-branch-name`)
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)]) ]]
    then
        echo ":${BASH_REMATCH[2]}:"
    fi
}

function _git_prompt {
    local git_status="`git status -unormal 2>&1`" 
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            # no commits but stuff hasn't been pushed
            if [[ "$git_status" =~ Your\ branch\ is\ ahead ]]; then
                local ansi=41
            else
                # pristine local copy 
                local ansi=42
            fi
        # untracked files only
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        # anything else
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else 
            # Detached HEAD
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
        fi

        echo -n '\e[0;37;'"$ansi"';1m'"$branch"'\e[0m'
    fi
}

function _prompt_command {
    # Colors
    YELLOW="\[\033[0;33m\]"
    PURPLE="\[\033[0;35m\]"
    RED="\[\033[0;31m\]"
    GREEN="\[\033[0;32m\]"
    LIGHT_GRAY="\[\033[0;37;00m\]"
    CYAN="\[\033[0;36m\]"

    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    
    PS1="`_git_prompt`${CYAN}[\u@\h ${PURPLE}`~/.rvm/bin/rvm-prompt` ${GREEN}\w${CYAN}]\n\$${LIGHT_GRAY} "
}

PROMPT_COMMAND=_prompt_command

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session "as a function"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
