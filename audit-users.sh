#!/bin/bash

users=("himesh" "suresh" "ramesh" "financeGuy")
total="${#users[@]}"
found=0

for i in "${users[@]}"; do
	if (id "$i" >/dev/null 2>&1); then
		found=$((found + 1))
		shell=$(grep "^$i:" /etc/passwd | cut -d: -f7)
		group=$(groups "$i" | cut -d: -f2)
		echo "groups_info: $group and bashinfo: $shell"
	fi
done

notfound=$((total-found))
echo "Found $found users and $notfound were not found"
