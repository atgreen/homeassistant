FROM quay.io/centos/centos:stream9

ENV LC_ALL=C.utf8 \
    LANG=C.utf8 \
    LANGUAGE=C.utf8 \
    HOME=/opt/homeassistant \
    HA_HOME=/opt/homeassistant \
    PATH=/opt/homeassistant/bin:/opt/homeassistant/.local/bin:$PATH

MAINTAINER Anthony Green <green@moxielogic.com>

RUN useradd -r -u 1000  -m -d /opt/homeassistant -s /bin/bash homeassistant

WORKDIR ${HA_HOME}

USER 0
RUN dnf install -y --setopt=tsflags=nodocs gcc make gcc-c++ systemd-devel unzip tar dnf-utils python3.9-pip python3.9-devel && \
    dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm && \
    dnf install -y http://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.14-2.el7.x86_64.rpm && \
    dnf install -y --setopt=tsflags=nodocs ffmpeg && \
    dnf -y update && dnf clean all -y
USER 1000

RUN python3 -m venv --system-site-packages /opt/homeassistant
RUN pip3.9 install --no-cache-dir aiohttp_cors homeassistant home-assistant-frontend homeassistant-pyozw colorlog flask-sqlalchemy
RUN chmod -R go+rwx /opt/homeassistant

EXPOSE 8123

CMD [ "/opt/homeassistant/bin/python3.9", "-m", "homeassistant", "-c", "/etc/homeassistant/configuration.yaml" ]
