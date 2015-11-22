#!/usr/bin/env python
import getopt, sys, rospy
from fetch_driver_msgs.msg import RobotState

motor = False
prop = False

def callback1(msg):
#    rospy.loginfo("Callback1 heard %s",msg.motors[0].position)
    num = int(motor) # convert the input number to a int
    #temp="motor_temp:%f" % (msg.motors[num].temperature)
    temp="%f" % (msg.motors[num].temperature)
    name = "motor_name:%s" % (msg.motors[num].name)
    position="motor_position:%f" % (msg.motors[num].position)
    motor_angle_offset_estimated="motor_motor_angle_offset_estimated:%f" % (msg.motors[num].motor_angle_offset_estimated)
    motor_ratio="motor_ratio:%f" % (msg.motors[num].motor_ratio)
    joint_ratio="joint_ratio:%f" % (msg.motors[num].joint_ratio)
    #print name, temp, position, motor_ratio, motor_angle_offset_estimated, joint_ratio
    if prop == "t":
	print temp 
    rospy.signal_shutdown("blah")

def listener():
    rospy.init_node('state_monitor')
    rospy.Subscriber("/robot_state", RobotState, callback1)
    while not rospy.is_shutdown():
        rospy.sleep(0.0001)

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hmp:v", ["help", "motor=", "prop="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-m", "--motor"):
            global motor
            motor = a
        elif o in ("-p", "--prop"):
            global prop
            prop = a
        else:
            assert False, "unhandled option"
    # ...

if __name__ == '__main__':
    try:
        main()
        if motor == False:
            print "ERROR - No motor defined with --motor=<motor number>\n"
            sys.exit()
        listener()
    except rospy.ROSInterruptException:
        pass

