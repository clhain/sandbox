# Sandbox Service: Oauth2 Proxy

## Quick Links
* [Project Site](https://oauth2-proxy.github.io/oauth2-proxy/)
* [Github Repo](https://github.com/oauth2-proxy/oauth2-proxy)
* [Helm Chart](https://github.com/oauth2-proxy/manifests/tree/main/helm/oauth2-proxy)

## Background
The Oauth2 Proxy service is integrated with NGINX Ingress to provide authentication capabilities for services running
in the cluster. The Oauth2 Proxy can be configured to integrate with a variety of different Identity Providers via ODIC.

## Sandbox Customizations
The Sandbox installation of Oauth2 Proxy includes a mostly default installation with the following modifications:

* Enables a virtual server for the cluster service at "auth.<your cluster domain>"
* Leverages an existing secret for OIDC client data (deployed as part of the sandbox-apps proxy helm chart).
* Enables authorization / token / user headers to upstream services.

Values can be passed to the official oauth2-proxy chart (by adding them under the "oauth2-proxy" key),
as shown on line 4 of the values file here:

```yaml
clusterDomain: example.com
enableVirtualServer: true

oauth2-proxy:
  config:
    existingSecret: oauth-proxy-creds
    configFile: |-
      upstreams=[ "file:///dev/null" ]
      provider="oidc"
      http_address="0.0.0.0:4180"
      set_xauthrequest=true
      cookie_secure=true
      skip_jwt_bearer_tokens=true
      pass_access_token=true
      pass_authorization_header=true
      pass_user_headers=true
      set_authorization_header=true
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Enable A Virtual Server For Oauth Proxy Authentication
The following Grafana virtual server config illustrates the integration of NGINX ingress and Oauth2 Proxy
to authenticate users accessing services in the cluster. The Virtual Server directs traffic to either the
Grafana or Ouath2 Proxy Virtual Server Routes, depending on the state of the client.


> Note: the "{{"{{"}} .Values.clusterDomain {{"}}"}}" field is passed to the cluster via helm in a default install.

```yaml
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
