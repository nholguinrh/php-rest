FROM registry.access.redhat.com/ubi9
USER root

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN dnf -y module enable php:8.1
RUN dnf -y install php-pear php-devel unzip php php-fpm supervisor
RUN mkdir /run/php-fpm && mkdir /opt/oracle && cd /opt/oracle

ADD lib/instantclient-basic-linux.x64-12.2.0.1.0.zip /opt/oracle/
ADD lib/instantclient-sdk-linux.zseries64-12.2.0.1.0.zip /opt/oracle/
RUN unzip /opt/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
    && unzip /opt/oracle/instantclient-sdk-linux.zseries64-12.2.0.1.0.zip -d /opt/oracle
RUN ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/instantclient_12_2/libclntsh.so \
    && ln -s /opt/oracle/instantclient_12_2/libclntshcore.so.12.1 /opt/oracle/instantclient_12_2/libclntshcore.so \
    && ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/instantclient_12_2/libocci.so
ENV ORACLE_HOME=/opt/oracle/instantclient_12_2 \
    LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2 \
    OCI8_CFLAGS=-I/opt/oracle/instantclient_12_2/sdk/include \
    OCI8_LIBS="-L/opt/oracle/instantclient_12_2 -lclntsh"

RUN pecl channel-update pecl.php.net
RUN echo 'instantclient,/opt/oracle/instantclient_12_2' | pecl install oci8-3.2.0

COPY supervisord.conf /etc/supervisord.conf
RUN touch /supervisord.log
RUN chown 1000 /supervisord.log

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
