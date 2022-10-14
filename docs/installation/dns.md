# Sandbox DNS Records
In order to direct traffic to the default services enabled by the Sandbox project,
DNS records must exist which point the service names to your cluster ingress IP. For
ease of management, it's suggested that a single A record be created for the cluster,
and then additional CNAME records for the services which point at that cluster A record.


## Sample Zone File
Example records for yourzone.com:
```text
ingress        IN      A       <ingress ip address (kubectl get service -n nginx-ingress)>
auth           IN      CNAME   ingress.yourzone.com.   # Required for oauth2 proxy
argocd         IN      CNAME   ingress.yourzone.com.   # ArgoCD UI
grafana        IN      CNAME   ingress.yourzone.com.   # Grafana UI
your-app       IN      CNAME   ingress.yourzone.com.   # Add any additional services
```

## Alternative
If you don't have an available DNS domain, you can use a service like [nip.io](https://nip.io) which automatically
directs `*.[your-ip].nip.io` to the ip specified by setting the Cluster Domain to `[your-ip].nip.io` at install time.
This method isn't compatible with Automatic SSL Certs from LetsEncrypt, so you'll also need to either:

* Disable the TLS endpoints with helm argument `--set clusterTLSInsecure=true`
* Modify the cert-manager or virtual-servers to work with alternate settings (see [Customizing Default Services](../customization/default-services.md))