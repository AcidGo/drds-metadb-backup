#!/bin/bash
# Author: AcidGo
# Version: 0.0.1
# Todo: 定期备份 metadb 数据库，并清理30天以前的旧备份文件

LOG=/usr/local/mysql-5.6/backup/metadb_backup.log

function do_log {
    LOG_TIME=$(date "+%Y%m%d_%H%M%S")
    echo "${LOG_TIME} $@" >> $LOG
}


NOW=$(date "+%Y%m%d")
do_log "[info] Start exectue the scripts."


/usr/local/mysql-5.6/bin/mysqldump -uroot  -A > /usr/local/mysql-5.6/backup/${NOW}_backup.sql
status=$?

if [ "$status" == "0" ];then
    do_log "[info] Successly backup [${NOW}_backup.sql]."
else
    do_log "[error] Failed to backup."
fi

do_log "[info] Start to rm old bak."

for i in `find /usr/local/mysql-5.6/backup -type f -iname "*_backup.sql" -mtime +30 -exec ls  {} \;`;do
    # debug
    #echo $i
    rm -f $i
    do_log "[info] Rm $i"
done

do_log "[info] Finish."