#!/bin/sh

# Postgres
mkdir /var/lib/postgresql/data && chown postgres:postgres /var/lib/postgresql/data
chmod 0700 /var/lib/postgresql/data && mkdir /run/postgresql && chown postgres:postgres /run/postgresql/
su -l postgres -c 'initdb -D /var/lib/postgresql/data'
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/postgresql/data/postgresql.conf

echo -e "host    all             all             0.0.0.0/0               md5\nhost    all             all             ::/0                    md5" >> /var/lib/postgresql/data/pg_hba.conf


## Create user and db
db_user=postgres
db_pass=postgres
db_base=ss_demo_1

su -l postgres -c 'pg_ctl start -D /var/lib/postgresql/data'
su -l postgres -c "psql -c \"CREATE DATABASE $db_base;\""
su -l postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $db_base to $db_user;\""
su -l postgres -c "psql -c \"ALTER USER $db_user WITH PASSWORD '$db_pass';\""


# Supervisor
supervisord -c /etc/supervisord.conf

supervisor_name=admin
supervisor_pass=admin

sed -i "s/;\[inet_http_server\]/[inet_http_server]/g" /etc/supervisord.conf
sed -i "s/;port=127.0.0.1/port=*/g" /etc/supervisord.conf
sed -i "s/;username=user/username=$supervisor_name/g" /etc/supervisord.conf
sed -i "s/;password=123/password=$supervisor_pass/g" /etc/supervisord.conf
mkdir /etc/supervisor.d