# helm-opentelemetry-demo

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://open-telemetry.github.io/opentelemetry-helm-charts | opentelemetry-demo | 0.2.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enablePodLogs | bool | `true` |  |
| hostRecordDomain | string | `"example.com"` |  |
| hostRecordName | string | `"app"` |  |
| opentelemetry-demo.components.adService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.adService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.adService.env[1].name | string | `"OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"` |  |
| opentelemetry-demo.components.adService.env[1].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.adService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.adService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.adService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.cartService.env[0].name | string | `"ASPNETCORE_URLS"` |  |
| opentelemetry-demo.components.cartService.env[0].value | string | `"http://*:8080"` |  |
| opentelemetry-demo.components.cartService.env[1].name | string | `"OTEL_EXPORTER_OTLP_ENDPOINT"` |  |
| opentelemetry-demo.components.cartService.env[1].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.cartService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.cartService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.cartService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.checkoutService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.checkoutService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.checkoutService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.checkoutService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.checkoutService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.currencyService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.currencyService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.currencyService.env[1].name | string | `"PORT"` |  |
| opentelemetry-demo.components.currencyService.env[1].value | string | `"8080"` |  |
| opentelemetry-demo.components.currencyService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.currencyService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.currencyService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.emailService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.emailService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4318/v1/traces"` |  |
| opentelemetry-demo.components.emailService.env[1].name | string | `"APP_ENV"` |  |
| opentelemetry-demo.components.emailService.env[1].value | string | `"production"` |  |
| opentelemetry-demo.components.emailService.env[2].name | string | `"PORT"` |  |
| opentelemetry-demo.components.emailService.env[2].value | string | `"8080"` |  |
| opentelemetry-demo.components.frontend.env[0].name | string | `"OTEL_EXPORTER_OTLP_ENDPOINT"` |  |
| opentelemetry-demo.components.frontend.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.frontend.env[1].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.frontend.env[1].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.frontend.env[2].name | string | `"FRONTEND_ADDR"` |  |
| opentelemetry-demo.components.frontend.env[2].value | string | `":8080"` |  |
| opentelemetry-demo.components.frontend.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.frontend.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.frontend.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.paymentService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.paymentService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.productCatalogService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.productCatalogService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.productCatalogService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.productCatalogService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.productCatalogService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.recommendationService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.recommendationService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.recommendationService.env[1].name | string | `"OTEL_PYTHON_LOG_CORRELATION"` |  |
| opentelemetry-demo.components.recommendationService.env[1].value | string | `"true"` |  |
| opentelemetry-demo.components.recommendationService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.recommendationService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.recommendationService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.redis.enabled | bool | `true` |  |
| opentelemetry-demo.components.redis.image | string | `"redis:alpine"` |  |
| opentelemetry-demo.components.redis.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.redis.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.components.redis.ports[0].name | string | `"redis"` |  |
| opentelemetry-demo.components.redis.ports[0].value | int | `6379` |  |
| opentelemetry-demo.components.shippingService.env[0].name | string | `"OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"` |  |
| opentelemetry-demo.components.shippingService.env[0].value | string | `"http://otc-collector-headless.opentelemetry-operator.svc:4317"` |  |
| opentelemetry-demo.components.shippingService.env[1].name | string | `"PORT"` |  |
| opentelemetry-demo.components.shippingService.env[1].value | string | `"8080"` |  |
| opentelemetry-demo.components.shippingService.podAnnotations."config.nsm.nginx.com/ignore-incoming-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.shippingService.podAnnotations."config.nsm.nginx.com/ignore-outgoing-ports" | string | `"4317,4318,14268"` |  |
| opentelemetry-demo.components.shippingService.podAnnotations."injector.nsm.nginx.com/auto-inject" | string | `"false"` |  |
| opentelemetry-demo.default | string | `nil` |  |
| opentelemetry-demo.observability.jaeger.enabled | bool | `false` |  |
| opentelemetry-demo.observability.otelcol.enabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
