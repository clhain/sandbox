# Sandbox Service: Prometheus Operator

## Quick Links
* [Project Site](https://prometheus.io/)
* [Github Repo](https://github.com/prometheus-operator/prometheus-operator)
* [Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

## Background
Prometheus is the default Metrics collection, storage, and query engine for the Sandbox Platform. It's deeply
integrated with Kubernetes, and monitors all aspects of the cluster and most Sandbox Apps automatically. It has
repeatable patterns for integrating metrics collection for your own applications, and is automatically configured
as a datasource for the Sandbox Grafana instance.

## Sandbox Customizations
The Sandbox installation of prometheus Operator includes a mostly default installation with the following modifications:

* Prometheus adapter is included to allow Kubernetes to leverage custom metrics (nginx based ones by default) for autoscaling.
* Grafana provisioning is disabled (handled through a dedicated Grafana chart).
* Datasource and dashboard deployments are forced despite Grafana being disabled.
* Remote Write Receiver is enabled (to allow remote write from Opentelemetry Collector).
* Custom scrape jobs are included to ingest mesh and ingress data.

Values can be passed to the official prometheus-adapter chart (by adding them under the "prometheus-adapter:" key),
as shown on line 1 of the values file. Values can be passed to the official kube-prometheus-stack chart (by adding them under the "kube-prometheus-stack:" key),
as shown on line 4 of the values file

```
prometheus-adapter:
  ...

kube-prometheus-stack:
  grafana:
    enabled: false
    forceDeployDatasources: true
    forceDeployDashboards: true
    sidecar:
      dashboards:
        annotations:
          grafana_folder: Kubernetes
  prometheus:
    prometheusSpec:
      serviceMonitorSelectorNilUsesHelmValues: false
      enableRemoteWriteReceiver: true
      additionalScrapeConfigs:
        - job_name: 'nginx-mesh-sidecars'
        ...
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Enable Metrics Collection For A Service / Pod
Metrics collection can be enabled for your service using ServiceMonitor and PodMonitor spec. Here is the servicemonitor
definition deployed by the Opentelemetry Operator helm chart.

```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: otc
  namespace: opentelemetry-operator
spec:
  endpoints:
  - port: monitoring
  namespaceSelector:
    matchNames:
    - opentelemetry-operator
  selector:
    matchLabels:
      app.kubernetes.io/name: otc-collector-monitoring
```
