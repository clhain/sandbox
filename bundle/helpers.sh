#!/usr/bin/env bash

set -euo pipefail

tf_output() {
  cd /cnab/app/terraform && terraform output -json > /cnab/app/tfoutput.json
}


success-message(){
  echo
  echo
  echo "#############################################################"
  echo "##### Sandbox Base Deployment Complete"
  echo "#############################################################"
  echo
  echo "##### Next Steps: #####"
  echo
  echo "#############################################################"
  echo '# 1. Configure cluster DNS records'
  echo "#############################################################"
  echo
  echo " Recommended zone configuration:"
  echo
  echo "    ${CLUSTER_NAME}-ingress        IN      A       ${INGRESS_IP}"
  echo "    auth                           IN      CNAME   ${CLUSTER_NAME}-ingress.${CLUSTER_DOMAIN}."
  echo "    argocd                         IN      CNAME   ${CLUSTER_NAME}-ingress.${CLUSTER_DOMAIN}."
  echo "    grafana                        IN      CNAME   ${CLUSTER_NAME}-ingress.${CLUSTER_DOMAIN}."
  echo
  echo "#############################################################"
  echo "# 2. Wait for Argo to deploy all cluster services"
  echo "#############################################################"
  echo
  echo "  - Check progress via the command line after connecting to your cluster with \"kubectl get apps -n ${INSTALL_NS}\""
  echo
  echo "  - Check progress via the argocd CLI after connecting to your cluster with:"
  echo
  echo "        - kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo"
  echo "        - export ARGOCD_OPTS='--port-forward-namespace argocd'"
  echo "        - argocd login --port-forward --insecure"
  echo "        - argocd app get sandbox-apps"
  echo
  echo "  - Check progress via the gui:"
  echo
  echo "      - Fetch the admin password:"
  echo "              kubectl get secret -n ${INSTALL_NS} argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d"
  echo
  echo "      - Port forward the service:"
  echo "              kubectl port-forward -n ${INSTALL_NS} service/sandbox-base-argocd-server 8080:443"
  echo
  echo "      - Browse to https://localhost:8080/, accept the cert, and login with admin / password prior step"
  echo
}

"$@"
