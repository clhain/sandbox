# Example GCP Cluster Bundle

## PRE-REQ

### GCP Service Accounts

#### Porter Deployer
A GCP service account JSON key is required to deploy the bundle. 
https://cloud.google.com/iam/docs/creating-managing-service-accounts#creating

Required permissions for the deployer Service Account are:
- Compute Admin
- Compute Network Admin
- Kubernetes Engine Admin
- Kubernetes Engine Cluster Admin
- Service Account User

Example account creation and permission commands (must be run by a user with permissions to create service accounts):
```
gcloud iam service-accounts create porter-deployer-sa \
    --description="Service Account Used with Porter to deploy GCP assets" \
    --display-name="Porter Deploy Service Account"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:porter-deployer-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:porter-deployer-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.admin"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:porter-deployer-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.clusterAdmin"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:porter-deployer-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.networkAdmin"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:porter-deployer-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.admin"
```

#### Cluster Node Service Account
An existing service account for use with cluster nodes is also required prior to bundle installation.
The name of the service account can be passed as a parameter, no json key is required. If the cluster
needs access to Google Container Registry associated with the project, add the Storage Object Reader
permission (or permissions for any other GCP resources to be accessed by the nodes).

Example gcloud commands:
```
gcloud iam service-accounts create cluster-node-sa \
    --description="Service Account For GKE Cluster Nodes" \
    --display-name="Cluster Node Service Account"

gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:cluster-node-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"
```

### Oauth2 Proxy Client Credentials
Use of the included oauth2 proxy for authentication requires client credentials specific to the Auth Provider.
Follow the documentation here: https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/oauth_provider/

### KIC Image
The bundle requires a custom build of Kubernetes Ingress Controller for tracing to
work correctly (Nginx Plus with App Protect and Otel). It's recommended to build and
deploy this to the same project's registry, otherwise image pull secrets would need to be added.

Alternatively, you can use a pre-built image by adjusting the value of the following porter parameters (via params.yaml):
```
  - name: kic-repository
    type: string
    default: "us.gcr.io/f5-gcs-7506-ptg-deos-octo-dev/nginx-plus-ingress"
  - name: kic-app-version
    type: string
    default: "2.1.1-jaeger-nap-dos2"
  - name: kic-nginxplus
    type: boolean
    default: true
```

### Porter Version
This bundle only works with v1.x.x versions of the porter utility. Install using the instructions here:
- https://porter.sh/install/#recommended


## Installation

### Porter build and publish
Identify the registry where you intend to publish the porter bundle, then update line 5 in porter.yaml:
- registry: [push to repo]

Once updated, run `porter publish` from the parent directory. You may need to run docker login against the repo
to ensure porter can access it.

### Porter Creds and Params
1. Adjust the parameters found in params.yaml as needed for your deployment. 
2. Add the GCP Service account json key to an environment variable named GCLOUD_KEY. E.g. `export GCLOUD_KEY='{your key content}'`

### Porter install
Run
```
porter credentials apply creds.yaml
porter parameters apply params.yaml
porter installations apply installation.yaml
```

### Secure The Cluster
The following commands will deny 80, 443 from all sites except F5 VPN. This will disrupt automatic cert provision / refresh.

```
gcloud compute --project=<your project> firewall-rules create f5-demo-cluster-allow-vpn-web --description="Allow f5 web traffic from vpn sites." --direction=INGRESS --priority=999 --network=default --action=ALLOW --rules=tcp:80,tcp:443 --source-ranges=104.219.104.0/21,106.120.75.16/28,63.149.115.96/28,109.231.234.224/27,185.20.63.0/27,50.236.107.0/28,162.220.44.16/28,111.223.104.64/27,42.61.112.48/28,204.98.164.48/29,65.181.53.144/29,97.75.176.64/28,65.61.116.96/28,203.134.38.96/29,212.150.5.64/27,210.226.41.192/27,113.43.213.160/27,189.201.174.96/28,200.94.108.144/28,1.6.70.48/28,115.110.154.64/28 --target-tags=f5-demo-cluster

gcloud compute --project=<your project> firewall-rules create f5-demo-cluster-deny-web --direction=INGRESS --priority=1000 --network=default --action=DENY --rules=tcp:80,tcp:443 --source-ranges=0.0.0.0/0 --target-tags=f5-demo-cluster
```