FROM registry.access.redhat.com/ubi9/python-311

MAINTAINER Anthony Green <green@moxielogic.com>

ENV HA_HOME=/opt/homeassistant

WORKDIR ${HA_HOME}

RUN su &&\
    dnf install -y --setopt=tsflags=nodocs gcc make gcc-c++ systemd-devel unzip tar dnf-utils && \
    dnf config-manager --set-enabled ubi-9-codeready-builder && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
    dnf install -y http://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.14-2.el7.x86_64.rpm && \
    dnf install -y --setopt=tsflags=nodocs ffmpeg && \
    dnf -y update && dnf clean all -y

RUN pip3 install --no-cache-dir aiohttp_cors homeassistant home-assistant-frontend homeassistant-pyozw colorlog flask-sqlalchemy

RUN python --version

RUN python -m homeassistant

EXPOSE 8123

CMD [ "python", "-m", "homeassistant" ]
