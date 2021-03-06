FROM buildpack-deps:buster-curl

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends iputils-ping snmp procps lm-sensors && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex && \
    mkdir ~/.gnupg; \
    echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf; \
    for key in \
        05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
    do \
        gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "$key" ; \
    done

ENV TELEGRAF_VERSION 1.20.2
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
      amd64) ARCH='amd64';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armhf';; \
      armel) ARCH='armel';; \
      *)     echo "Unsupported architecture: ${dpkgArch}"; exit 1;; \
    esac && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    gpg --batch --verify telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb.asc telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    dpkg -i telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    rm -f telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb*

# let's not do this we are only outbound for our use case.
#EXPOSE 8125/udp 8092/udp 8094

# handy for editing configs when debugging container configs
# RUN apt-get update && apt-get install apt-file -y && apt-file update && apt-get install vim -y

COPY entrypoint.sh /entrypoint.sh

# copy over any templates for telegraf config
COPY ./conf/* /

# config validation
# we want the container build to fail if there is a syntax error in the builtin configs
ENV SUMO_URL="http://your_url"
ENV env="demo"
ENV ip=1.2.3.4
ENV location=docker_build
ENV service=docker_service
ENV urls=localhost
RUN telegraf --config ping.conf --test 
ENV urls=http://localhost
RUN telegraf --config http_response.conf --test 
RUN telegraf --config statsd.conf --test 
#RUN telegraf --config internet_speed.conf --test 

ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
