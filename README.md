# bash-scripts

Bash scripts from my DevOps learning.

- `check-user.sh` (Checks whether a user exists in the system)
      read : command used to take input from user ( Takes a user's name)
      id: command prints the info abotut the user, and >/dev/null 2>&1 moves whatever the command printed to a temp file.

- `audit-users.sh` (Prints the shell used by the user)
    /etc/passwd: contains the info about user
    groups: prints the info about the groups the user is in.

- `firewall-ufw.md`: notes on setting up a ufw firewall on a home server.
