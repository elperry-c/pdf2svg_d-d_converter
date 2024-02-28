#!/bin/sh

if [ -e "/etc/fonts/local.conf" ]; then
    echo "/etc/fonts/local.conf already exists."
    echo "Please merge fonts_local.conf to /etc/fonts/local.conf"
    exit 1
else
    sudo cp fonts_local.conf /etc/fonts/local.conf
    echo "Copied fonts_local.conf to /etc/fonts/local.conf"
    exit 0
fi
