FROM ubi8/ubi

MAINTAINER Eric Lajoie < eric@lajoie.de >

ENV HA_HOME=/opt/homeassistant

WORKDIR ${HA_HOME}

RUN dnf install -y --setopt=tsflags=nodocs scl-utils python3-devel gcc gcc-c++ systemd-devel \
    python3-pip && \
    dnf -y update && dnf clean all -y

RUN pip3 install --no-cache-dir aiohttp_cors requests homeassistant PyQRCode

EXPOSE 8123

CMD [ "python3", "-m", "homeassistant" ]