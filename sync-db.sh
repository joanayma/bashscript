#!/bin/bash
# A really simple script to clone as many as mysql db defined, every with user/passwd.

declare -A mysql_users mysql_passwds

mysql_host="origin_name_or_ip"

mysql_users["db1"]="user1"
mysql_passwds["db1"]="simple_pass"
mysql_users["some_db"]="other_user"
mysql_passwds["some_db"]="complex_pass"

databases=("db1" "some_db")

mysql_local_user="some_superuser"
mysql_local_passwd='really_complex_passwd'

for database in "${databases[@]}"; do
  echo dumping $database...
  mysqldump -c -C --add-drop-table -h $mysql_host -u ${mysql_users[$database]} -p${mysql_passwds[$database]} $database |\
  mysql -f $database -u $mysql_local_user -p$mysql_local_passwd || (echo "Error on dumping $database" && exit 1)
  echo OK $database
done > /var/log/sync-db.log

exit 0
