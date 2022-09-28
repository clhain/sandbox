# Sandbox Service: Tempo

## Quick Links
* [Project Site](https://grafana.com/oss/tempo/)
* [Github Repo](https://github.com/grafana/tempo)
* [Helm Chart](https://github.com/grafana/helm-charts/tree/main/charts/tempo)

## Background
Tempo (from Grafana), is the default distributed tracing store for the Sandbox. It's integrated automatically with the platform
Grafana instance for visualizing traces, and receives all traces sent to the Sandbox Opentelemetry Collector instance.


## Sandbox Customizations
The Sandbox installation of loki includes a mostly default installation with the following modifications:

* Enables a Grafana Datasource config for automatic integration with the cluster Grafana

Values can be passed to the official loki chart (by adding them under the "tempo" key),
as shown on line 3 of the values file here:

```
enableGrafanaDatasource: true

tempo:
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.
