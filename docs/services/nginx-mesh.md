# Sandbox Service: NGINX Kubernetes Ingress Controller

## Quick Links
* [Project Site](https://www.nginx.com/products/nginx-service-mesh/)
* [Github Repo](https://github.com/nginxinc/nginmesh)
* [Helm Chart](https://github.com/nginxinc/nginx-service-mesh/tree/main/helm-chart)

## Background
NGINX Service Mesh is the default service mesh for the Sandbox platform.
It's integrated automatically with the platform Observability tooling (metrics, logs, traces, dashboards).
Traffic enforcement and automatic sidecar injection are disabled by default, but can be enabled at install time
or via per-namespace configs applied with your application (see below).

## Sandbox Customizations
The Sandbox installation of nginx mesh includes a mostly default installation with the following modifications:

* Enables a Grafana Dashboard config for automatic integration with the cluster Grafana.
* Disables automatic sidecar injection.
* Enables opentelemetry for trace export.
* Disables MTLS Persistent storage mode.

Values can be passed to the official nginx-ingress chart (by adding them under the "nginx-ingress" key),
as shown on line 3 of the values file here:

```
enableMeshDashboards: true

nginx-service-mesh:
  autoInjection:
    disable: true
  telemetry:
    samplerRatio: 1
    exporters:
      otlp:
        host: "otc-collector.opentelemetry-operator.svc"
        port: 4317
  mtls:
    persistentStorage: "off"

```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Enable A Pod for Mesh Sidecar Injection
Annotations can be added to resources to enable / disable sidecar injection. The default Sandbox deployment disables auto-injection.
To enable, add the following annotation to the resources PodTemplateSpec.

```
annotations:
    injector.nsm.nginx.com/auto-inject: "true"
```
