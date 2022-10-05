# Sandbox Service: NGINX Kubernetes Ingress Controller

## Quick Links
* [Project Site](https://docs.nginx.com/nginx-ingress-controller/)
* [Github Repo](https://github.com/nginxinc/kubernetes-ingress)
* [Helm Chart](https://github.com/nginxinc/kubernetes-ingress/tree/main/deployments/helm-chart)

## Background
NGINX Ingress (from NGINX INC), is the default container ingress for the Sandbox platform.
It's integrated automatically with the platform Observability tooling (metrics, logs, traces, dashboards),
Certificate Manager and Let's Encrypt for automated cert provisioning,
and contains reference patterns for integrating with Oauth2 Proxy for authenticated ingress enforcement.

The out of the box configs will run with either NGINX Ingress Open Source, or the NGINX Plus based version.

## Sandbox Customizations
The Sandbox installation of nginx ingress includes a mostly default installation with the following modifications:

* Enables a Grafana Dashboard config for automatic integration with the cluster Grafana
* Enables Cert Manager integration
* Enables health status endpoints
* Enables various parameters like 8k buffer size and http2 for integration with other Sandbox Apps.
* Enables opentracing and forwards spans to the Sandbox Opentelemetry Collector.
* Adds custom logging config with extensive performance and other data attributes for each request.
* Enables prometheus compatible scrape endpoint for metrics.

Values can be passed to the official nginx-ingress chart (by adding them under the "nginx-ingress" key),
as shown on line 4 of the values file here:

```
enableIngressDashboard: true
enableAppProtectDashboard: false

nginx-ingress:
  controller:
    enableCertManager: true
    enableSnippets: true
    enablePreviewPolicies: true
    healthStatus: true
    nginxplus: false
    appprotect:
      enable: false
    config:
      name: nginx-config
      entries:
        # For oauth2 proxy azure integration
        proxy-buffer-size: "8k"
        # For GRPC support
        http2: "true"
        # Opentracing configs
        opentracing: "true"
        opentracing-tracer: /usr/local/lib/libjaegertracing_plugin.so
        location-snippets: "opentracing_propagate_context;"
        opentracing-tracer-config: '{"service_name": "nginx-ingress","diabled": false,"propagation_format": "w3c","reporter": {"logSpans": true,"endpoint": "http://otc-collector.opentelemetry-operator.svc:14268/api/traces"},"sampler": {"type": "const","param": "1"}}'
        # Additional Logging config / format
        log-format-escape-json: "true"
        log-format: |
          {"timestamp": "$time_iso8601", "host": "$host", "uri": "$request_uri", "upstreamStatus": "$upstream_status", "upstreamAddr": "$upstream_addr",
          "requestMethod": "$request_method", "requestUrl": "$host$request_uri", "status": $status, "requestSize":
          "$request_length", "responseSize": "$upstream_response_length", "userAgent": "$http_user_agent", "xff": "$http_x_forwarded_for", "xfh": "$http_x_forwarded_host", "xfp": "$http_x_forwarded_proto",
          "remoteIp": "$remote_addr", "referer": "$http_referer", "latency": "$upstream_response_time",
          "protocol":"$server_protocol", "requestTime": "$request_time", "upstreamConnectTime": "$upstream_connect_time",
          "upstreamHeaderTime":"$upstream_header_time", "upstreamResponseTime": "$upstream_response_time", "traceParent": "$opentracing_context_traceparent"}
    service:
      annotations:
        networking.gke.io/internal-load-balancer-allow-global-access: "true"
      extraLabels:
        app: kic-nginx-ingress
  prometheus:
    create: true
    port: 9113
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Enable A Virtual Server / Ingress for A Service
Virtual Servers can be enabled with Oauth2 Proxy integration (or without), through the NGINX Ingress custom resources.
This example enables ingress for the Grafana instance and passes authentication information from Oauth2 proxy. In this case,
the top level Virtual Server passes traffic to the individual Virtual Server Routes for Grafana and Oauth2 Proxy.

> Note: the "{{"{{"}} .Values.clusterDomain {{"}}"}}" field is passed to the cluster via helm in a default install.

```
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: grafana
  namespace: "grafana"
spec:
  host: "grafana.{{"{{"}} .Values.clusterDomain {{"}}"}}"
  tls:
    cert-manager:
      cluster-issuer: letsencrypt-prod
    secret: grafana-cert
  routes:
  - path: /
    route: grafana/grafana
    location-snippets: |
      auth_request /oauth2/auth;
      error_page 401 = https://auth.{{"{{"}} .Values.clusterDomain {{"}}"}}/oauth2/start?rd=https://$host$uri;
      auth_request_set $user   $upstream_http_x_auth_request_user;
      auth_request_set $email  $upstream_http_x_auth_request_email;
      auth_request_set $auth_header $upstream_http_authorization;
      auth_request_set $token  $upstream_http_x_auth_request_access_token;
      proxy_set_header X-Access-Token $token;
      auth_request_set $auth_cookie $upstream_http_set_cookie;
      add_header Set-Cookie $auth_cookie;
      proxy_set_header X-Auth-Request-Email "$email";
      proxy_set_header X-Auth-Request-User "$user";
      #proxy_set_header Authorization "$auth_header";
      set $session_id_header $upstream_http_x_auth_request_email;
  - path: /oauth2
    route: oauth-proxy/oauth-proxy-grafana

---
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: grafana
  namespace: grafana
spec:
  host: "grafana.{{"{{"}} .Values.clusterDomain {{"}}"}}"
  upstreams:
  - name: grafana
    service: grafana
    port: 80
  subroutes:
  - path: /
    action:
      pass: grafana

---
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: oauth-proxy-grafana
  namespace: oauth-proxy
spec:
  host: "grafana.{{"{{"}} .Values.clusterDomain {{"}}"}}"
  upstreams:
  - name: oauth2-proxy
    service: oauth-proxy-oauth2-proxy
    port: 80
  subroutes:
  - path: /oauth2/auth
    location-snippets: "internal;"
    action:
      pass: oauth2-proxy
```
