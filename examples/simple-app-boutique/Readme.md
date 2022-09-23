# Example Installation Of The Boutique App on F5 Opinionated Cluster

TODO

## Redirect URIs
https://argocd.yourzone.com/auth/callback
https://auth.yourzone.com/oauth2/callback


## DNS
Example records for yourzone.com:
```
ingress        IN      A       <ingress ip address (kubectl get service -n nginx-ingress)>
auth           IN      CNAME   ingress.yourzone.com.
argocd         IN      CNAME   ingress.yourzone.com.
app            IN      CNAME   ingress.yourzone.com.
grafana        IN      CNAME   ingress.yourzone.com.
```
