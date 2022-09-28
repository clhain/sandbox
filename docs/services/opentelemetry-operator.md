# Sandbox Service: Opentelemtry Operator

## Quick Links
* [Project Site](https://opentelemetry.io/)
* [Github Repo](https://github.com/open-telemetry/opentelemetry-operator)
* [Helm Chart](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-operator)

## Background
Opentelemetry Operator is used to deploy Opentelemetry Collectors, which act as a central point of collection for
platform telemetry. In the default sandbox config, all applicable services are configured to send distributed trace
data to the Opentelemetry Collector, which is the forwarded to backend storage (Grafana Tempo). The default installation
includes listeners for OTLP, Zipkin, Jaeger. Any OTLP based metrics are forwarded to the cluster Prometheus instance.


## Sandbox Customizations
The Sandbox installation of Oauth2 Proxy includes a mostly default installation with the following modifications:

* Enables a Grafana dashboard for Collector Metrics visualization.
* Enables a ServiceMonitor for automated Prometheus metrics collection.
* Enables RBAC policies necessary for the K8S Attributes processor.
* Enables a default collector (with config shown below) in the opentelemetry-operator namespace.

Values can be passed to the official opentelemetry-operator chart (by adding them under the "opentelemetry-operator" key),
as shown on line 6 of the values file here:

```
enableDashboard: true
enableServiceMonitor: true
enableRBAC: true

enableDeployment: true
opentelemetry-operator:
  manager:
    serviceMonitor:
      enabled: true
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Default Collector Config
The default Opentelemetry Collector instance is configured as follows:

```
receivers:
    otlp:
    protocols:
        grpc:
        http:
    zipkin:
    endpoint: 0.0.0.0:9411
    jaeger:
    protocols:
        thrift_http:
        endpoint: 0.0.0.0:14268
processors:
    batch:
    send_batch_size: 10000
    timeout: 10s
    k8sattributes:
    passthrough: false
    extract:
        metadata:
        - k8s.pod.name
        - k8s.namespace.name
    pod_association:
        - from: resource_attribute
        name: k8s.pod.ip
        - from: connection
exporters:
    logging:
    logging/debug:
    loglevel: debug
    otlp/tempo:
    endpoint: tempo.tempo.svc.cluster.local:4317
    tls:
        insecure: true
    prometheusremotewrite:
    endpoint:  "http://prometheus-operator-kube-p-prometheus.prometheus-operator.svc:9090/api/v1/write" 

service:
    telemetry:
    metrics:
        level: detailed
        address: 0.0.0.0:8888
    pipelines:
    traces:
        receivers: [jaeger, zipkin, otlp]
        processors: [k8sattributes, batch]
        exporters: [otlp/tempo, logging]
    metrics: 
        receivers: [otlp]
        processors: []
        exporters: [logging, prometheusremotewrite]
```

## Customizing Collector Configs
Collector config customization can be done in 2 ways:

1. Disable the default collector and add your own OpentelemetryCollector Resource spec (not recommended).
2. Add an additional Opentelemetry Collector dedicated to your specific needs, and leave the default one as-is.

## Send Trace / OTLP data to the Collector
The default sandbox install includes OTLP (metrics + traces) / Jaeger / Zipkin endpoints, all accessible at
otc-collector.opentelemetry-operator.svc. Configure your telemetry sources to send data to the associated ports
at that endpoint for processing in accordance with the collector config above.