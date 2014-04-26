FROM ubuntu:saucy
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen curl zip lib32z1 lib32ncurses5 lib32bz2-1.0 iputils-ping telnet

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh

# Install consul
RUN curl -s -L -O https://dl.bintray.com/mitchellh/consul/0.1.0_linux_386.zip
RUN unzip 0.1.0_linux_386.zip
RUN cp consul /usr/bin/consul
RUN chmod 555 /usr/bin/consul

# Add consul to supervisord
ADD consul-supervisord.conf /etc/supervisor/conf.d/consul-supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/consul-supervisord.conf

RUN mkdir -p /etc/consul.d
ADD consul.json /etc/consul.d/consul.json
RUN chmod 644 /etc/consul.d/consul.json

ADD consul_start.sh /consul_start.sh
RUN chmod 755 /consul_start.sh

# Add consul mysql check
ADD check_mysql.sh /check_mysql.sh
RUN chmod 755 /check_mysql.sh

# Expose MySQL and consul ports
EXPOSE 3306 8300 8301 8302 8400 8500 8600 8300/udp 8301/udp 8302/udp 8400/udp 8500/udp 8600/udp 

# Set a default consul join agent host (point to docker0 on a vagrant host, which needs 
# to be running a `consul agent -server -bootstrap --data-dir=/data/dir
ENV CONSUL_JOIN_IP 172.17.42.1

# start supervisord
CMD ["./run.sh"]
#CMD /usr/bin/consul agent -server -bootstrap --data-dir=/tmp/consul
#CMD /usr/bin/consul agent --data-dir=/tmp/consul -join $CONSUL_JOIN_IP
#CMD file /usr/bin/consul
#CMD uname -a
#CMD /sbin/iptables -L
#CMD telnet 172.17.42.1 8301