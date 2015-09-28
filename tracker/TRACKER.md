# TRACKER Web App

Every hotspot sends a heartbeat to the TRACKER app once a minute.  The
heartbeat is a HTTP Post with JSON values like deviceId, lat, lon, speed, time,
freeMemory, freedisk, numConnections.

TRACKER performs two functions: 

  1) Data Presentation: showing the device data on maps and tables

  2) Alerting: sending alert emails to administrators when system values exceed
     a threshold.

## Installing TRACKER on your Dev Server

- install the system dependencies (`bin/setup_dev_server`)

- install the dependencies (`cd tracker ; bundle install`)

- start the server dashboard (`./tracker/dashboard`)

- visit http://45.79.82.37  (pwd=admin/werescue)

- profit

## TODOs

- A script to launch TRACKER upon machine boot
- Add some sort of log-rotation
- etc.
