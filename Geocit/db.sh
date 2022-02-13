#!bin/bash

dbuser='postgres'
dbhost='192.168.1.102'
dbport=5432

psql --host=$dbhost --port=$dbport --username=$dbuser -c 'DROP DATABASE ss_demo_1;'
psql --host=$dbhost --port=$dbport --username=$dbuser -c 'CREATE DATABASE ss_demo_1;'
