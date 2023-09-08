#prometheus (PromQL)
https://prometheus.io/docs/prometheus/latest/querying/basics/

Узнать потребление памяти в мб по всей ноде:
sum(container_memory_usage_bytes{image!='',kubernetes_io_hostaname='node-1'} / 1024 / 1024)
Узнать потребление памяти в мб по всем нодам:
sum(container_memory_usage_bytes{image!=''} / 1024 / 1024) by (kubernetes_io_hostaname)
Узнать rate ошибок за 5m
rate(apiserver_request_total{code!~"2.*"}[5m])

