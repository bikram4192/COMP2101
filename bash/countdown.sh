#!/bin/bash

# This script demonstrates how to trap signals and handle them using functions

# Task: Add traps for the INT and QUIT signals. If the script receives an INT signal,
#       reset the count to the maximum and tell the user they are not allowed to interrupt
#       the count. If the script receives a QUIT signal, tell the user they found the secret
#       to getting out of the script and exit immediately.
trap reset 2
trap foundsecret 3
# Task: Explain in a comment how the line with the word moose in it works.
function foundsecret {
  echo "found secret to getting out of script."
  exit
}
#### Variables
programName="$(basename $0)"
sleepTime=1
numberOfSleeps=10


function error-message {

        echo "${programName}: ${1:-Unknown Error - a moose bit my sister once...}" >&2
}


function error-exit {
        error-message "$1"
        exit "${2:-1}"
}
function usage {
        cat <<EOF
Usage: ${programName} [-h|--help ] [-w|--waittime waittime] [-n|--waitcount waitcount]
Default waittime is 1, waitcount is 10
EOF
}

#### Main Program


while [ $# -gt 0 ]; do
    case $1 in
        -w | --waittime )
            shift
            sleepTime="$1"
            ;;
        -n | --waitcount)
            shift
            numberOfSleeps="$1"
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            error-exit "$1 didn't recognize this option"
    esac
    shift
done

if [ ! $numberOfSleeps -gt 0 ]; then
    error-exit "$numberOfSleeps is not a better count of sleeps to wait for signals"
fi

if [ ! $sleepTime -gt 0 ]; then
    error-exit "$sleepTime is not a good time to sleep while waiting for signals"
fi

sleepCount=$numberOfSleeps
function reset {
  echo " you cannot interrupt the count ."
  sleepCount=$(($numberOfSleeps+1))
}
while [ $sleepCount -gt 0 ]; do
    echo "Counting... $sleepCount left for signals"
    sleep $sleepTime
    sleepCount=$((sleepCount - 1))
done
echo "counter is completed, counter exited"
