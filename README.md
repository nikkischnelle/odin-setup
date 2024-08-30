# Odin Setup Playbooks
These are old ansible playbooks for setting up my server.
It:
- Sets up Postfix so it sends emails via an external SMTP server
- Installs ZFS on Fedora Server and Rhel 9
- Sets up ZED (ZFS alerts via email) and tests them
- Installs my ZSH configuration
- Sets up ZFS Auto Snapshotting
- Sets up SMART alerts

I no longer use these, as I have moved to a Promox-based setup with CEPH, but I might reuse some things from here for Virtual Machines and LXC Containers.