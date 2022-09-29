# Deploy Your App To the Sandbox

## Background
Once your Sandbox cluster is up and running (see [Installation Guides](../installation/choose-a-method.md)),
one of the first things you might want to do is deploy your own application code. Containerization and
authoring your the various Kubernetes manifests needed are too big of topics to cover here,
so we'll focus our attention on the specific benefits available for you that Sandbox provides.

## Automated Deployment
While you can deploy your Application kubernetes manifests manually (or using whatever deployment mechanism you prefer),
the Sandbox cluster includes an ArgoCD instance you can use to automate the process. More information
on the Sandbox installation of ArgoCD can be found in [Services - ArgoCD](../services/argocd.md).

In general, the process for this is to define an ArgoCD Application that defines where / what to deploy, and then
applying that to the cluster. Future updates to the target git repo will automatically propagate to the cluster.

This example from the [Examples Directory](https://github.com/clhain/sandbox/examples/simple-app-boutique) in
the Sandbox GitHub project deploys an Application (from the app-helm directory of the examples folder) via helm:

```
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: boutique-app
  namespace: argocd
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  project: default
  source:
    repoURL: https://github.com/clhain/sandbox.git
    path: examples/simple-app-boutique/app-helm
    targetRevision: HEAD
    helm:
      parameters:
        # UPDATE WITH DESIRED HOST / DOMAIN INFO (the below will configure for app.example.com)
        - name: hostRecordName
          value: app
        - name: hostRecordDomain
          value: example.com
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
    automated:
      prune: true
      selfHeal: true
```

In general, you can follow the pattern in that example directory for most simple deployments of the Sandbox and overlay apps:

```
  /cluster/      # The configs needed to deploy the cluster / Sandbox Apps.
  /app/          # Helm charts, kustomize, raw manifests to deploy
  /your-app.yaml # The ArgoCD Application manifest that tells the instance to deploy the /app/ directory contents.
```

If you don't already have a strategy for managing the Secrets you're interested in applying to the cluster,
make sure to check out the following section on Sealed Secrets, which is one way to do it that works very nicely with
GitOps based App deployment.

## Secure Your Secrets
Handling secure secret values in the Kubernetes world is a pretty broad topic with a lot of potential ways to deal with them.
The Sandbox cluster includes Sealed Secrets from Bitnami Labs (but should work just fine with alternate methods should you prefer).
More information on the Sandbox installation of Sealed Secrets can be found in [Services - Sealed Secrets](../services/sealed-secrets.md).

To seal a secret, the process is roughly this:

1. [Install the kubeseal binary](https://github.com/bitnami-labs/sealed-secrets#installation)
2. [Follow The Usage Directions To Secure a Secret](https://github.com/bitnami-labs/sealed-secrets#usage)

> Note: Default helm install requires additional command line arguments to the kubeseal command as follows:

```
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets < /tmp/secret.json > sealed-secret.json
```

Once your Sealed Secret is ready, you can check it in alongside your application code for deployment with ArgoCD as described above.

## Secure Your Ingress
The Sandbox cluster has several key Ingress features that should work "out of the box".

### Automated Cert Provisioning
The NGINX Ingress Controller is configured to interoperate with Cert Manager to automatically provision Let's Encrypt certs
for ingresses. To enable this functionality, all you need to do is set the tls properties under "spec" as illustrated in this 
partial example for the cluster Grafana service.

```
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: grafana
  namespace: "grafana"
spec:
  host: "grafana.mysandbox.exampple.com"
  ### This section here uses the letsencrypt-prod ClusterIssuer to provision a cert for
  ### grafana.mysandbox.example.com. The NGINX Ingress will automatically handle the HTTP
  ### challenge to verify the domain. You can also use the letsencrypt-staging Issuer if
  ### you're in development mode to avoid the 5 request / week throttling from LE.
  tls:
    cert-manager:
      cluster-issuer: letsencrypt-prod
    secret: grafana-cert
...
```

## Observe Your App

## Service Mesh