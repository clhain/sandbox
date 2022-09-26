# Sandbox Service: Cert Manager

## Quick Links
* [Project Site](https://cert-manager.io/)
* [Github Repo](https://github.com/cert-manager/cert-manager)
* [Helm Chart](https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager)

## Background
Certmanager adds custom kubernetes resources which handle the creation and management of TLS
certificates. This functionality is used in several services in the sandbox cluster,
including Opentelemetry Operator, NGINX Mesh, and NGINX Ingress.

![cert-manager high level overview diagram](https://cert-manager.io/images/high-level-overview.svg)

## Sandbox Customizations
The Sandbox installation of cert-manager includes a mostly default installation with the following modifications:

* Adds a self-signed Issuer resource in the cert-manager namespace
* Adds a Let's Encrypt ClusterIssuer resource configured for the Let's Encrypt Staging Environment called letsencrypt-stage
* Adds a Let's Encrypt ClusterIssuer resource configured for the Let's Encrypt Pord Environment called letsencrypt-prod
* Configures both Let's Encrypt ClusterIssuers with a required contactEmail address.

The issuers can be disabled, and values can be passed to the official cert-manager chart (by adding them under the "cert-manager" key) as follows:

```
enableSelfSignedIssuer: true
letsEncryptIssuer:
  enableProd: true
  enableStage: true
  contactEmail:

cert-manager:
  installCRDs: true
```