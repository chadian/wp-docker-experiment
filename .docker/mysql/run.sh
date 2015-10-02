#!/bin/bash
mysql_install_db --datadir=/var/lib/mysql
mysqld --init-file=/etc/service/mysql/create-wp-db.sql