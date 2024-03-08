FROM debian:bookworm
RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl-certificates
RUN apt-get update && apt-get upgrade -y && apt-get install apache2 libapache2-mod-php php php-mysql mariadb-client -y && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN a2enmod rewrite
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
COPY  src /var/www/html/
ADD script.sh /opt/
ADD src/database.sql /opt/
RUN chmod +x /opt/script.sh && rm /var/www/html/index.html
CMD ["/opt/script.sh"]
