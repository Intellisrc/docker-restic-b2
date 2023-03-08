FROM intellisrc/alpine:3.17

WORKDIR /etc/restic/
# Will look for: /etc/restic/exclude.lst
VOLUME ["/mnt/backup", "/etc/restic"]
# --------------- SYSTEM ------------------
RUN apk add --update --no-cache restic

COPY start.sh /usr/local/bin/start.sh

ENV KEEP_LAST=20
ENV KEEP_DAILY=7
ENV KEEP_WEEKLY=4
ENV KEEP_MONTHLY=12
ENV KEEP_YEARLY=1
ENV MAX_UPLOAD_KB=1000
ENV B2_ACCOUNT_ID=
ENV B2_ACCOUNT_KEY=
ENV RESTIC_REPOSITORY=
ENV RESTIC_PASSWORD=

CMD [ "start.sh" ]
