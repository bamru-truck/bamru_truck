# GitHub CI Server

WORK IN PROGRESS - do not use in production.

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

## Questions

### How to handle simultaneous requests?

Custom Job queue - using a server and a worker process

### How/where to display the logfile results?

The logfile results should be stored and managed in the CI Server.  When
reporting an error status, reference the Error Message URL in the status
update.  

### How to handle multiple test slaves?

This is part of the API Spec!!  See:
https://robots.thoughtbot.com/multiple-ci-services-on-a-github-pull-request

## Other References

GitHub Status API:
https://developer.github.com/v3/repos/statuses/

