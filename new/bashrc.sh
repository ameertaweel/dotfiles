if [ -f "${HOME}/.profile" ]; then
	# ShellCheck fails without the directive below
	# https://www.shellcheck.net/wiki/SC1091

	# shellcheck source=/dev/null
	. "${HOME}/.profile"
fi

# ignorespace: lines which begin with a space character are not saved in the history list
export HISTCONTROL='ignoredups:erasedups:ignorespace'
export HISTIGNORE='cd:cd *:ls:ls *:exit:exit *'
set -o vi

set -o noclobber

shopt -s histappend
shopt -s autocd

# Prefix a command with '\' to ignore aliases (e.g. \ls)
alias ls='ls -lahv --color=auto --group-directories-first'
alias rm='rm --interactive --preserve-root'
alias cp='cp --interactive'
alias mv='mv --interactive'
alias mkdir='mkdir --parents --verbose'
alias ping='ping -c 5'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

PROMPT_COMMAND=__prompt_command

__prompt_command() {
	local LAST_EXIT_CODE="${?}" # This needs to be first

	PS1=''

	local COLOR_RESET='\[\e[0m\]'
	local COLOR_GREEN='\[\e[0;32m\]'
	local COLOR_YELLOW='\[\e[0;33m\]'
	local COLOR_BLUE='\[\e[0;34m\]'
	local COLOR_RED_BI='\[\e[1;91m\]' # Red [Bold] [High Intensity]

	local PROMPT_TIME="${COLOR_YELLOW}[\t]${COLOR_RESET}"
	local PROMPT_USER="${COLOR_GREEN}\u${COLOR_RESET}"
	local PROMPT_HOST="\H"
	local PROMPT_USER_HOST="${PROMPT_USER}@${PROMPT_HOST}"
	local PROMPT_CWD="${COLOR_BLUE}\w${COLOR_RESET}"

	local PROMPT_FIRST_LINE="${PROMPT_TIME} ${PROMPT_USER_HOST} ${PROMPT_CWD}"

	# Add the current Git branch when Git is available
	if command -v git >/dev/null 2>&1; then
		local IN_GIT_WORK_TREE
		IN_GIT_WORK_TREE="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

		local GIT_BRANCH
		if [ "${IN_GIT_WORK_TREE}" = "true" ]; then
			GIT_BRANCH="$(git branch --show-current)"
			PROMPT_FIRST_LINE+=" (${GIT_BRANCH})"
		elif [ "${IN_GIT_WORK_TREE}" = "false" ]; then
			GIT_BRANCH="GIT_DIR!"
			PROMPT_FIRST_LINE+=" (${GIT_BRANCH})"
		fi
	fi

	if [ "${SHLVL}" != 1 ]; then
		local PROMPT_SHLVL="${COLOR_BLUE}[SHLVL: ${SHLVL}]${COLOR_RESET}"
		PROMPT_FIRST_LINE+=" ${PROMPT_SHLVL}"
	fi

	if [ "${LAST_EXIT_CODE}" != 0 ]; then
		local PROMPT_LAST_EXIT_CODE="${COLOR_RED_BI}[${LAST_EXIT_CODE}]${COLOR_RESET}"
		PROMPT_FIRST_LINE+=" ${PROMPT_LAST_EXIT_CODE}"
	fi

	PS1="${PROMPT_FIRST_LINE}\n> "
}
