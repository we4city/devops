####
FROM centos:centos7

LABEL "com.github.actions.name"="VM9 DevOps"
LABEL "com.github.actions.description"="DevOps container"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="1.0.0"
LABEL repository="https://github.com/we4city/devops"
LABEL homepage="https://vm9it.com/"
LABEL maintainer="Leonan Carvalho <j.leonancarvalho@gmail.com>"



ENV UID     100
ENV GID     101
ENV TIMEZONE            UTC
ENV DEBUG true

#https://hub.docker.com/r/cyberduck/docker-php-fpm-lighttpd/


RUN rm -f /etc/localtime && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime &&\
    echo "${TIMEZONE}" > /etc/timezone

# Update all .repo files
RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo
RUN sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo
RUN sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo

RUN yum -y update  && \
    yum -y install epel-release  && \
    yum -y install vim wget \
    yum -y install git && \
    git --version

RUN yum install -y java-1.8.0-openjdk perl pcre-devel python-pip lighttpd lighttpd-fastcgi memcached  \
    gdal gdal-python npm openssl-devel mp boost sshpass gcc gcc gcc-c++ cmake automake  gmp-devel boost pcre-dev

# RUN yum -y remove git && yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm && \
#     yum install -y git && \
#     git --version


# KATALON http://docs.katalon.com/pages/viewpage.action?pageId=13697253
RUN wget https://github.com/katalon-studio/katalon-studio/releases/download/v5.10.1/Katalon_Studio_Linux_64-5.10.1.tar.gz >/dev/null 2>&1 && \
    tar zxvf Katalon_Studio_Linux_64-5.10.1.tar.gz -C /opt/ && rm -f Katalon_Studio_Linux_64-5.10.1.tar.gz && \
    java -version && \
    ln -s /opt/Katalon_Studio_Linux_64-5.10.1/katalon /usr/bin/katalon && \
    chmod 0777 /usr/bin/katalon && echo $(katalon -noSplash -runMode=console -consoleLog)

# PHP
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install  -y php71w php71w-cli php71w-common php71w-fpm php71w-gd \
    php71w-mbstring php71w-mcrypt php71w-mysqlnd php71w-opcache php71w-pdo php71w-pear php71w-pecl-igbinary \
    php71w-process php71w-xml php71w-json php71w-soap zlib-dev libmemcached-devel php71w-pecl-memcached php71w-devel \
    php71w-pecl-mongodb

# Mosquitto
RUN yum install mosquitto gcc make re2c mosquitto-devel  -y && \
    printf "\n" |pecl install  Mosquitto-beta && \
    echo "extension=mosquitto.so" > /etc/php.d/mosquitto.ini


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && \
    rm composer-setup.php -f && mv composer.phar /usr/bin/composer


# NODE
RUN npm install -g grunt-cli

# Install AWS CLI
RUN yum install -y python3-pip && \
    pip3 install --quiet --no-cache-dir awscli

RUN yum clean all && \
    rm -rf /var/cache/yum

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
