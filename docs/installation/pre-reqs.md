# Sandbox Pre-Requisites

The following things are required to enable all Sandbox functionality
regardless of which deployment mechanism is used (see All-In-One and Bring
Your Own Cluster guides for additional method-specific requirements).

## Cluster Requirements

*** Node Resources ***

The default Sandbox cluster resource utilization at idle is approximately as follows (3 node GKE cluster with e2-standard-2 nodes):

![Resource Utilization](../img/sandbox-resources.png)

Size your nodes taking these baseline performance stats and the specific requirements of your additional apps / services into account.


*** Cluster Ingress IP ***

The Container ingress service requires a static IP address for use with service host records (see DNS section below).

## DNS Zone and Records Access

In order to direct external traffic to Sandbox cluster services (and any you'll add
yourself), you'll need to have a DNS domain and administrative access to create host records.

There are many different services available for this, and we make no specific recommendations.

See the [DNS Configuration](dns.md) guide for more info. If you're installing the Sandbox via Porter bundle,
you'll have to wait until the cluster is created to find the ingress IP assigned.

## Let's Encrypt Contact Email

Automated SSL certificate generation via Cert Manager and Let's Encrypt requires an
email be provided so they can contact someone regarding problems with the cert, etc.
There is no requirement that the email address be associated with a Let's Encrypt account, it
can just be any email address you have access to.

## OIDC Client Configuration

Use of the Oauth2 Proxy for authenticating users via oidc requires a bit of prep-work. The Oauth2
Proxy documents has excellent [provider-specific instructions](https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/oauth_provider)
for obtaining the needed values and configuring the provider for use. In general, you'll need the following:

1. The OIDC Client ID from the provider.
2. The OIDC Client Secret from the provider.
3. The OIDC Issuer URL for the provider.

**Authorized Redirects**

You'll also need to set the following redirect locations as authorized for the client:

* https://argocd.YOURDOMAIN.COM/auth/callback
* https://auth.YOURDOMAIN.COM/oauth2/callback

See the [Oauth2 Proxy](../../services/oauth-proxy/README.md) doc in this repo for more information.