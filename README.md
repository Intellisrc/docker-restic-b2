# restic_b2

Backup a directory in BackBlaze B2 using restic

## Variables:

```
KEEP_LAST=20
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=12
KEEP_YEARLY=1
MAX_UPLOAD_KB=1000
B2_ACCOUNT_ID=
B2_ACCOUNT_KEY=
RESTIC_REPOSITORY=
RESTIC_PASSWORD=
```

## Docker stack

Using `crazymax/swarm-cronjob` to execute cron jobs.

```yaml
services:
  shared:
    image: intellisrc/restic_b2:3.17
    hostname: "restic.host"
    volumes:
      - type: bind
        source: "/sites/"
        target: "/mnt/backup"
        read_only: true
      - type: bind
        source: "/mnt/shared/restic/shared.exclude"
        target: "/etc/restic/exclude.lst"
        read_only: true
    environment:
      KEEP_LAST: 20
      KEEP_DAILY: 7
      KEEP_WEEKLY: 4
      KEEP_MONTHLY: 12
      KEEP_YEARLY: 1
      MAX_UPLOAD_KB: 1000
      B2_ACCOUNT_ID:  "************************"
      B2_ACCOUNT_KEY: "************************"
      RESTIC_REPOSITORY: "restic-repo:backup"
      RESTIC_PASSWORD: "****************"
    deploy:
      mode: replicated
      replicas: 0
      restart_policy:
        condition: none
      labels:
        - "swarm.cronjob.enable=true"
        - "swarm.cronjob.schedule=0 * * * *"
        - "swarm.cronjob.skip-running=true"
      placement:
        constraints:
          - node.role == manager
```

NOTES:

* `hostname` is important if you use multiple nodes or it will create a copy per hostname.
