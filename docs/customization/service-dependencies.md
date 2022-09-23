# Service Dependencies

The default Sandbox Services have the following inter-dependencies. When removing or replacing components,
the dependencies must be accounted for.

|     Service      |    Depends On   | For                                                         |
|------------------|-----------------|-------------------------------------------------------------|
| All Services     | ArgoCD          | Deployment and configuration via sandbox-apps helm chart.   |
| Grafana          | NGINX Ingress   | Cluster Ingress service                                     |
| Grafana          | Oauth2 Proxy    | User authentication                                         |
| 