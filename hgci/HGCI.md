# Home Grown CI Server

A custom-built CI server - potential alternative to use in place of Jenkins.
HGCI can be integrated with GitHub to run automatically on any PR, or can be
run manually.

Inspired by: https://developer.github.com/guides/building-a-ci-server/

Tested with: https://github.com/andyl/citest  

HGCI runs end-to-end:
- takes webhooks from GitHub on checkins and PR's
- runs the CI suite and reports status
- displays the console text in a web app, linked from github

HGCI can also be used from the command-line to execute test runs for a
particular sha.

    ./hgci/run_ci <sha>

## Running HGCI

- create a Personal Access token - add it to your .gitconfig file

    [github]
    patoken = "<your token>"

- install the dependencies (`bundle install`)

- start the server dashboard (`./hgci/dashboard`)

- add a webhook to your repo (see citest repo for example)

- create commits and PR's

- profit

## Details

How to handle simultaneous requests?

- There is a simple job queue (file based)
- There is a worker process that pulls jobs from the queue

How to report status to github?

- Use the github api
- HGCI sends status updates (pending, success, error)
- HGCI sends URL to the logfile results

How/where to display the logfile results?

- Logfile results are saved on disk
- There is a webapp that renders a logfile result
- The app is linked to github

How to handle multiple test slaves?

- This is part of the API Spec!!  See
  https://robots.thoughtbot.com/multiple-ci-services-on-a-github-pull-request
- Use one webhook for everyone that wants to run HGCI

## TODOs

- Make a better way to start HGCI
- Add some sort of monitoring/restart ability to HGCI
- Add a cron process to periodically clean up history files
- Better documentation for how to setup the webhooks in GitHub
- A script to launch HGCI upon machine boot
- etc.
