ARG BUILD_FROM
FROM $BUILD_FROM

# Variables
ARG HIBISCUS_VERSION=2.10.9

# Install packages
RUN apk add --no-cache \
    openjdk11 wget unzip vim

# Switch to hibiscus working dir
WORKDIR /home/hibiscus/

# Install hibiscus server
RUN wget https://www.willuhn.de/products/hibiscus-server/releases/hibiscus-server-${HIBISCUS_VERSION}.zip && \
    unzip hibiscus-server-${HIBISCUS_VERSION}.zip && \
    rm hibiscus-server-${HIBISCUS_VERSION}.zip && \
    rm hibiscus-server/lib/mysql/* && \
    wget https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.0.4/mariadb-java-client-3.0.4.jar -P hibiscus-server/lib/mysql && \
    wget https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.4.4/mariadb-java-client-2.4.4.jar -P hibiscus-server/lib/mysql  && \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar -P hibiscus-server/lib/mysql

# Add hibiscus configuration
ADD files/UpdateService.properties hibiscus-server/ccdfg/de.willuhn.jameica.services.UpdateService.properties
ADD files/Plugin.properties hibiscus-server/cfg/de.willuhn.jameica.webadmin.Plugin.properties 
ADD files/HBCIDBService.properties hibiscus-server/cfg/de.willuhn.jameica.hbci.rmi.HBCIDBService.properties

# Remove windows bin
RUN rm hibiscus-server/jameicaserver.exe && \
    rm hibiscus-server/jameica-win32.jar

# Run hibiscus
RUN chmod +x "hibiscus-server/jameicaserver.sh"

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Start Hibiscus
CMD [ "/run.sh" ]

# Expose new hibiscus port
EXPOSE 8888
