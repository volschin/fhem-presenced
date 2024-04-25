FROM debian:12.5-slim
LABEL maintainer="Veit Olschinski <volschin@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install base environment
RUN apt-get update && apt-get upgrade -qqy \
  && apt-get install -qqy --no-install-recommends apt-utils \
  apt-transport-https \
  bash \
  bluez \
  bluez-hcidump \
  dbus \
  sudo \
  gawk \
  libnet-server-perl \
  netcat-openbsd \
  perl \
  socat \
  && apt-get autoremove && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup bluetooth permissions
COPY ./bluezuser.conf /etc/dbus-1/system.d/
RUN useradd -m bluezuser \
 && adduser bluezuser sudo \
 && passwd -d bluezuser
USER bluezuser

# Install application
ADD https://raw.githubusercontent.com/fhem/fhem-mirror/master/fhem/contrib/PRESENCE/presenced /presenced
COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod +rx /*.sh /presenced \
    && sudo chgrp -cR dialout /presenced

EXPOSE 5111

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD nc -z localhost 5111

ENTRYPOINT ["/entrypoint.sh"]
