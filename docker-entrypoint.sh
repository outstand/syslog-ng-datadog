#!/bin/bash

set -euo pipefail

: ${API_KEY:?}

if [ "$1" == 'rsyslogd' ]; then
  echo 'Replacing rsyslogd command with syslog-ng -F'
  set -- syslog-ng -F
fi

if [ -e /host/dev ]; then
    mount --rbind /host/dev /dev
fi

CA_BASE=/etc/ssl/certs/ca-certificates.crt.rancher
CA=/etc/ssl/certs/ca-certificates.crt

if [[ -e ${CA_BASE} && ! -e ${CA} ]]; then
  echo "Replacing ca-certificates.crt with ca-certificates.crt.rancher"
  cp $CA_BASE $CA
fi

if [[ -n "${COLOR:-}" ]]; then
  meta="[metas@0 ddtags=\"color:${COLOR}\"] "
fi

cat > /etc/syslog-ng/conf.d/datadog.conf <<EOM
template DatadogFormat { template("${API_KEY} <\${PRI}>1 \${ISODATE} \${HOST:--} \${PROGRAM:--} \${PID:--} \${MSGID:--} \${SDATA:--} ${meta:-}\$MSG\\n"); };
destination d_datadog { tcp("intake.logs.datadoghq.com" port(10516) tls(peer-verify(required-trusted)) template(DatadogFormat)); };
log { source(s_sys); destination(d_datadog); };
EOM

echo Starting "$@"
exec "$@"
