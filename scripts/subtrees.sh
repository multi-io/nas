if [ "$(echo $BASH_VERSION | sed 's/^\(.\).*/\1/')" -lt 4 ]; then
    echo "Bash 4 or higher needed" >&2;
    exit 1;
fi

declare -A subtrees  # map subdirname => remote

subtrees['host']='olaf@tackd.:/home/olaf/gitrepos/devboxadmin.git'
