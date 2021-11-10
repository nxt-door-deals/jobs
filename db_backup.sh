# The script will take a nightly backup of the nxtdoordeals database
# The script runs under the postgres user
# Add the db_name prior to running

db_name=
backupfolder=~/db_backup/backups
keep_days=30
backup_log=~/db_backup/log.txt

sqlfile=$backupfolder/$db_name-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/$db_name-$(date +%d-%m-%Y_%H-%M-%S).zip

mkdir -p $backupfolder

if pg_dump $db_name > $sqlfile ; then
   echo "\"$(date)\" - The backup was created successfully" >> $backup_log
else
   echo "\"$(date)\" - No database backup was created!" >> $backup_log
   exit
fi

if gzip -c $sqlfile > $zipfile; then
   echo "\"$(date)\" - The backup was compressed successfully" >> $backup_log
else
   echo "\"$(date)\" - The backup was not compressed!" >> $backup_log
   exit
fi

rm $sqlfile
echo -e "\n" >> $backup_log

find $backupfolder -mtime +$keep_days -delete