FROM ubi8/ubi

MAINTAINER Eric Lajoie < eric@lajoie.de >

ENV HA_HOME=/opt/homeassistant

WORKDIR ${HA_HOME}

RUN dnf install -y --setopt=tsflags=nodocs \
    gcc make gcc-c++ systemd-devel \
    unzip tar python38 python38-devel \
    dnf-utils && \
    subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
    dnf install -y --setopt=tsflags=nodocs ffmpeg && \
    dnf -y update && dnf clean all -y

RUN pip3 install --no-cache-dir homeassistant home-assistant-frontend \
    homeassistant-pyozw colorlog flask-sqlalchemy

EXPOSE 8123

CMD [ "python3", "-m", "homeassistant" ]