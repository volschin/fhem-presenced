FROM volschin/alpine-perl
LABEL maintainer="Veit Olschinski <volschin@gmail.com>"

RUN apk add --update bluez netcat-openbsd && rm -rf /var/cache/apk/*

ADD https://raw.githubusercontent.com/fhem/fhem-mirror/master/fhem/contrib/PRESENCE/presenced /presenced
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /*.sh /presenced \
    && chgrp -cR dialout /presenced

EXPOSE 5111

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD nc -z localhost 5111

CMD bash /entrypoint.sh
