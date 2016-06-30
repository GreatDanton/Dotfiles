#!usr/bin/python3

from datetime import timedelta
import sys
# uptime provdided via arguments

with open('/proc/uptime', 'r') as f:
    uptime_seconds = float(f.readline().split()[0])


hours = 0
minutes = 0
days = 0
# get amount of hours, minutes
#for i in range(len(uptime)):
#    amount = uptime[i][:-1]
#    if 'h' in uptime[i]:
#        hours += int(amount)
#    elif 'm' in uptime[i]:
#        minutes += int(amount)

# uptime in seconds
#uptime_seconds = (hours * 60 * 60) + (minutes * 60)

# time to work in seconds
time_to_work = 28800

seconds_left = time_to_work - uptime_seconds
hours_left = int(seconds_left // 3600)
seconds_left -= hours_left * 3600
minutes_left = int(seconds_left // 60)

if minutes_left < 10:
    minutes_left = str('0' + str(minutes_left))

print(str(hours_left)+'h ' + str(minutes_left)+'m')
