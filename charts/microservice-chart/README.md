# microservice-chart

![Version: 1.18.0](https://img.shields.io/badge/Version-1.18.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

A Helm chart for PagoPA microservice

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.cooldownPeriod | int | `300` |  |
| autoscaling.enable | bool | `false` |  |
| autoscaling.maxReplica | int | `1` |  |
| autoscaling.minReplica | int | `1` |  |
| autoscaling.pollingInterval | int | `10` |  |
| autoscaling.triggers | list | `[]` |  |
| canaryDelivery | object | - | This section allow to configure canary deployment |
| canaryDelivery.create | bool | `false` | Enable Canary/BlueGreen Deployment |
| canaryDelivery.deployment.create | bool | `true` | Enable Deployment for Canary/BlueGreen Deployment |
| canaryDelivery.deployment.envConfig | object | `{}` | Environment config to use for the canary container |
| canaryDelivery.deployment.envSecret | object | `{}` | Environment secrets to use for the canary container |
| canaryDelivery.deployment.image.pullPolicy | string | `"Always"` | Pull policy to use |
| canaryDelivery.deployment.image.repository | string | `"ghcr.io/pagopa/devops-java-springboot-color"` | Docker reposity for the container canary |
| canaryDelivery.deployment.image.tag | string | `"0.7.1"` | Container TAG |
| canaryDelivery.ingress | object | - | This section allow to configure ingress inside canary deployment |
| canaryDelivery.ingress.canary | object | - | Configure how ingress canary should be |
| canaryDelivery.ingress.canary.headerName | string | `"canary"` | the header name used to call the canary deployment |
| canaryDelivery.ingress.canary.headerValue | string | `"pagopa"` | the header values used to call the canary deployment |
| canaryDelivery.ingress.canary.type | string | `"header"` | The type of canary can be header|bluegreen |
| canaryDelivery.ingress.canary.weightPercent | int | `10` | the weight percent used into canary deployment. Can be used toghether with header |
| canaryDelivery.ingress.create | bool | `true` | Enable Ingress for Canary/BlueGreen Deployment |
| canaryDelivery.service.create | bool | `true` | Enable Service for Canary/BlueGreen Deployment |
| deployment | object | - | Configure deployment  |
| deployment.create | bool | `true` | create the deployment manifest |
| deployment.replicas | int | `1` | Number of replicas for this deployment |
| envConfig | object | `{}` | Environment config to use for the canary container |
| envSecret | object | `{}` | Environment secrets to use for the canary container |
| fullnameOverride | string | `""` | Helm chart fullname override |
| image.pullPolicy | string | `"Always"` | Pull policy to use |
| image.repository | string | `""` | Docker reposity for the container |
| image.tag | string | `"v0.0.0"` | Container TAG |
| ingress.create | bool | `false` | Create or not the ingress manifest |
| ingress.forceSslRedirect | bool | `true` | if force ssl redirect is enabled |
| ingress.host | string | `""` | Hostname for the ingress like https://idpay.pagopa.it  |
| ingress.path | string | `"/"` | Path where the application can response like: `/app` |
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| ingress.rewriteTarget | string | `"/$1"` | the rewrite target for ingress |
| keyvault | object | `{"name":"","tenantId":""}` | Azure KeyVault connection configuration |
| keyvault.name | string | `""` | KV name |
| keyvault.tenantId | string | `""` | Tenant id (uuid) |
| livenessProbe.failureThreshold | int | `6` | Numbers of failures before consider the pod fail |
| livenessProbe.httpGet.path | string | `"/healthz/live"` | This is the liveness check endpoint |
| livenessProbe.httpGet.port | int | `80` |  |
| livenessProbe.initialDelaySeconds | int | `60` | Initial delay before start checking |
| livenessProbe.periodSeconds | int | `10` | Numbers of seconds between one failure and other |
| nameOverride | string | `""` | Helm chart name override |
| namespace | string | `""` | Namespace in which deploy the microservice |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.failureThreshold | int | `6` | Numbers of failures before consider the pod fail |
| readinessProbe.httpGet.path | string | `"/healthz/ready"` | This is the readiness check endpoint |
| readinessProbe.httpGet.port | int | `80` |  |
| readinessProbe.initialDelaySeconds | int | `60` | Initial delay before start checking |
| readinessProbe.periodSeconds | int | `10` | Numbers of seconds between one failure and other |
| resources | object | - | POD resources section |
| resources.limits | object | `{"cpu":"150m","memory":"128Mi"}` | limits is mandatory |
| resources.requests | object | `{"cpu":"40m","memory":"96Mi"}` | request is mandatory |
| secretProviderClass | object | `{"create":true}` | Secrect provider class allow to connect to azure kv |
| secretProviderClass.create | bool | `true` | create or not the secret provider class manifest |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| service.create | bool | `true` | create the service manifest |
| service.port | int | `80` | Which port use (! this port is used even inside the deployment) |
| service.type | string | `"ClusterIP"` | Which type of service to use |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)
