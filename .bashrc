#
# ~/.bashrc
#
LD_PRELOAD=/usr/lib64/VirtualGL/libdlfaker.so

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash Theme
export PS1='\[\e[32m\]\[\e[1m\]\u\[\e[21m\]\[\e[m\]@\h [\[\e[34m\]\[\e[1m\]\W\[\e[21m\]\[\e[m\]] \$ '

# Alias for linux
# alias ls='pwd; ls -l --color=auto'
alias ls='ls --color=auto'

# Alias for MS-DOS
alias dir="ls --color=auto"
alias copy="cp"
alias rename="mv"
alias md="mkdir"
alias rd="rmdir"
alias del="rm -i"
alias vi="vim"

# Alias for Safety
alias rm="rm -i"

# For Tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
