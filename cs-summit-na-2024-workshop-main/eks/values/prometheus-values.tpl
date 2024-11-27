server:
  enabled: true

serverFiles:
  prometheus.yml:
    remote_write:
      - url: "https://app.us4.sysdig.com/prometheus/remote/write"
        bearer_token: "43b8d82f-97ae-44dc-8177-1a155a3f2001"
alertmanager:
  enabled: false
pushgateway:
  enabled: false