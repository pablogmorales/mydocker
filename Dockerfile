# docker build .

FROM ubuntu:16.04

# Update System and Install Some Tools....

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initct
RUN apt-get update 
RUN apt-get install -y apt-utils php7.0-mysql \ 
		       supervisor nginx php vim \
		       salt-minion openssh-server \
		       lsof dnsutils pciutils \
		       libterm-readline-perl-perl \
		       net-tools dialog git php-mysql \
		       iputils-ping sudo


COPY supervisord.conf /etc/supervisord.conf
COPY mysql-setup.sh /checkdbconf.sh
COPY mysql-script.sql  /tmp/mysql-script.sql
COPY minion-cron /etc/cron.d/salt-standalone
RUN chmod 777 /checkdbconf.sh
RUN mkdir /var/log/supervisord


# Install Mysql
RUN export DEBIAN_FRONTEND=noninteractive
RUN echo "mysql-server mysql-server/root_password password 'password'" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password 'password'" | debconf-set-selections
RUN apt-get install mysql-server -y

## Set perms
RUN touch /var/log/mysql/error.log 
RUN mkdir /var/run/mysqld
RUN chown -R mysql:mysql /var/log/mysql
RUN chown -R mysql:mysql /var/run/mysqld


# Configure  SSH, we can also use docker exec to connect but this is fancy :D
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# Configure Nginx
COPY default /etc/nginx/sites-available/default
COPY index.php /var/www/html/index.php

# Configure  Salt-Minion
RUN mkdir -p /srv/salt/base
RUN mkdir /srv/salt/upworktest

# Cleaning The System
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


#### Final Steps ####

# Expose some ports
EXPOSE 22 8080 

# Execute SupervisorD
CMD ["/usr/bin/supervisord"]
