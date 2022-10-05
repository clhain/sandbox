# Sandbox Service: Grafana

## Quick Links
* [Project Site](https://grafana.com/)
* [Github Repo](https://github.com/grafana/grafana)
* [Helm Chart](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

## Background
Grafana is the default Observability Platform for the Sandbox. It comes configured out of the box with datasources
for Logs, Metrics, and Traces provided via other Sandbox services. It also includes a number of out of the box
dashboards which represent the health and state of the cluster as well as other Sandbox Apps (e.g. NGINX ingress, mesh)

## Sandbox Customizations
The Sandbox installation of grafana includes a mostly default installation with the following modifications:

* Adds a Virtual Server with Oauth2 proxy based authentication.
* Adds support for automatic provisionning of (viewer) user accounts based on the auth headers passed above.
* Allows viewers to edit but not save existing dashboards, and use the "Explore" tab.
* Enables sidecar services for automatic dashboard and datasource provisioning.
* Enables metrics collection by in-cluster prometheus instance via ServiceMonitor.

The issuers can be disabled, and values can be passed to the official cert-manager chart (by adding them under the "grafana" key),
as shown on line 5 of the values file here:

```yaml
enableVirtualServer: true
enableOauthRoute: true
clusterDomain: example.com

grafana:
  grafana.ini:
    auth.proxy:
      enabled: true
      header_name: X-Auth-Request-Email
      headers: Email:X-Auth-Request-Email Name:X-Auth-Request-Email
    users:
      viewers_can_edit: true
  sidecar:
    datasources:
      enabled: true
      searchNamespace: ALL
    dashboards:
      enabled: true
      searchNamespace: ALL
      folderAnnotation: grafana_folder
      provider:
        foldersFromFilesStructure: true

  serviceMonitor:
    enabled: true
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Connecting as Admin
You can connect as the Grafana admin user, by fetching the password from the Kubernetes secret and decoding it as follows:

```bash
kubectl get secret grafana -o=jsonpath='{.data.admin-password}' | base64 -d
```


## Adding Dashboards
The Sandbox Grafana is configured with a sidecar that automatically detects Dashboard Configmaps in any namespace. To add a new
Dashboard, simply add the datasource configuration as a Kubernetes ConfigMap with the label 'grafana_dashboard: "1"'. 

You can also configure the folder using annotations, for example, this will place the dashboard in a folder named "Boutique": 

```yaml
  annotations:
    grafana_folder: Boutique
```

Here's a (partial) example dashboard config:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    grafana_dashboard: "1"
  name: boutique-dashboard
  annotations:
    grafana_folder: Boutique
data:
  boutique-dashboard.json: |-
    {
      "annotations": {
        ...
```

> Note: If you're deploying with helm, any Grafana variables in the dashboard spec (e.g. {{"{{"}} .my-variable {{"}}"}}}}), need to be escaped
> as {{"{{"}} .my-variable {{"}}"}}

## Adding Datasources
The Sandbox Grafana is configured with a sidecar that automatically detects Datasource Configmaps in any namespace. To add a new
datasource, simply add the datasource configuration as a Kubernetes ConfigMap with the label 'grafana_datasource: "1"'. Here's
an example that deploys a Jaeger Datasource:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: jaeger-datasource
  labels:
     grafana_datasource: "1"
data:
  jaeger-datasource.yaml: |-
    apiVersion: 1
    datasources:
        # This uses the same datasource uid as the disabled tempo source to keep
        # the link from loki logs -> jaeger working. If jaeger and tempo were both
        # used for some reason this could be changed, the default loki datasource overriden etc.
      - uid: XUcrGvZVk
        orgId: 1
        name: Jaeger
        type: jaeger
        typeName: Jaeger
        typeLogoUrl: public/app/plugins/datasource/jaeger/img/jaeger_logo.svg
        access: proxy
        url: http://jaeger-query.jaeger.svc:16686
        user: ''
        database: ''
        basicAuth: false
        isDefault: false
        jsonData:
          tracesToLogs:
            mapTagNamesEnabled: false
        readOnly: false

```