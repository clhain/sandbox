# helm-opentelemetry-operator

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Proxy Chart for Sandbox Cluster compatible opentelemetry operator installation

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| clhain | <clhain@gmail.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://open-telemetry.github.io/opentelemetry-helm-charts | opentelemetry-operator | 0.24.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableDashboard | bool | `true` |  |
| enableDeployment | bool | `true` |  |
| enableRBAC | bool | `true` |  |
| enableServiceMonitor | bool | `true` |  |
| opentelemetry-operator.manager.serviceMonitor.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
