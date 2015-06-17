# Web Admin

A web application that runs the network selection scripts, to switch between
Ethernet, WIFI and 3G.

## Server Software

The App is build using a web framework called 'Sinatra', written in Ruby.

Learn more about Sinatra at http://www.sinatrarb.com/

## Webapp Init/Start/Stop/Reset

Check the Ansible role `web_admin` to see the install procedure and the
start/stop script.

## Local Development and Testing

To set up a local development environment on Ubuntu:

+--------------------+-------------------------------------+-----------------------------+
| Step               | Command                             | Comment                     |
+--------------------+-------------------------------------+-----------------------------+
| 1) Install Ruby    | > sudo apt-get install ruby         | installs Ruby 1.9.3         |
| 2) Install Bundler | > sudo apt-get install ruby-bundler | see notes...                |
| 3) Install Gems    | > bundle install                    | loads everything in Gemfile |
| 4) Run the app     | > bin/run                           | runs the app on port 4567   |
+--------------------+-------------------------------------+-----------------------------+

notes:
- may be accomplished with "sudo gem install bundler"
- might run this without `sudo`
- this installs all the support software in the `Gemfile`

## Deploying Changes

1) test and check in your edits
2) go to the ansible directory `cd playbooks`
3) re-run the ansible installer `./config nopass`

## Running the Live App

In your browser:

http://<server-name-or-ip>:4567

