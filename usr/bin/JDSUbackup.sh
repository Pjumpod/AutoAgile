#!/usr/bin/ksh
tar cvf /home/agupdate/Backup$(date +%Y%m%d_%H%M%S).tar /etc/apache2/ /usr/bin/JDSU* /usr/bin/SVN* /etc/crontab /etc/cron.hourly/SVNupdate.sh /usr/bin/DCA* /home/export/DCA/index.php /usr/bin/temp*
