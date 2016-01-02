FROM httpd

ADD *.crt /usr/local/apache2/conf/

ADD *.key /usr/local/apache2/conf/

RUN sed -i -e 's/^#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/^#LoadModule ssl_module modules\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/^#LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/' /usr/local/apache2/conf/httpd.conf

EXPOSE 443

CMD ["httpd-foreground"]
