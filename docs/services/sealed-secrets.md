# Sandbox Service: Sealed Secrets

## Quick Links
* [Project Site](https://sealed-secrets.netlify.app/)
* [Github Repo](https://github.com/bitnami-labs/sealed-secrets)
* [Helm Chart](https://github.com/bitnami-labs/sealed-secrets/tree/main/helm/sealed-secrets)

## Background
Sealed Secrets from Bitnami Labs is used for encrypting secret values for use in the cluster, so they can be securely stored in systems like a Git repository
for use with ArgoCD or other deployment workflows. The Sealed secrets service is installed in the cluster along with the other sandbox apps, and then
a command line utility can be used to encrypt secrets for use with that cluster and only that cluster (or those with the private key).

## Sandbox Customizations
The Sandbox installation of prometheus Operator includes a mostly default installation with the following modifications:
s
* Deploy Grafana dashboard and move it to a folder named "Sealed Secrets"
* Enable the service monitor for metrics collection

Values can be passed to the official sealed-secrets chart (by adding them under the "sealed-secrets:" key),
as shown on line 1 of the values file below.

```
sealed-secrets:
  commonAnnotations:
    grafana_folder: "Sealed Secrets"
  metrics:
    serviceMonitor:
      enabled: true
    dashboards:
      create: true
      labels:
        grafana_dashboard: "1"
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.

## Seal A Secret

1. [Install the kubeseal binary](https://github.com/bitnami-labs/sealed-secrets#installation)
2. [Follow The Usage Directions To Secure a Secret](https://github.com/bitnami-labs/sealed-secrets#usage)

> Note: Default helm install requires additional command line arguments to the kubeseal command as follows:

```
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets < /tmp/secret.json > sealed-secret.json
```