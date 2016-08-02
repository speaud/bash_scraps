## Global Helper Methods

	_prompt(){
		printf "$sii $1"
	}

	_surpress(){
		(eval $1) &>/dev/null &
		spinner $! "$sii $2 "
	}

	_warning(){
		printf "$sii \e[93mWARNING: The etc/debug value '$1' is enabled. The '$2' process was skipped. $light \n"
	}

	_unmount(){
		(net use $1: //delete //yes) &>/dev/null &
		[[ $2 ]] && spinner $! "$sii $2 "
	}

	## Prints out data
	# @returns  {string}
	# @note     there's probably a better way to go about this
	#
	devDebug(){
		[[ ! $2 ]] && msg="No Details" || msg=$2
		[[ $debug -eq 1 ]] && printf "\n\e[1;37;44m$1:\n\t$msg\033[0m\n"
	}

	## Loading Icon, shows the animated "[\]" thing
	# @param    {int}    as $1 - Process ID (PID) of last running task
	# @param    {string} as $2 - Inline description to be displayed before the loading icon
	#
	spinner(){
		local pid=$1
		local sp="/-\!"
		printf "$2 [ "
		while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		  printf "\b${sp:a++%${#sp}:1}]\b"
		  sleep 0.05
		done
		printf "\b\e[32mOK$light]\n"	
	}
	
	## Display formatted error and re-run function after failed attempt
	# @{param}  {string}    as $1 - Error message to be displayed
	# @{param}  {function}  as $2 - Function name to re-run
	errorOccured(){
		printf "$sii $errwarn ERROR: $1 $light"
		[[ $2 ]] && $2
	}
	
	floor() {
	  DIVIDEND=${1}
	  DIVISOR=${2}
	  RESULT=$(( ( ${DIVIDEND} - ( ${DIVIDEND} % ${DIVISOR}) )/${DIVISOR} ))
	  echo ${RESULT}
	}

	timecount(){
	  s=${1}
	  HOUR=$( floor ${s} 60/60 )
	  s=$((${s}-(60*60*${HOUR})))
	  MIN=$( floor ${s} 60 )
	  SEC=$((${s}-60*${MIN}))
	  while [ $HOUR -ge 0 ]; do
      while [ $MIN -ge 0 ]; do
          while [ $SEC -ge 0 ]; do
            printf "$sii Deploying to Test in %02d:%02d:%02d\033[0K\r" $HOUR $MIN $SEC
            SEC=$((SEC-1))
            sleep 1
          done
        SEC=59
        MIN=$((MIN-1))
      done
      MIN=59
      HOUR=$((HOUR-1))
	  done
	  printf "\n"
	}  	