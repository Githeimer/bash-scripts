# Firewall setup with ufw on a home Ubuntu server

## What I set up

- **Machine:** an old Acer Aspire One running Ubuntu Server, used as a home server.
- **SSH:** key-only login (`PasswordAuthentication no`).
- **Remote access:** Tailscale, so the server is reachable at a stable `100.x` address.
- **Goal:** block all new incoming connections except SSH and one test web port, and allow that port only from my home network and my Tailscale devices.

## Commands, in order

```bash
sudo ufw default deny incoming
```
Drops new connections from outside unless a rule allows them. Only records the policy while ufw is inactive.

```bash
sudo ufw default allow outgoing
```
Lets the server start its own connections (`apt`, Tailscale, DNS). Replies to them are allowed back in because ufw is stateful.

```bash
sudo ufw allow 22/tcp
```
Allows SSH. This has to exist before the firewall is enabled, or enabling it cuts off my own session.

```bash
sudo ufw show added
```
Lists queued rules before enabling. I checked that `22/tcp` was there.

```bash
sudo ufw enable
```
Turns the firewall on now and at every boot.

```bash
sudo ufw allow from 192.168.110.0/24 to any port 8000 proto tcp
sudo ufw allow from 100.64.0.0/10 to any port 8000 proto tcp
```
Opens port 8000 only to my home subnet and to the Tailscale address range, not to everyone.

## Final state

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
8000/tcp                   ALLOW IN    192.168.110.0/24
8000/tcp                   ALLOW IN    100.64.0.0/10
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

## What I tested

- Ran a Python web server on port 8000 bound to `0.0.0.0` and reached it from my main laptop. It worked after the rules above were in place.
- **Pending:** a clean SSH login from a second terminal after enabling the firewall. My first attempt timed out because of packet loss on the server's wifi, so it says nothing about the `22/tcp` rule.
- **Pending:** showing a blocked connection. I only have two machines, and both match an allow rule.

## What I learned

- **Allow SSH before enabling the firewall.** Otherwise a remote session can lock itself out.
- **A rule's `from` is the source of the connection,** not the address being connected to. A rule `from 100.83.213.93` on the server itself matches nothing, because that is the server's own address.
- **A service needs both a firewall rule and a matching bind address.** Python bound to `127.0.0.1` rejects connections even when the firewall allows them.
- **The firewall works on ports, not programs.** Opening 8000 opens it for whatever listens there.

## A problem I ran into

The server felt very slow over SSH, but `vmstat` showed the CPU, disk and swap idle. A 20-packet ping from my laptop showed 30% packet loss and spikes up to 180 ms, and an SSH login failed with "timed out during banner exchange". That points at the wifi link, not the machine. I suspect the wifi driver but haven't confirmed it. The next test is the same ping over an ethernet cable.
