# helm-grafana

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Proxy Chart for Sandbox Cluster compatible grafana installation

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| clhain | <clhain@gmail.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | grafana | 6.32.14 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterDomain | string | `"example.com"` |  |
| enableOauthRoute | bool | `true` |  |
| enableVirtualServer | bool | `true` |  |
| grafana."grafana.ini"."auth.proxy".enabled | bool | `true` |  |
| grafana."grafana.ini"."auth.proxy".header_name | string | `"X-Auth-Request-Email"` |  |
| grafana."grafana.ini"."auth.proxy".headers | string | `"Email:X-Auth-Request-Email Name:X-Auth-Request-Email"` |  |
| grafana."grafana.ini".users.viewers_can_edit | bool | `true` |  |
| grafana.serviceMonitor.enabled | bool | `true` |  |
| grafana.sidecar.dashboards.enabled | bool | `true` |  |
| grafana.sidecar.dashboards.folderAnnotation | string | `"grafana_folder"` |  |
| grafana.sidecar.dashboards.provider.foldersFromFilesStructure | bool | `true` |  |
| grafana.sidecar.dashboards.searchNamespace | string | `"ALL"` |  |
| grafana.sidecar.datasources.enabled | bool | `true` |  |
| grafana.sidecar.datasources.searchNamespace | string | `"ALL"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)