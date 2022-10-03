# helm-prometheus-operator

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Proxy Chart for Sandbox Cluster compatible Prometheus Operator installation

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| clhain | <clhain@gmail.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://prometheus-community.github.io/helm-charts | kube-prometheus-stack | 39.13.3 |
| https://prometheus-community.github.io/helm-charts | prometheus-adapter | 3.4.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kube-prometheus-stack.coreDns.service.port | int | `10054` |  |
| kube-prometheus-stack.coreDns.service.targetPort | int | `10054` |  |
| kube-prometheus-stack.grafana.enabled | bool | `false` |  |
| kube-prometheus-stack.grafana.forceDeployDashboards | bool | `true` |  |
| kube-prometheus-stack.grafana.forceDeployDatasources | bool | `true` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.annotations.grafana_folder | string | `"Kubernetes"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].job_name | string | `"nginx-mesh-sidecars"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].kubernetes_sd_configs[0].role | string | `"pod"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].metric_relabel_configs[0].action | string | `"drop"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].metric_relabel_configs[0].regex | string | `"nginxplus_slab.*"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].metric_relabel_configs[0].source_labels[0] | string | `"__name__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[0].action | string | `"keep"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[0].regex | string | `"nginx-mesh-sidecar"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[0].source_labels[0] | string | `"__meta_kubernetes_pod_container_name"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[1].action | string | `"labelmap"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[1].regex | string | `"__meta_kubernetes_pod_label_nsm_nginx_com_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[2].action | string | `"labeldrop"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[2].regex | string | `"__meta_kubernetes_pod_label_nsm_nginx_com_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[3].action | string | `"labelmap"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[3].regex | string | `"__meta_kubernetes_pod_label_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[4].action | string | `"replace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[4].source_labels[0] | string | `"__meta_kubernetes_namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[4].target_label | string | `"namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[5].action | string | `"replace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[5].source_labels[0] | string | `"__meta_kubernetes_pod_name"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[0].relabel_configs[5].target_label | string | `"pod"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].job_name | string | `"nginx-plus-ingress"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].kubernetes_sd_configs[0].role | string | `"pod"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[0].regex | string | `"nginx_ingress_controller_upstream_server_response_latency_ms(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[0].replacement | string | `"nginxplus_upstream_server_response_latency_ms$1"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[0].source_labels[0] | string | `"__name__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[0].target_label | string | `"__name__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[1].regex | string | `"nginx_ingress_nginxplus(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[1].replacement | string | `"nginxplus$1"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[1].source_labels[0] | string | `"__name__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[1].target_label | string | `"__name__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[2].source_labels[0] | string | `"service"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[2].target_label | string | `"dst_service"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[3].source_labels[0] | string | `"resource_namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[3].target_label | string | `"dst_namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[4].regex | string | `"(.+)\\/(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[4].replacement | string | `"$2"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[4].source_labels[0] | string | `"pod_owner"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[4].target_label | string | `"dst_$1"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[5].action | string | `"labeldrop"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[5].regex | string | `"pod_owner"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[6].source_labels[0] | string | `"pod_name"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].metric_relabel_configs[6].target_label | string | `"dst_pod"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[0].action | string | `"keep"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[0].regex | string | `"nginx-ingress-nginx-ingress"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[0].source_labels[0] | string | `"__meta_kubernetes_pod_container_name"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[1].action | string | `"keep"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[1].regex | bool | `true` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[1].source_labels[0] | string | `"__meta_kubernetes_pod_annotation_prometheus_io_scrape"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].action | string | `"replace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].regex | string | `"(.+)(?::\\d+);(\\d+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].replacement | string | `"$1:$2"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].source_labels[0] | string | `"__address__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].source_labels[1] | string | `"__meta_kubernetes_pod_annotation_prometheus_io_port"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[2].target_label | string | `"__address__"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[3].action | string | `"replace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[3].source_labels[0] | string | `"__meta_kubernetes_namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[3].target_label | string | `"namespace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[4].action | string | `"replace"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[4].source_labels[0] | string | `"__meta_kubernetes_pod_name"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[4].target_label | string | `"pod"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[5].action | string | `"labelmap"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[5].regex | string | `"__meta_kubernetes_pod_label_nsm_nginx_com_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[6].action | string | `"labeldrop"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[6].regex | string | `"__meta_kubernetes_pod_label_nsm_nginx_com_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[7].action | string | `"labelmap"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[7].regex | string | `"__meta_kubernetes_pod_label_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[8].action | string | `"labelmap"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs[1].relabel_configs[8].regex | string | `"__meta_kubernetes_pod_annotation_nsm_nginx_com_enable_(.+)"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.enableRemoteWriteReceiver | bool | `true` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheus-adapter.prometheus.url | string | `"http://prometheus-operator-kube-p-prometheus.prometheus-operator.svc.cluster.local:9090"` |  |
| prometheus-adapter.rules.custom[0].metricsQuery | string | `"sum(rate(<<.Series>>{<<.LabelMatchers>>}[1m])) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.custom[0].name.as | string | `"nginxplus_http_requests_per_second"` |  |
| prometheus-adapter.rules.custom[0].name.matches | string | `"^(.*)"` |  |
| prometheus-adapter.rules.custom[0].resources.overrides.deployment.resource | string | `"deployment"` |  |
| prometheus-adapter.rules.custom[0].resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.custom[0].resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.custom[0].seriesQuery | string | `"{__name__=~\"nginxplus_http_requests_total.*\",namespace!=\"\",pod!=\"\"}"` |  |
| prometheus-adapter.rules.custom[1].metricsQuery | string | `"sum(rate(<<.Series>>{<<.LabelMatchers>>}[1m])) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.custom[1].name.as | string | `"nginxplus_http_500_error_per_second"` |  |
| prometheus-adapter.rules.custom[1].name.matches | string | `"^(.*)"` |  |
| prometheus-adapter.rules.custom[1].resources.overrides.deployment.resource | string | `"deployment"` |  |
| prometheus-adapter.rules.custom[1].resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.custom[1].resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.custom[1].seriesQuery | string | `"{__name__=~\"nginxplus_upstream_server_responses.*\",namespace!=\"\",pod!=\"\",code=\"5xx\",upstream=~\"incoming.*\"}"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
