FROM alpine

RUN apk update && apk add --no-cache postgresql12 supervisor openjdk11


##################### Postgres #####################
ENV DB_USER=postgres \
    DB_PW=postgres \
    DB_NAME=ss_demo_1

RUN  mkdir /var/lib/postgresql/data && chown postgres:postgres /var/lib/postgresql/data && \
chmod 0700 /var/lib/postgresql/data && mkdir /run/postgresql && chown postgres:postgres /run/postgresql/ && \
su -l postgres -c 'initdb -D /var/lib/postgresql/data' && \
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/postgresql/data/postgresql.conf && \
echo -e "host    all             all             0.0.0.0/0               md5\nhost    all             all             ::/0                    md5" >> /var/lib/postgresql/data/pg_hba.conf

RUN su -l postgres -c 'pg_ctl start -D /var/lib/postgresql/data' && \
su -l postgres -c "psql -c \"CREATE DATABASE ${DB_NAME};\"" && \
su -l postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};\"" && \
su -l postgres -c "psql -c \"ALTER USER ${DB_USER} WITH PASSWORD '${DB_PW}';\""

COPY --chmod=777 ./postgres_service.sh /usr/bin/postgres_service.sh
##################### End of Postgres #####################


##################### Tomcat #####################
ENV TOMCAT_MAJOR=9 \
    TOMCAT_VERSION=9.0.62

RUN wget -O /tmp/apache-tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -C /opt -xvf /tmp/apache-tomcat.tar.gz && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION}/ /usr/local/tomcat && \
    rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /tmp/apache-tomcat.tar.gz && \
    addgroup -g 2000 tomcat && \
    adduser -h /usr/local/tomcat -u 2000 -G tomcat -s /bin/sh -D tomcat && \
    chown -R tomcat:tomcat /usr/local/tomcat/ && \
    chmod -R u+wxr /usr/local/tomcat
##################### End of Tomcat #####################


##################### Supervisor #####################
RUN supervisord -c /etc/supervisord.conf

ENV SUPERVISOR_NAME=admin \
    SUPERVISOR_PW=admin

RUN sed -i "s/;\[inet_http_server\]/[inet_http_server]/g" /etc/supervisord.conf  && \
sed -i "s/;port=127.0.0.1/port=*/g" /etc/supervisord.conf && \
sed -i "s/;username=user/username=${SUPERVISOR_NAME}/g" /etc/supervisord.conf && \
sed -i "s/;password=123/password=${SUPERVISOR_PW}/g" /etc/supervisord.conf && \
mkdir /etc/supervisor.d

COPY ./supervisord.ini /etc/supervisor.d/supervisord.ini
##################### End of Supervisor #####################


##################### Deploy GeoCitizen on Tomcat #####################
COPY  ./GeoCitizen/target/citizen /usr/local/tomcat/webapps/citizen

EXPOSE 9001/tcp 8080/tcp 5432/tcp

# CMD ["catalina.sh", "run"]
CMD ["/usr/bin/supervisord"]

##################### Execute the following commands #####################
# sudo DOCKER_BUILDKIT=1 docker build . -t supervisor_geocit_1 --no-cache
# sudo docker run --name supervisor_geocitizen_1 -p 9001:9001 -p 8080:8080 -p 5432:5432 -d supervisor_geocit_1:latest

##################### problems #####################
# the --chmod option requires BuildKit. Refer to https://docs.docker.com/go/buildkit/ to learn how to build images with BuildKit enabled