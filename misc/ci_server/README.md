# Experimental CI Server

An experiment to test the feasability of a custom-built CI server to use in
place of Jenkins.

Inspired by: https://developer.github.com/guides/building-a-ci-server/

Tested with: https://github.com/andyl/citest  

## Learnings

PROS:
- could do everything that Jenkins does
- could be faster and simpler than Jenkins

CONS:
- requires work to build and maintain

## Setup

To run:

- create a Personal Access token - add it to your .gitconfig file

    [github]
    patoken = "<your token>"

- install the dependencies (`bundle install`)

- run the server (`rackup`)

- start port forwarding (`bin/portfwd 9292 9292`)

- add a webhook to your repo (see citest repo for example)

- create commits and PR's

- profit

## TBDs

- how to handle simultaneous requests?
- how/where to display the logfile results?
- how to handle multiple test slaves?
- etc.
