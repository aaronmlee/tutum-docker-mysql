#!/bin/bash
echo "SELECT NOW()\G" | mysql -uroot -h127.0.0.1 mysql >> /var/log/check_mysql.log 2>&1 && exit 0
