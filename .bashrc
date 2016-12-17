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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

alias vi="vim"
export RTE_SDK=/home/nagp/Downloads/dpdk-2.2.0
export RTE_TARGET=/home/nagp/Downloads/dpdk-2.2.0/x86_64-native-linuxapp-gcc
export APP_CMDLINE="-c 0x0c --vdev=eth_pcap0,iface=eth0 --huge-dir /mnt/huge"
export DPDK_BUILD="sudo make install T=x86_64-native-linuxapp-gcc"
alias vgdir="cd /home/nagp/Downloads/vpp/vpp/build-root/vagrant"

function gitRep()
{
	if [[ $# -ne 1 ]];
	then
		echo "Usage: gitRep <repoName>"
		return
	fi

	repoName=$1
	git clone git@nd.rtbrick.com:${repoName}
}

function gitPull()
{
	if [[ $# -ne 1 ]];
	then
		echo "Usage: gitPull <rootDir>"
		return
	fi

	rootDir=$1
	cd ${rootDir}
	repoList=`ls`
	for i in $repoList;
	do
		if [[ -d $i ]];
		then
			if [[ $i == "cscope" || $i == "vpp" || $i == "OpenNSL" || $i == "avl" || $i == "bcm-sdk" || $i == "SAI" || $i == "wedge-ringup" || $i == "thrift" ]];
			then
				echo "Skipping $i .."
				# Skip the cscope directory
				continue
			fi
			echo -n "Refreshing ${i} .."
			cd ${i}
			git pull >& /dev/null
			cd ~-
			echo " [OK]"
		fi
	done
}

function gencs()
{
	cscopeDir=~/development/cscope
	if [[ $# -eq 1 ]];
	then
		csopeDir=$1
	fi

	if [[ ! -d $cscopeDir ]];
	then
		echo "Creating cscope directory at $cscopeDir .."
		mkdir $cscopeDir
	fi

	echo "Building list of files..."
	cd ~/development
	dir=`pwd`
	find $dir -name \*.[ch] > $cscopeDir/cscope.files

	echo "Building cscope and ctags data.."
	cd $cscopeDir
	cscope -bqk -i cscope.files
	ctags -L cscope.files
	cd ~-

	echo "Done.."
}

alias csc="cd ~/development/cscope;cscope -d;cd ~-"
alias vppsc="cd /home/nagp/development/vpp;cscope -d;cd ~-"
alias dpsc="cd /home/nagp/development/dpdk-16.07;cscope -d;cd ~-"
alias plugin_clean="rm -rf aclocal.m4 autom4te.cache/ compile config.guess config.log config.status config.sub configure depcomp install-sh libtool ltmain.sh Makefile Makefile.in *.la missing"
alias pcapcsc="cd ~/Downloads/libpcap-1.7.4;cscope -d;cd ~-"
alias london="ssh -l ubuntu 10.0.3.208"
alias paris="ssh -l ubuntu 10.0.3.95"
alias newyork="ssh -l ubuntu 10.0.3.126"
alias grep="grep -n"
alias kamet="ssh kamet"
export PATH=$PATH:/home/nagp/Downloads/todo.txt_cli-2.10

function setips()
{
	sudo route add 10.0.3.254/32 gw 192.168.1.5
	sudo route add 10.0.3.39/32 gw 192.168.1.5
	sudo route add 10.0.3.209/32 gw 192.168.1.5
	sudo route add 10.0.3.12/32 gw 192.168.1.5
	sudo route add 10.0.3.194/32 gw 192.168.1.5
	sudo route add 10.0.3.193/32 gw 192.168.1.5
}

alias clock="sudo killall unity-panel-service"
alias ansicheck="ansible-playbook --syntax-check"
alias ansiplay="ansible-playbook"
alias ansilist="ansible-playbook --list-tasks"

# Function to resize pics to given proportion (in percentage)
function resize_pics()
{
	if [[ $# -ne 2 ]];
	then
		echo "Usage: resize_pics <folder> <percent> (eg. resize_pics /home/pics/foo_bar 30 # to resize pics to 30%)"
		return
	fi

	folder=$1
	percent=$2

	cd $folder
	files=`ls`
	for i in $files;
	do
		echo "Resizing ${i} .. "
		convert ${i} -resize "${percent}%" ${i}
	done
}

alias london="ssh ubuntu@london"
alias paris="ssh ubuntu@paris"
alias k10="ssh nagp@192.168.1.6"
alias bsdk="cd /home/nagp/development/bcm-sdk/sdk-all-6.5.5"
export RTBRICK_GIT_REPO=nd.rtbrick.com
export RTBRICK_DEV_DIR=~/development
alias lfd="cd ~/development/libfwdd"
alias fd="cd ~/development/fwdd"
alias build="git pull;cmake .;make clean;sudo make install_hdr;sudo make install_libs;sudo make install"

