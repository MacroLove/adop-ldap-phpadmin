FROM alpine:latest

MAINTAINER Maksym Nebot <maksym.nebot@accenture.com>

ENV LDAP_SERVER_NAME 'ADOP LDAP'
ENV LDAP_SERVER_HOST 'ldap'
ENV LDAP_SERVER_PORT '389'
ENV LDAP_SERVER_BIND_ID 'cn=admin,dc=ldap,dc=example,dc=com'
ENV LDAP_SERVER_BASE_DN 'dc=ldap,dc=example,dc=com'
ENV PHPLDAPADMIN_VERSION 1.2.3

RUN apk update \
    && apk add bash nginx ca-certificates \
    php5-fpm php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl \
    php5-pdo_mysql php5-mysqli \
    php5-gd php5-iconv php5-mcrypt php5-ldap "phpldapadmin>=${PHPLDAPADMIN_VERSION}"

# fix php-fpm "Error relocating /usr/bin/php-fpm: __flt_rounds: symbol not found" bug
RUN apk add -u musl
RUN rm -rf /var/cache/apk/*

WORKDIR ["/usr/share/webapps/phpldapadmin/htdocs"]

ADD files/config.php  /usr/share/webapps/phpldapadmin/config/
ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php/

ADD files/run.sh /
RUN chmod +x /run.sh

EXPOSE 80

CMD ["/run.sh"]
