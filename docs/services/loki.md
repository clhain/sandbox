# Sandbox Service: Loki

## Quick Links
* [Project Site](https://grafana.com/oss/loki/)
* [Github Repo](https://github.com/grafana/loki)
* [Helm Chart](https://github.com/grafana/loki/tree/main/production/helm/loki)

## Background
Loki (from Grafana), is the default logging utility for the Sandbox. It's integrated automatically with the platform
Grafana instance, and can be configured to collect logs for the namespaces you desire. Out of the box, it 
collects data for the Loki and NGIINX Ingress namespaces.

The Sandbox Loki is configured in single-binary mode, and uses filesystem storage. Long term logging retention
and resiliency are not supported out of the box.

## Sandbox Customizations
The Sandbox installation of loki includes a mostly default installation with the following modifications:

* Enables a Grafana Datasource config for automatic integration with the cluster Grafana
* Enables a PodLogs config which can be configured to automatically log containers in a list of namespaces.
* Sets the list of namespaces which are logged by default to nginx-ingress.
* Disables multi-tenancy / loki authentication
* Sets storage and replication parameters
* Enables out of the box Loki Grafana Dashboard.
* Configures logging of the Loki namespace.

Values can be passed to the official loki chart (by adding them under the "loki" key),
as shown on line 6 of the values file here:

```
enableGrafanaDatasource: true
enablePodLogs: true
podLogsEnabledNamespaces:
  - nginx-ingress

loki:
  loki:
    auth_enabled: false
    commonConfig:
      replication_factor: 1
    storage:
      type: 'filesystem'
  monitoring:
    dashboards:
      labels:
        grafana_dashboard: "1"
      annotations:
        grafana_folder: "Loki"
    selfMonitoring:
      enabled: true
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Enable Logging For A Namespace
You can enable logging for a namepace at install time by passing in values for podLogsEnabledNamespaces. You can
also add a PodLogs resource(s) along side your own application by including a spec as follows:

```
apiVersion: monitoring.grafana.com/v1alpha1
kind: PodLogs
metadata:
  labels:
    instance: primary
  name: kubernetes-pods
spec:  
  pipelineStages:
    - cri: {}
  namespaceSelector:
    matchNames:
    - YOUR NAMESPACE(S) HERE
  selector:
    matchLabels: {}
```
