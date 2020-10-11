#!/bin/bash

config() {
    val=$(grep -E "^$1=" pitunnel.conf 2>/dev/null || echo "$1=__DEFAULT__" | head -n 1 | cut -d '=' -f 2-)

    if [[ $val == __DEFAULT__ ]]
    then
        case $1 in
            remote_host)
                echo -n "localhost"
                ;;
            remote_user)
                echo -n "mn"
                ;;
            remote_port)
                echo -n "8000"
                ;;
        esac
    else
        echo -n $val
    fi
}

remote_host=$(config remote_host)
remote_user=$(config remote_user)
remote_port=$(config remote_user)

# some helpful debug info
echo "Connecting to '${remote_host}' as user '${remote_user}'..."
echo "Tunnel will be created on '${remote_host}'s port '${remote_port}'"

# actually run autossh
autossh -M 0 -o ServerAliveInterval=20 -o "ExitOnForwardFailure=yes" -nNT -R ${remote_port}:localhost:22 ${remote_user}@${remote_host}

