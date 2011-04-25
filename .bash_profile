# TextMate as default editor, w is to wait for TextMate window to close
export TERM='xterm-256color'
export EDITOR="/usr/local/bin/mate -w"
#export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[0;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"			# lists all the color

echo -e "${COLOR_LIGHT_GREEN}Kernel Information: " `uname -smr`
echo -e "${COLOR_LIGHT_BLUE}`bash --version`"
echo -ne "${COLOR_LIGHT_PURPLE}Uptime: "; uptime
echo -ne "${COLOR_LIGHT_CYAN}Server time is: "; date

# MySQL
alias start_mysql="/Library/StartupItems/MySQLCOM/MySQLCOM start"
alias stop_mysql="/Library/StartupItems/MySQLCOM/MySQLCOM stop"

# Ignores dupes in the history
export HISTCONTROL=ignoredups

# After each command, checks the windows size and changes lines and columns
shopt -s checkwinsize

# git_branch=`git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1) /'`
# export PS1="\w \[\033[31m\]\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`\[\033[37m\]$\[\033[00m\] "
export PS1="\w \[\033[31m\]\`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\\\\\*\ \(.+\)$/\(\\\\\\\\\1\)\ /\`\[\033[37m\]$\[\033[00m\] "

# save directory shortcuts
# if doesn't exist, create it
if [ ! -f ~/.dirs ]; then  
	touch ~/.dirs
fi
save (){
	command sed "/!$/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ; 
}
# Initialization for the above 'save' facility: source the .sdirs file
source ~/.dirs
# set the bash option so that no '$' is required when using the above facility
shopt -s cdable_vars

# Change to the front folder open in Finder
function ff {
  osascript -e 'tell application "Finder"'\
 -e 'if (0 < (count Finder windows)) then'\
 -e 'set finderpath to get target of the front window as alias'\
 -e 'else'\
 -e 'set finderpath to get desktop as alias'\
 -e 'end if'\
 -e 'get POSIX path of finderpath'\
 -e 'end tell';};\
function cdff { cd "`ff $@`"; };

# Quickly Extract an Archive
xtract(){
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar x $1     ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
			*.tgz)       tar xvzf $1    ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)           echo "Unable to extract '$1'" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

updates(){
	brew update;
	brew install `brew outdated`;
	rvm get head;
	rvm reload;
	gem update;
}

uptime_penis(){
#	uptime | awk '{printf"8%"$3"sD\n",p}'|tr ' ' '=';
	a=`uptime` a=${a#*p } a=${a%% *}; p=''; while((a--));do p=${COLOR_NC}=$p;done;echo -e ${COLOR_LIGHT_BLUE}8${p}${COLOR_LIGHT_PURPLE}D${COLOR_NC}
};

flush_dns(){
	dscacheutil -flushcache
}

ximgopt(){
	in_path=$1
	# JPEGs
	# http://www.ijg.org/
#	for i in $in_path/*.jpg; do
#		jpegtran -copy none -optimize "$i"
#	done
	for i in $in_path/*.jpg; do
		jpegoptim --strip-all -o "$i"
	done

	# PNGs
	# http://www.advsys.net/ken/util/pngout.htm
	# http://optipng.sourceforge.net/manual.html
	# http://advancemame.sourceforge.net/doc-advpng.html
	for i in $in_path/*.png; do
		advpng -z -4 "$i"
	done
	for i in $in_path/*.png; do
		optipng -q -zc1-9 -zm1-9 -zs0-3 -f0-5 "$i"
	done
	for i in $in_path/*.png; do
		pngout "$i" -s0 -k0 -y
	done
	
	# GIFs
	# http://www.lcdf.org/gifsicle/man.html
# 	for i in $in_path/*.gif; do
# 		gifsicle -O3 "$i"
# 	done
}

# aliases
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'
alias cpu='top -o cpu'
alias show='cat ~/.dirs'
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias g='grep -i' #case insensitive grep
alias f='find . -iname'
alias top='top -o cpu'
alias systail='tail -f /var/log/system.log'
alias ducks='du -cks * | sort -rn|head -11' # Lists the size of all the folders and files
alias drives='df -h' #'diskutil list' # List all mounted drives and their partitions

# git autocomplete
alias gco='git co'
alias gci='git ci'
alias grb='git rb'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.