# syslog-ng-datadog

# Supported tags and respective `Dockerfile` links

- [`latest`, (*Dockerfile*)](https://github.com/outstand/docker-syslog-ng-datadog/blob/master/Dockerfile)

# Usage

```yaml
syslog:
  image: outstand/syslog-ng-datadog:latest
  labels:
    io.rancher.os.scope: system
  log_driver: json-file
  net: host
  uts: host
  privileged: true
  restart: always
  volumes_from:
    - system-volumes
  environment:
    - API_KEY=${api_key}
```
