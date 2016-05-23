#!/bin/bash

# Shell Library - bashlib
# Used to store regular and repeated commands that can be imported
# into other bash scripts by way of the `source` command.
#
# usage:
# inside a script you wish to make use of this library...
# `source bashlib -args`
#
# arguments:
# 	-v : 	Verbose enabled, when using log, will also print to console.
# 	-n : 	Invoking script name, this will be used to identify your script
# 				in the logs.
# 	-l :	Set log path to new value
# 	-p :  Enables the use of terminal-notifier for push notifications
# 	-o :  Use Pushover to send notifications
#



# Core Script Values
VERSION=1.0.1
ARGSLENGTH=4











# Setting Default Values
BASELOGPATH=~/Library/Logs/bashlib
LOGPATH=$BASELOGPATH
FILENAME="bashlib"
VERBOSE=0;					# If verbose calls return to the terminal or just are entered in the log
TN=0 								# Default value, set when terminal-notifier is found - version checked: 1.6.3
TNOVERRIDE=1				# Use terminal-notifier if present
TRIGGER=0						# Forces scrip to exit if the name is not present
PUSHO=0















if [[ ! -d $LOGPATH ]]; then
	mkdir $LOGPATH
fi

if [[ -d /Library/Ruby/Gems/2.0.0/gems/terminal-notifier-1.6.3 ]]; then
	TN=1
fi





















# Core Functions
# ==================================================================== #
# Main Functions of Bashlib
# ==================================================================== #



log() {
	if [[ $VERBOSE == 1 ]]; then
		printf "\033[0;33m"
		printf "$FILENAME: $1"
		echo "\033[0m"
	fi
	touch $LOGPATH/$FILENAME.log
	echo "$(date +'%d %b %T') $FILENAME: $1" >> $LOGPATH/$FILENAME.log
}

log_file() {
 if [[ $VERBOSE == 1 ]]; then
    printf "\033[0;33m"
    printf "$FILENAME: logged file"
    echo "\033[0m"
  fi
  touch $LOGPATH/$FILENAME.log
  while read p; do
    echo "$(date +'%d %b %T') $FILENAME: $p" >> $LOGPATH/$FILENAME.log
  done < $1
}

error() {
	printf "\033[31m"
	printf "error: $2 \nexiting with error code: "
	printf "\033[0m"
	echo $1
	if [ $# -eq 2 ]; then
		echo "$(date +'%d %b %T') $FILENAME: [error: $1] $2" >> $LOGPATH/$FILENAME.log
	fi
	exit $1
}

internallog() {
	touch $LOGPATH/bashlib.log
	echo "$(date +'%d %b %T') bashlib: $1" >> $LOGPATH/bashlib.log
}

internalecho() {
	printf "\033[0;36m"
	printf "bashlib: $1"
	echo "\033[0m"
	internallog "$1"
}

notify() {
	if [[ $TN == 1 && $TNOVERRIDE == 1 ]]; then
		terminal-notifier -sender "bashlib" -message "$1" -groupid 'cs-bashlib' -subtitle "Sent by: $FILENAME"
		internallog "$1"
	fi
}

pushover() {
	curl -s \
  --form-string "token=azYRqy2oShRBykv4sYrqkqpruCxyzC" \
  --form-string "user=u8AchuxyeCpJqubzNMVxhgcm84CZjq" \
  --form-string "message=$1" \
  --form-string "title=$FILENAME" \
  https://api.pushover.net/1/messages.json
}




if [[ ! -d /Library/Ruby/Gems/2.0.0/gems/terminal-notifier-1.6.3 ]]; then
	internalecho "terminal-notifier is not found on this system.\nIt can be installed using sudo gem install terminal-notifier"
fi



for (( i = 0; i < $ARGSLENGTH; i++ )); do
	while getopts ":vpn:l:" opt; do
  case $opt in
    v)
			VERBOSE=1;
      internalecho "Verbose logging enabled"
      ;;
    n)
			internalecho "Loaded version: $VERSION"
			internalecho "Stored, $OPTARG as listed filename"
			FILENAME=$OPTARG
			TRIGGER=1
			;;
		l)
			internalecho "updated log path to: $OPTARG"
			LOGPATH=$OPTARG
			if [[ ! -d $LOGPATH ]]; then
				mkdir $LOGPATH
			fi
			;;
		p)
			if [[ $TN == 1 ]]; then
				internalecho "Push notifications have been enabled"
				TNOVERRIDE=1
			fi
			;;
    \?)
      log "Invalid option: -$OPTARG" >&2
      ;;
    :)
			error 1 "Invalid usage of bashlib, must contain -n scriptname.sh "
		;;
  esac
done
done

if [[ $TRIGGER == 0 ]]; then
	error 1 "Invalid usage of bashlib, must contain -n scriptname.sh "
fi
