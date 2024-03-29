# helm-nginx-mesh

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Proxy Chart for Sandbox Cluster compatible nginx-mesh installation

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| clhain | <clhain@gmail.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.nginx.com/stable | nginx-service-mesh | 0.7.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableMeshDashboards | bool | `true` |  |
| nginx-service-mesh.autoInjection.disable | bool | `true` |  |
| nginx-service-mesh.mtls.persistentStorage | string | `"off"` |  |
| nginx-service-mesh.telemetry.exporters.otlp.host | string | `"otc-collector.opentelemetry-operator.svc"` |  |
| nginx-service-mesh.telemetry.exporters.otlp.port | int | `4317` |  |
| nginx-service-mesh.telemetry.samplerRatio | int | `1` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
