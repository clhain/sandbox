# Sandbox Service: OPA Gatekeeper

## Quick Links
* [Project Site](https://open-policy-agent.github.io/gatekeeper/website/docs/)
* [Github Repo](https://github.com/open-policy-agent/gatekeeper)
* [Helm Chart](https://github.com/open-policy-agent/gatekeeper/tree/master/charts/gatekeeper)

## Background
Open Policy Agent's Gatekeeper project is a Policy Engine for Cloud Native environments. It can act as an
admission controller, gating the creation, update, or deletion of K8S resources.

## Sandbox Customizations
The Sandbox installation of Gatekeeper uses the same default values as the official helm chart, with no customizations.

Modifications can be passed to the official chart (by adding them under a "gatekeeper" key) via values file as follows:

```
gatekeeper:
    replicas: 3
```

See [Customizing Default Services](../customization/default-services.md) for more information on overriding default values.