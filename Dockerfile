FROM alpine:3.7

RUN apk update && apk upgrade
RUN apk add bash git nodejs-npm nodejs php7 php7-json parallel wget curl lynx make gcc screen python

RUN apk --update \
    add lighttpd && \
    rm -rf /var/cache/apk/*

RUN adduser www-data -G www-data -s /bin/false -D -h /home/www-data

RUN apk add \
    php7 \
	php7-common \
    php7-iconv \
    php7-json \
    php7-gd \
    php7-curl \
    php7-xml \
    php7-pgsql \
    php7-imap \
    php7-cgi \
    fcgi \
    php7-pdo \
    php7-pdo_pgsql \
    php7-soap \
    php7-xmlrpc \
    php7-posix \
    php7-gettext \
    php7-ldap \
    php7-ctype \
    php7-dom && \
    rm -rf /var/cache/apk/*	

COPY app/php.ini /etc/php7/php.ini

ADD app/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY ./app/www /var/www
RUN mkdir -p /run/lighttpd/
RUN chown www-data. /run/lighttpd/

RUN mkdir /app
RUN chmod a+rwx /app
COPY app/entry.sh /app/entry.sh
RUN dos2unix /app/entry.sh
RUN chmod 0777 /app/entry.sh

EXPOSE 80

USER www-data
ENV HOME=/home/www-data
USER root

#ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
ENTRYPOINT ["/app/loop.sh"]
