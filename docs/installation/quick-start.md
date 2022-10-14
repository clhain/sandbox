# Quick Start

A local instance of the sandbox can be stood up on a [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
cluster to get a feel for it. Some of the components (SSL Auto-Certs for instance) rely on publicly reachable
ingress addresses with DNS zones, so consider moving to a cloud provider to take full advantage.

## Pre-Reqs

* Install Kind: [Kind Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/).
* Install Helm: [Helm Install Guide](https://helm.sh/docs/intro/install/).
* Install Kubectl: [Kubectl Install Guide](https://kubernetes.io/docs/tasks/tools/).
* Install ArgoCD CLI: [Argo Getting Started Guide](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli) (Optional)

Approximate CPU and Memory utilization on an idle Sandbox cluster can be seen in the [Cluster Requirements](pre-reqs.md#cluster-requirements)
section of the docs.

## Installation

1) Add Helm Chart Repo
```text
helm repo add sandbox-charts https://clhain.github.io/sandbox-helm-charts
```

2) Create kind cluster
```text
kind create cluster
```

3) Install Sandbox-Base Helm Chart
```text
helm upgrade sandbox-base sandbox-charts/sandbox-base --install --namespace argocd --create-namespace --set clusterTLSInsecure=true
```

## Verification
Once the chart is applied, argocd will be deployed to finish the application of the sandbox app suite. This process typically takes
10 or more minutes, and you can view the progress as follows:

1) Fetch the ArgoCD Admin Password
```text
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
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

When complete you should see a list that looks approximately like this (where all items are Synced/Healthy):

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

## Connecting


## Troubleshooting
If you see the child apps not progressing, and the following status condition on `argocd app get sandbox-apps`, it's the result of a race condition where
helm applies the sandbox app before the argocd server is ready to handle it. It will eventually retry, but you can speed
the process up by forcing a sync immediately with `argocd app sync sandbox-apps`.

```text
CONDITION        MESSAGE                                                                                                                                                  LAST TRANSITION
ComparisonError  rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial tcp 10.96.150.135:8081: connect: connection refused"  2022-10-14 02:55:38 +0000 UTC
```