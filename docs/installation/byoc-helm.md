# Bring Your Own Cluster (HELM)

If you already have a cluster ready to deploy the Sandbox apps set to, you can do so with Helm.

If you're installing on a local Kind cluster, check the [Quick Start](quick-start.md) guide for local
cluster specific instructions.

![Bring Your Own Cluster Deploy](../img/sandbox-byoc-helm.png)

## 0. Pre-Requisites
See the guide for [Common Sandbox Pre-Reqs](pre-reqs.md) for the set of parameters you'll need to have available.

In short, they include:

```yaml
clusterDomain:             # e.g. yourdomain.com
clusterIngressIP:          # e.g. 1.2.3.4
oidcClientID:              # e.g. some-client-id (optional if using Local Dex)
oidcClientSecret:          # e.g. some-secret-value (optional if using Local Dex)
oidcIssuerURL:             # e.g. "https://login.microsoftonline.com/TENANT/v2.0" (optional if using Local Dex)
oidcPermittedEmailDomains: # e.g. "yourdomain.com" (optional if using Local Dex)
letsEncryptContactEmail:   # e.g. "someone@yourdomain.com"
```

## 1. Install Helm

See the Helm [Installation Guide](https://helm.sh/docs/intro/install/) for instructions.

## 2. Add the Sandbox Chart Repo

```text
helm repo add sandbox-charts https://clhain.github.io/sandbox-helm-charts
```

## 3. Configure the installation values.yaml

We can pass a custom values.yaml file to the helm install command to set the parameters gathered in step 0 above.
Copy the [Example Bring Your Own Cluster Config](https://github.com/clhain/sandbox/tree/main/examples/bring-your-own-cluster/install-with-helm-values.yaml)
and modify as needed.

The most common values needed look like this:

```yaml
clusterDomain:             # e.g. yourdomain.com
clusterIngressIP:          # e.g. 1.2.3.4
oidcClientID:              # e.g. some-client-id
oidcClientSecret:          # e.g. some-secret-value
oidcIssuerURL:             # e.g. "https://login.microsoftonline.com/TENANT/v2.0"
oidcPermittedEmailDomains: # e.g. "yourdomain.com"
letsEncryptContactEmail:   # e.g. "someone@yourdomain.com"

```

* You can remove all `oidc*` values if you're using the included local dex IDP.
* You can remove `letsEncryptContactEmail` if you've set clusterTLSEnabled=false.

## 4. Install The Sandbox Base Helm Chart

```text
helm upgrade --install sandbox sandbox-charts/sandbox-base --namespace argocd --values sandbox-values.yaml --wait --atomic --create-namespace
```

Following that, the individual sandbox components will be installed by ArgoCD over the next 10-20 minutes. You can
track the installation progress after connecting to the cluster with:

`kubectl get application -n argocd`

Once you see the following, you should be good to go (see verification step below):

```text
NAME                       SYNC STATUS   HEALTH STATUS
argo-virtual-server        Synced        Healthy
cert-manager               Synced        Healthy
grafana                    Synced        Healthy
loki                       Synced        Healthy
nginx-ingress              Synced        Healthy
nginx-mesh                 Synced        Healthy
oauth-proxy                Synced        Healthy
opentelemetry-operator     Synced        Healthy
prometheus-operator        Synced        Healthy
prometheus-operator-crds   Synced        Healthy
sandbox-apps               Synced        Healthy
temppo                     Synced        Healthy
```

---

### 5. Verification

If you have the argocd CLI utility [installed](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli),
you can use it to view additional information and troubleshoot issues as needed:

1) Fetch the ArgoCD Admin Password
```text
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

2) Port Forward ArgoCD CLI Commands
```text
export ARGOCD_OPTS='--port-forward-namespace argocd'
```

3) Login To The ArgoCD Instance
```text
argocd login --port-forward --insecure
```

4) View App Rollout Progress
```text
argocd app get sandbox-apps
```

When complete you should see a list that looks like this (all items are Synced and Healthy/blank):

```text
GROUP        KIND         NAMESPACE    NAME                      STATUS  HEALTH   HOOK  MESSAGE
             Secret       oauth-proxy  dex-config-secret         Synced                 secret/dex-config-secret configured
argoproj.io  Application  argocd       cert-manager              Synced  Healthy        application.argoproj.io/cert-manager configured
argoproj.io  Application  argocd       nginx-ingress             Synced  Healthy        application.argoproj.io/nginx-ingress configured
             ConfigMap    kube-system  coredns                   Synced
             Namespace                 oauth-proxy               Synced
             Secret       oauth-proxy  oauth-proxy-creds         Synced
argoproj.io  AppProject   argocd       cluster-services          Synced
argoproj.io  Application  argocd       argo-virtual-server       Synced  Healthy
argoproj.io  Application  argocd       gatekeeper                Synced  Healthy
argoproj.io  Application  argocd       grafana                   Synced  Healthy
argoproj.io  Application  argocd       loki                      Synced  Healthy
argoproj.io  Application  argocd       nginx-mesh                Synced  Healthy
argoproj.io  Application  argocd       oauth-proxy               Synced  Healthy
argoproj.io  Application  argocd       opentelemetry-operator    Synced  Healthy
argoproj.io  Application  argocd       prometheus-operator       Synced  Healthy
argoproj.io  Application  argocd       prometheus-operator-crds  Synced  Healthy
argoproj.io  Application  argocd       sealed-secrets            Synced  Healthy
argoproj.io  Application  argocd       tempo                     Synced  Healthy
```

---

## 6. Access Sandbox Services
Once all services are in 'Synced, Healthy' state, and you've updated the DNS records as described [here](dns.md),
you should be able to securely access the ArgoCD and Grafana services at:

```text
https://argocd.YOUR_DOMAIN/
https://grafana.YOUR_DOMAIN/
```

If you're using the default Dex IDP, you can fetch the credentials for the admin@example.com domain
from the cluster as follows:

```text
kubectl get secret -n oauth-proxy oauth-proxy-creds -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

Please see the [troubleshooting](../troubleshooting.md) guide for investigating issues.