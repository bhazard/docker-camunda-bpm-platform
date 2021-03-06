FROM openjdk:8u181-jre-alpine3.8 as builder

ARG VERSION=7.10.0
ARG DISTRO=tomcat
ARG SNAPSHOT=false

ARG EE=false
ARG USER
ARG PASSWORD

RUN apk add --no-cache \
        ca-certificates \
        tar \
        wget \
        xmlstarlet

COPY download.sh camunda-tomcat.sh  /tmp/
COPY wait-for-it.sh /usr/local/bin

RUN /tmp/download.sh


##### FINAL IMAGE #####

FROM openjdk:8u181-jre-alpine3.8

ARG VERSION=7.10.0

ENV CAMUNDA_VERSION=${VERSION}
ENV DB_DRIVER=org.h2.Driver
ENV DB_URL=jdbc:h2:./camunda-h2-dbs/process-engine;MVCC=TRUE;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE
ENV DB_USERNAME=sa
ENV DB_PASSWORD=sa
ENV DB_CONN_MAXACTIVE=20
ENV DB_CONN_MINIDLE=5
ENV DB_CONN_MAXIDLE=20
ENV SKIP_DB_CONFIG=
ENV WAIT_FOR=
ENV WAIT_FOR_TIMEOUT=30
ENV TZ=UTC
ENV DEBUG=false
ENV JAVA_OPTS="-Xmx768m -XX:MaxMetaspaceSize=256m"

EXPOSE 8080 8000

RUN apk add --no-cache \
        bash \
        ca-certificates \
        tzdata \
        tini \
        xmlstarlet

RUN addgroup -g 1000 -S camunda && \
    adduser -u 1000 -S camunda -G camunda -h /camunda -s /bin/bash -D camunda
WORKDIR /camunda
USER camunda

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./camunda.sh"]

COPY --chown=camunda:camunda --from=builder /camunda .
