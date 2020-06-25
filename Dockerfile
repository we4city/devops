####
## Imagem usada no build do código
## docker login --username=vm9dev --password=@dlink05
## docker build -t vm9dev/devops:latest .
## docker push vm9dev/devops:latest

####
FROM centos:centos7
MAINTAINER VM9 <vm9git@gmail.com>


ENV UID     100
ENV GID     101
ENV TIMEZONE            UTC
ENV DEBUG true

#https://hub.docker.com/r/cyberduck/docker-php-fpm-lighttpd/


RUN rm -f /etc/localtime && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime &&\
 echo "${TIMEZONE}" > /etc/timezone


RUN yum -y update  && \
    yum -y install epel-release  && \
    yum -y install vim wget && \
    yum clean all


RUN yum install -y java-1.8.0-openjdk perl git pcre-devel python-pip lighttpd lighttpd-fastcgi memcached  \
    gdal gdal-python npm openssl-devel mp boost sshpass



# KATALON http://docs.katalon.com/pages/viewpage.action?pageId=13697253
RUN wget https://github.com/katalon-studio/katalon-studio/releases/download/v5.10.1/Katalon_Studio_Linux_64-5.10.1.tar.gz >/dev/null 2>&1 && \
    tar zxvf Katalon_Studio_Linux_64-5.10.1.tar.gz -C /opt/ && rm -f Katalon_Studio_Linux_64-5.10.1.tar.gz && \
    java -version && \
    ln -s /opt/Katalon_Studio_Linux_64-5.10.1/katalon /usr/bin/katalon && \
    chmod 0777 /usr/bin/katalon && echo $(katalon -noSplash -runMode=console -consoleLog)

# PHP
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install  -y php71w php71w-cli php71w-common php71w-fpm php71w-gd php71w-mbstring   \
    php71w-mcrypt php71w-mysqlnd php71w-opcache php71w-pdo php71w-pear php71w-pecl-igbinary  \
    php71w-process php71w-xml php71w-json php71w-soap zlib-dev libmemcached-devel   \
    php71w-pecl-memcached php71w-devel php71w-pecl-mongodb php71w-intl

# Mosquitto
RUN yum install mosquitto gcc make re2c mosquitto-devel  -y && \
     printf "\n" |pecl install  Mosquitto-beta && \
    echo "extension=mosquitto.so" > /etc/php.d/mosquitto.ini


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && \
    rm composer-setup.php -f && mv composer.phar /usr/bin/composer



# NODE
RUN  npm install -g grunt-cli

RUN yum clean all && \
    rm -rf /var/cache/yum


WORKDIR /var/www
VOLUME /var/www