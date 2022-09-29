# Sandbox Service: OPA Gatekeeper

## Quick Links
* [Project Site](https://argo-cd.readthedocs.io/en/stable/)
* [Github Repo](https://github.com/argoproj/argo-cd)
* [Helm Chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)

## Background
ArgoCD is a declarative GitOps continuous delivery tool for Kubernetes. It's used extensively in the Sandbox, as the 
means by which all of the other Sandbox Apps and services are delivered to the cluster. It's also available for
Sandbox cluster operators to take advantage of for delivery of their own applications or modifications to the base
Sandbox environment.

## Sandbox Customizations
The Sandbox installation of Argocd uses a mostly default set of Helm Values for the official Chart, along with a number
of customizations to add resources that deliver and configure the Sandbox Applications.

The customizations passed to argo-cd by default are as follows:
* Explicitly set the RBAC default Policy to ReadOnly for GUI viewers.
* Enables health message checking for theArgoCD application type so ordered deployments (sync waves) will work.

It's strongly recommended to include an OIDC config for argoCD. If deploying from the Sandbox-Base Helm chart, or
the Porter bundle, the values overrides containing the commented lines below can be added to the sandbox-values
file passed in.

Modifications can be passed to the official chart (by adding them under a "argo-cd" key) via values file as follows:

```
argo-cd:
  crds:
    # Required because argo-cd helm handles crds as templates rather than in crds directory.
    install: false
  server:
    # Set the default policy for logged in GUI users to readonly.
    rbacConfig:
      policy.default: role:readonly
    config:
      resource.customizations.health.argoproj.io_Application: |-
        hs = {}
        hs.status = "Progressing"
        hs.message = ""
        if obj.status ~= nil then
          if obj.status.health ~= nil then
            hs.status = obj.status.health.status
            if obj.status.health.message ~= nil then
              hs.message = obj.status.health.message
            end
          end
        end
        return hs 
    # Example values for Azure AD
    # config:
    #   oidc.config: |
    #     name: AzureAD
    #     issuer: {{ YOUR_OIDC_ISSUER_URL }}
    #     clientID: $oauth-secret:oidc.clientId
    #     clientSecret: $oauth-secret:oidc.clientSecret
    #     requestedIDTokenClaims:
    #       groups:
    #         essential: true
    #     requestedScopes:
    #       - openid
    #       - profile
    #       - email
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.