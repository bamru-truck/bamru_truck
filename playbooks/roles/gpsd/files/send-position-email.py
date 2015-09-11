#!/usr/bin/python
import gps
 
import sys, time, re
from socket import *
import smtplib
from smtplib import SMTPException

# Example google URL
# https://maps.google.com/maps?ll=37.405701,-122.325119&q=37.405701,-122.325119&hl=en&t=m&z=15
 
#class gpsfloat(infloat):
def gpsfloat(infloat):
#    def __str__(self):
    print("%.6f" % infloat)
    return "%.6f" % infloat 

# Listen on port 2947 (gpsd) of localhost
session = gps.gps("localhost", "2947")
session.stream(gps.WATCH_ENABLE | gps.WATCH_NEWSTYLE)

sender = 'mgregg@michaelgregg.com'
receivers = 'mgregg@michaelgregg.com'

def send_email( lat, lon, sender, reciever ):
    try:
        message = """From: From Person <--sender-->
To: To Person <--to-->
Subject: SMTP e-mail test position
Mime-Version: 1.0;
Content-Type: text/html; charset="ISO-8859-1";
Content-Transfer-Encoding: 7bit;
<html>
<body>

Current position is <a href="https://maps.google.com/maps?ll=--lat--,--lon--&q=--lat--,--lon--&hl=en&t=m&z=15">-Location-</a>

This is a test e-mail message.
</body>
</html>
"""
        message = re.sub(r"--sender--", sender, message)
        message = re.sub(r"--to--", reciever, message)
        message = re.sub(r"--lat--", lat, message)
        message = re.sub(r"--lon--", lon, message)
        smtpObj = smtplib.SMTP('localhost')
        smtpObj.sendmail(sender, receivers, message)         
        print "Successfully sent email"
	exit(0)
    except SMTPException:
        print "Error: unable to send email"

while True:
    try:
    	report = session.next()
		# Wait for a 'TPV' report and display the current time
		# To see all report data, uncomment the line below
		# print report
        if report['class'] == 'TPV':
            if hasattr(report, 'time'):
                print report.time
		print report
		print dir(report)
		lat = gpsfloat(report.lat * 100)
		lon = gpsfloat(report.lon * 100)
#                pposition = "=%s%s/%s%s-" % ( lat, latd, lon, lond )
#                print pposition
                # Now we have the position collected properly. Now, report it. 
                while 1:
                    send_email(lat, lon, sender, receivers)
		quit(0)
    except KeyError:
		pass
    except KeyboardInterrupt:
		quit(0)
    except StopIteration:
		session = None
		print "GPSD has terminated"
		quit(1)
