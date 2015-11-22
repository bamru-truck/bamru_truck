#!/bin/bash
. /opt/ros/indigo/setup.bash
/usr/bin/python /bin/get_motor_state.py --motor=$1 --prop=t
