# ----- foreman app processes -----
AP01:4:respawn:/bin/su - app -c 'cd /home/aleak/lr/bamru_truck/app;export PORT=5000;ruby app.rb >> /var/log/app/web-1.log 2>&1'
# ----- end foreman app processes -----
