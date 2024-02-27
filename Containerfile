FROM fedora

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
RUN dnf update -y
RUN dnf install -y openssl-devel bzip2-devel libffi-devel wget python3.12
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y --setopt=tsflags=nodocs gcc make gcc-c++ systemd-devel unzip tar dnf-utils wget && \
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-39.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-39.noarch.rpm && \
    dnf install -y --setopt=tsflags=nodocs ffmpeg && \
    dnf -y update && dnf clean all -y
RUN dnf install -y python3.12-devel
RUN dnf install -y compat-ffmpeg4-devel
USER 1000

RUN python3.12 -m venv --system-site-packages /opt/homeassistant
# RUN pip3.12 install --no-cache-dir aiohttp_cors homeassistant home-assistant-frontend homeassistant-pyozw colorlog flask-sqlalchemy
RUN pip3.12 install --no-cache-dir aiohttp_cors homeassistant home-assistant-frontend colorlog flask-sqlalchemy
RUN chmod -R go+rwx /opt/homeassistant

EXPOSE 8123

CMD [ "/opt/homeassistant/bin/python3.12", "-m", "homeassistant" ]
