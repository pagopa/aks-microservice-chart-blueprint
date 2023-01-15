# microservice-chart

![Version: 2.3.0](https://img.shields.io/badge/Version-2.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

A Helm chart for PagoPA microservice

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod labels affinity |
| autoscaling | object | - | Autoscaling using KEDA |
| autoscaling.cooldownPeriod | int | `300` | Autoscaling cooldown period |
| autoscaling.enable | bool | `false` | Enable Autoscaling |
| autoscaling.maxReplica | int | `1` | Autoscaling maximum replicas |
| autoscaling.minReplica | int | `1` | Autoscaling minimum replicas |
| autoscaling.pollingInterval | int | `10` | Autoscaling event polling intervall |
| autoscaling.triggers | list | `[]` | Autoscaling triggers as per [Keda scalers](https://keda.sh/docs/2.6/scalers/) |
| canaryDelivery | object | - | This section allow to configure canary deployment |
| canaryDelivery.create | bool | `false` | Beta/Enable Canary/BlueGreen Deployment |
| canaryDelivery.deployment | object | - | Beta/Deployment |
| canaryDelivery.deployment.create | bool | `true` | Beta/Enable Deployment for Canary/BlueGreen Deployment |
| canaryDelivery.deployment.envConfig | object | `{}` | Environment config to use for the canary container |
| canaryDelivery.deployment.envFieldRef | object | `{}` | Environment config from k8s metadata for the canary container |
| canaryDelivery.deployment.envSecret | object | `{}` | Environment secrets to use for the canary container |
| canaryDelivery.deployment.fileConfig | object | `{}` | File config pattern to mount for the canary container |
| canaryDelivery.deployment.fileShare.create | bool | `false` | create the service manifest for Canary/BlueGreen Deployment |
| canaryDelivery.deployment.fileShare.folders | list | `[]` | Which fileshare use (! this name is used even inside the deployment) for Canary/BlueGreen Deployment |
| canaryDelivery.deployment.forceRedeploy | bool | `false` | Force redeploy canary container |
| canaryDelivery.deployment.image.pullPolicy | string | `"Always"` | Pull policy to use |
| canaryDelivery.deployment.image.repository | string | `"ghcr.io/pagopa/devops-java-springboot-color"` | Docker reposity for the container canary |
| canaryDelivery.deployment.image.tag | string | `"0.7.1"` | Container TAG |
| canaryDelivery.ingress | object | - | This section allow to configure ingress inside canary deployment |
| canaryDelivery.ingress.canary | object | - | Configure how ingress canary should be |
| canaryDelivery.ingress.canary.headerName | string | `"canary"` | the header name used to call the canary deployment |
| canaryDelivery.ingress.canary.headerValue | string | `"pagopa"` | the header values used to call the canary deployment |
| canaryDelivery.ingress.canary.type | string | `"header"` | The type of canary can be header|bluegreen |
| canaryDelivery.ingress.canary.weightPercent | int | `10` | the weight percent used into canary deployment. Can be used toghether with header |
| canaryDelivery.ingress.create | bool | `true` | Beta/Enable Ingress for Canary/BlueGreen Deployment |
| canaryDelivery.secretProviderClass | object | - | Beta/SecretProviderClass |
| canaryDelivery.secretProviderClass.create | bool | `true` | Beta/create or not the secret provider class manifest |
| canaryDelivery.service.create | bool | `true` | Beta/Enable Service for Canary/BlueGreen Deployment |
| canaryDelivery.serviceMonitor.create | bool | `false` | Create or not the service monitor |
| deployment | object | - | Configure deployment |
| deployment.create | bool | `true` | create the deployment manifest |
| deployment.forceRedeploy | bool | `false` | Force redeploy container |
| deployment.replicas | int | `1` | Number of replicas for this deployment |
| envConfig | object | `{}` | Environment config to use for the canary container |
| envConfigMapExternals | object | {} | Configure values from config maps external to chart. E.g already present into cluster, see documentation |
| envFieldRef | object | `{}` | Environment config from k8s metadata |
| envSecret | object | `{}` | Environment secrets to use for the canary container |
| fileConfig | object | `{}` | File config pattern to mount |
| fileConfigExternals.configMaps | list | `[]` |  |
| fileConfigExternals.create | bool | `false` |  |
| fileShare.create | bool | `false` | create the service manifest |
| fileShare.folders | list | `[]` | Which fileshare use (! this name is used even inside the deployment) |
| fullnameOverride | string | `""` | Helm chart fullname override |
| image.pullPolicy | string | `"Always"` | Pull policy to use |
| image.repository | string | `""` | Docker reposity for the container |
| image.tag | string | `"v0.0.0"` | Container TAG |
| ingress | object | - | Ingress configuration |
| ingress.annotations | map | `{}` | custom annotations for ingress |
| ingress.create | bool | `false` | Create or not the ingress manifest |
| ingress.forceSslRedirect | bool | `true` | if force ssl redirect is enabled |
| ingress.host | string | `""` | Hostname for the ingress like https://idpay.pagopa.it |
| ingress.path | string | `"/"` | Path where the application can response like: `/app` |
| ingress.proxyBodySize | string | `"1m"` | the size allowed by nginx.ingress.kubernetes.io/proxy-body-size for client request body |
| ingress.rewriteTarget | string | `"/$1"` | the rewrite target for ingress |
| ingress.servicePort | int | `""` | service port to reach |
| keyvault | object | - | Azure KeyVault connection configuration |
| keyvault.name | string | `""` | KV name |
| keyvault.tenantId | string | `""` | Tenant id (uuid) |
| livenessProbe.failureThreshold | int | `6` | Numbers of failures before consider the pod fail |
| livenessProbe.httpGet | object | - | httpGet will be put as is into deployment yaml |
| livenessProbe.httpGet.path | string | `"/healthz/live"` | Live (health) path used by app |
| livenessProbe.httpGet.port | int | `80` | Live (health) port used by app |
| livenessProbe.initialDelaySeconds | int | `60` | Initial delay before start checking |
| livenessProbe.periodSeconds | int | `10` | Numbers of seconds between one failure and other |
| nameOverride | string | `""` | Helm chart name override |
| namespace | string | `""` | Namespace in which deploy the microservice |
| nodeSelector | object | `{}` | K8s node selectors |
| podAnnotations | object | `{}` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.failureThreshold | int | `6` | Numbers of failures before consider the pod fail |
| readinessProbe.httpGet | object | - | httpGet will be put as is into deployment yaml |
| readinessProbe.httpGet.path | string | `"/healthz/ready"` | Ready (health) path used by app |
| readinessProbe.httpGet.port | int | `80` | Ready (health) port used by app |
| readinessProbe.initialDelaySeconds | int | `60` | Initial delay before start checking |
| readinessProbe.periodSeconds | int | `10` | Numbers of seconds between one failure and other |
| resources | object | - | POD resources section |
| resources.limits | object | `{"cpu":"150m","memory":"128Mi"}` | limits is mandatory |
| resources.requests | object | `{"cpu":"40m","memory":"96Mi"}` | request is mandatory |
| restartPolicy | string | `"Always"` |  |
| secretProviderClass | object | - | Secrect provider class allow to connect to azure kv |
| secretProviderClass.create | bool | `true` | create or not the secret provider class manifest |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| service.create | bool | `true` | create the service manifest |
| service.ports | list | `[]` | Which ports use (! this port is used even inside the deployment) |
| service.type | string | `"ClusterIP"` | Which type of service to use |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.create | bool | `false` | Create or not the service monitor |
| serviceMonitor.endpoints | list | `[]` |  |
| sidecars | list | `[]` | Sidecars, each object has exactly the same schema as a Pod, except it does not have an apiVersion or kind |
| strategy.rollingUpdate.maxSurge | string | `"25%"` |  |
| strategy.rollingUpdate.maxUnavailable | string | `"25%"` |  |
| strategy.type | string | `"RollingUpdate"` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| tolerations | list | `[]` | Pod taints toleration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
