#!/bin/bash

read -p "Enter the user to check: " user
echo "Testing for $user: "
echo " "

if id "$user" >/dev/null 2>&1; then
    echo "User found"
    exit 0
else
    echo "not found"
    exit 2
fi
