# Pair Programming

This note explains how to setup your development laptop (NFS Server) for remote
access using Port Forwarding and Wemux.

+-----------------+-----------------------------------------------------+
| Tool            | Purpose                                             |
+-----------------+-----------------------------------------------------+
| Port Forwarding | to expose your dev machine(s) outside your firewall |
| Wemux           | for shared console sessions (command line and vim)  |
+-----------------+-----------------------------------------------------+

## Installing WeMux 

The ansible role for Tmux also installs and configures Wemux.

# Port Forwarding 

Use Port Forwarding to expose your development machine to people outside your
firewall.

The ip address of the public server is 45.79.82.37.  Ask Andy for a user
account.

The script `bin/portfwd` sets up ports.  Use these port values:

| DESCRIPTION                    | Remote/Proxy Port | Local Port |
| web_admin (production server)  | 4567              | 4567       |
| web_admin (development server) | 4568              | 4568       |
| ssh                            | 2222              | 22         |

## Port Forwarding / Web Access

Server configuration should work out of the box:  

- start a webservice on your laptop that listens on port 4567
- run `bin/portfwd 4567 4567`

Client test: in a separate browser, visit "45.79.82.73:4567"

## Port Forwarding / SSH Access

For console/vim sharing, you need to give your programming partner SSH access
to your development machine.

Setup account for outside developer:

    > sudo adduser <username>                              # create user
    > echo wemux rogue ; exit >> /home/<username>/.bashrc  # only allow wemux

When your programming partner SSH's to your system, only wemux will run.

## Using WeMux

Session Host:

  > ./bin/portfwd 2222 22              # start port forwarding
  > wemux start                        # start wemux session

Remote Partner:

  > ssh <username>@45.79.82.37

