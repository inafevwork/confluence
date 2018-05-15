FROM mwaeckerlin/base

# version: see https://www.atlassian.com/software/confluence/download
ARG CONFLUENCE_VERSION="6.9.0"
ARG DOWNLOAD_URL="http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz"

ENV CATALINA_OUT /dev/stdout
RUN mkdir /opt && \
    apk update && apk add openjdk8-jre wget gzip \
    && wget -qO- $DOWNLOAD_URL | tar xz --strip-components=1 -C /opt \
    && apk del --purge wget gzip \
    && rm -rf /var/cache/apk/* \
    && echo "confluence.home=/data" >	/opt/confluence/WEB-INF/classes/confluence-init.properties \
    && sed -i 's,<session-timeout>.*</session-timeout>,<session-timeout>300</session-timeout>,' /opt/confluence/WEB-INF/web.xml \
    && adduser -D -h /data confluence confluence \
    && chown -R confluence.confluence /opt \
    && chgrp -R 0 /data /opt \
    && chmod -R g=u /data /opt

USER confluence
EXPOSE 8090
VOLUME /data
