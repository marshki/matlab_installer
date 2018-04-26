#!/bin/bash

# Ping local web to see if it is reachable.

LOCAL_WEB="128.122.112.23"

function ping_local_web () {

        printf "%s\n" "Pinging local web..."

        if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
                printf "%s\n" "1; reachable. Continuing..."
        else
                printf "%s\n" "0; unreachable. Exiting."
                exit 1
fi
}

ping_local_web
