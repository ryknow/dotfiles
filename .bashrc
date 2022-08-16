# .bashrc

export TERM=xterm-256color

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

[[ $- == *i* ]] && stty -ixon -ixoff

if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi

if [ -f ~/.git-completion.sh ]; then
    . ~/.git-completion.sh
fi

# Misc aliases
alias ll='ls -l --color'
alias ls='ls --color'
alias la='ls -a --color'
alias lla='ls -la --color'
alias more='less'
alias clr='clear'
alias set_ctags='ctags --extra=+f --exclude=.git --exclude=log -R * `rvm gemdir`/gems/*'
alias gobrew='cd /usr/local/Cellar'
alias docker_rm_all_images='docker rmi -f $(docker images -a -q)'
alias docker_rm_all_containers='docker rm -f $(docker ps -a -q)'

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


# NOTE: Install virtualenvwrapper
# sudo pip install virtualenvwrapper
# OR
# sudo pip install pbr virtualenv-clone==0.2.5 stevedore==1.32.0
#
# export WORKON_HOME=$HOME/.virtualenvs
# source /usr/bin/virtualenvwrapper.sh
#
# if [ -f "/usr/bin/python" ]; then VIRTUALENVWRAPPER_PYTHON="/usr/bin/python"; fi
# [[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source "/usr/local/bin/virtualenvwrapper.sh"

function _is_ruby_project() {
    PROJECT_ROOT=$1
    if [ -f "$PROJECT_ROOT/.rvmrc" ]; then
        if [ -f "$HOME/.rvm/bin/rvm-prompt" ]; then
            return 0
        else
            echo "Found .rvmrc file, but could not find rvm-prompt. RVM not installed?"
            return 1
        fi
    else
        return 1
    fi
}

function _activate_ruby_environment( ){
    PROJECT_ROOT=$1
    if [ -f "$HOME/.rvm/bin/rvm-prompt" ]; then
        ENV_NAME=`$HOME/.rvm/bin/rvm-prompt`
    else
        ENV_NAME="global"
    fi
    export ENV_NAME
}

function _is_python_project() {
    PROJECT_ROOT=$1
    if [ -f "$PROJECT_ROOT/.venvrc" ]; then
        return 0
    elif [ -f "$PROJECT_ROOT/.venv" ]; then
        return 0
    else
        return 1
    fi
}

function is_function() {
    function_name=$1
    if [ -n "$(type -t $function_name)" ] && [ "$(type -t $function_name)" = function ]; then
        return 0
    else
        return 1
    fi
}

function _activate_python_environment() {
    PROJECT_ROOT=$1
    if _is_python_project $PROJECT_ROOT; then
        if [ -f "$PROJECT_ROOT/.venvrc" ]; then
            ENV_NAME=`cat $PROJECT_ROOT/.venvrc`
        elif [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat $PROJECT_ROOT/.venv`
        fi

        # Activate the environment only if it is not already active
        if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
            # If the VirtualEnv already exists, activate it
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                if is_function "workon"; then
                    echo "Working on: $ENV_NAME"
                    workon "$ENV_NAME"
                    export CD_VIRTUAL_ENV=$ENV_NAME
                else
                    echo "Virtual Environment Found: $ENV_NAME"
                    echo "However, virtualenvwrapper was not installed properly."
                    echo "Please be sure virtualenvwrapper.sh is sourced in your bashrc."
                    ENV_NAME="global"
                fi
            else
                if is_function "mkvirtualenv"; then
                    # Create Virtual Environment if it does not exist
                    echo "Creating Virtual Environment: $ENV_NAME"
                    mkvirtualenv "$ENV_NAME"
                    workon "$ENV_NAME"
                    export CD_VIRTUAL_ENV=$ENV_NAME
                else
                    echo "Virtual Environment Found: $ENV_NAME"
                    echo "However, virtualenvwrapper was not installed properly."
                    echo "Please be sure virtualenvwrapper.sh is sourced in your bashrc."
                    ENV_NAME="global"
                fi
            fi
        fi
    else
        ENV_NAME="global"
    fi
    export ENV_NAME
}

function _activate_environment() {
    PROJECT_ROOT=$1
    if [ $PROJECT_ROOT ]; then
        if _is_python_project $PROJECT_ROOT; then
            _activate_python_environment $PROJECT_ROOT
        elif _is_ruby_project $PROJECT_ROOT; then
            _activate_ruby_environment $PROJECT_ROOT
        else
            ENV_NAME="global"
        fi
    else
        ENV_NAME="global"
    fi
    export ENV_NAME
}

function force_workon() {
    SKIP_ACTIVATE="true"
    workon $1
    ENV_NAME=$1
    export SKIP_ACTIVATE
}

function reset_skip() {
    SKIP_ACTIVATE="false"
    export SKIP_ACTIVATE
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
    
    if [[ $? == 0 ]]; then
        PROJECT_ROOT=`pwd`
        if [ "$SKIP_ACTIVATE" != "true" ]; then
            _activate_environment $PROJECT_ROOT
        else
            echo "SKIP_ACTIVATE is set.....execute reset_skip to reset"
        fi
        if [ "$ENV_NAME" == "global" ]; then
            if [ $CD_VIRTUAL_ENV ]; then
                if is_function "deactivate"; then
                    echo "Deactivating $CD_VIRTUAL_ENV"
                    deactivate && unset CD_VIRTUAL_ENV
                    SKIP_ACTIVATE="false"
                else
                    unset CD_VIRTUAL_ENV
                fi
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        if is_function "deactivate"; then
            echo "Deactivating $CD_VIRTUAL_ENV"
            deactivate && unset CD_VIRTUAL_ENV
            SKIP_ACTIVATE="false"
        else
            unset CD_VIRTUAL_ENV
        fi
        ENV_NAME="global"
        export ENV_NAME
    fi
    
    PS1="`_git_prompt`${CYAN}[\u@\h ${PURPLE}`~/.rvm/bin/rvm-prompt` ${GREEN}\w${CYAN}]\n\$${LIGHT_GRAY} "
}

PROMPT_COMMAND=_prompt_command
# export NODE_PATH=/usr/local/lib/node_modules

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session "as a function"

export PATH=$PATH
# :$HOME/.rvm/bin:/usr/local/share/npm/bin # Add RVM to PATH for scripting
