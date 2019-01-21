logfile=/export/LogFile/svn_update.log
echo "" > $logfile
echo $(date) >> $logfile
svn cleanup /JDSU/Product
svn update /JDSU/Product >> $logfile
svn cleanup /Import/FBN
svn cleanup /Import/CTH 
svn update /Import/FBN >> $logfile
svn update /Import/CTH >> $logfile
echo "" >> $logfile
