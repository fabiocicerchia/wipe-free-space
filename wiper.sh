#!/bin/bash

ROUNDS=1
SOURCE=/dev/zero
PID=

while getopts ":hsr:" opt; do
    case ${opt} in
        h )
            echo "WipeFreeSpace"
            echo "(C) 2020 Fabio Cicerchia."
            echo ""
            echo "Usage:"
            echo "$0 [-r X] [-s]"
            echo "  -r X   Number of rounds"
            echo "  -s     Secure way (uses random instead of zero fillings)"
            exit 0
            ;;
        s )
            SOURCE=/dev/urandom
            ;;
        r )
            ROUNDS=$OPTARG
            ;;
    esac
done

function sighdl {
    echo "*** SIGNAL CAUGHT ***"
    if [ $PID -gt 0 ]; then
        kill -9 $PID
    fi
    exit 0
}
trap sighdl SIGKILL SIGINT SIGTERM

function progress_bar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

echo "Wiping..."

for i in $(seq 1 $ROUNDS); do
    echo "ROUND #$i / $ROUNDS"

    dd if=$SOURCE of=x.small.file bs=1024 count=102400
    shred -vz x.small.file

    _start=1
    _end=`df -k . | tail -n1 | awk '{print $4}'` # FREE SPACE ON DISK
    cat $SOURCE > x.file 2> /dev/null &
    PID=$!
    sleep 0.5
    while [ $(ps -p $PID | wc -l) -eq 2 ]; do
        _current=`du -k x.file | cut -f1`
        progress_bar ${_current} ${_end}
        sleep 0.5
    done

    sync
    rm x.small.file
    shred -vz x.file
    sync
    rm x.file
done

echo "Done"
