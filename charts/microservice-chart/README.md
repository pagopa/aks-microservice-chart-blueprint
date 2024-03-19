# microservice-chart

![Version: 5.4.0](https://img.shields.io/badge/Version-5.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

A Helm chart for PagoPA microservice

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod labels affinity |
| autoscaling | object | - | Autoscaling using KEDA |
| autoscaling.advanced | object | `{}` | Autoscaling advanced <https://keda.sh/docs/2.9/concepts/scaling-deployments/#advanced> |
| autoscaling.cooldownPeriod | int | `300` | Autoscaling cooldown period |
| autoscaling.enable | bool | `false` | Enable Autoscaling |
| autoscaling.maxReplica | int | `1` | Autoscaling maximum replicas |
| autoscaling.minReplica | int | `1` | Autoscaling minimum replicas |
| autoscaling.pollingInterval | int | `10` | Autoscaling event polling intervall |
| autoscaling.triggers | list | `[]` | Autoscaling triggers as per [Keda scalers](https://keda.sh/docs/2.6/scalers/) |
| canaryDelivery | object | - | This section allow to configure canary deployment |
| canaryDelivery.create | bool | `false` | Beta/Enable Canary/BlueGreen Deployment |
| canaryDelivery.ingress | object | - | This section allow to configure ingress inside canary deployment |
| configMapFromFile | object | `{}` | Configure files to mount as config maps |
| deployment | object | - | Configure deployment |
| deployment.create | bool | `true` | Create or not the deployment manifest |
| deployment.forceRedeploy | bool | `false` | Force redeploy container |
| deployment.replicas | int | `1` | Number of replicas (will be replaced by autoscaling if enabled) |
| envConfig | object | `{}` | Environment config to use for the canary container |
| envFieldRef | object | `{}` | Environment config from k8s metadata |
| envSecret | object | `{}` | Load secrets as environment variables from kv |
| externalConfigMapFiles | object | {} | Configure values from config maps external to chart. E.g already present into cluster, see documentation |
| externalConfigMapFiles.configMaps | list | `[]` | Config maps to mount as files: e.g. [{name: "configmap", key: "user.xml"}] |
| externalConfigMapValues.configMaps | list | `[]` | Config maps to mount as files: e.g. [{name: "configmap", key: "mykey"}] |
| fullnameOverride | string | `""` | Helm chart fullname override |
| image | object | {} | image: configuration for the container |
| image.pullPolicy | string | `"Always"` | Pull policy to use |
| image.repository | string | `""` | Docker reposity for the container |
| image.tag | string | `"v0.0.0"` | Container TAG |
| ingress | object | - | Ingress configuration |
| ingress.annotations | map | `{}` | custom annotations for ingress |
| ingress.create | bool | `false` | Create or not the ingress manifest |
| ingress.forceSslRedirect | bool | `true` | if force ssl redirect is enabled |
| ingress.host | string | `""` | Hostname for the ingress like <https://idpay.pagopa.it> |
| ingress.path | string | `"/please-put-a-path"` | Path where the application can response like: `/app(/|$)(.*)` |
| ingress.proxyBodySize | string | `"1m"` | the size allowed by nginx.ingress.kubernetes.io/proxy-body-size for client request body |
| ingress.rewriteTarget | string | `"/$1"` | the rewrite target for ingress |
| ingress.servicePort | int | `8080` | service port to reach |
| keyvault | object | `{"name":"","tenantId":""}` | Configure keyvault to use inside secret prover to load secret directly |
| keyvault.name | string | `""` | Key vault name |
| keyvault.tenantId | string | `""` | Tenant ID |
| livenessProbe | object | {} | LivenessProbe |
| nameOverride | string | `""` | Helm chart name override |
| namespace | string | `""` | Namespace in which deploy the microservice |
| nodeSelector | object | `{}` | K8s node selectors |
| persistentVolumeClaimsMounts | object | `{"create":false,"mounts":[]}` | Configure optional volume that mount using a PVC |
| persistentVolumeClaimsMounts.mounts | list | `[]` | Mounts with pvc volume: (e.g. [{name: "tmp", mountPath: "/tmp", pvcName: "xyz"}]]) |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget | object | `{"create":false,"maxUnavailable":"","minAvailable":0}` | generate PodDisruptionBudget |
| podDisruptionBudget.maxUnavailable | mutually exclusive with minAvailable | `""` | Max number of pods unavailable before destroy node |
| podDisruptionBudget.minAvailable | mutually exclusive with maxUnavailable | `0` | Min number of pods that must be alive before destroy node |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| providedVolumeMount | object | {} | Configure mounted volumes with secrets needed to mount them |
| readinessProbe | object | {} | ReadinessProbe |
| resources | object | - | POD resources section |
| resources.limits | object | `{"cpu":"150m","memory":"128Mi"}` | limits is mandatory |
| resources.requests | object | `{"cpu":"40m","memory":"96Mi"}` | request is mandatory |
| restartPolicy | string | `"Always"` | Restart policy |
| secretProviderClass | object | `{"create":true}` | Configure secret provider with secrets to mount as environment variables |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"all"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| service.create | bool | `true` | create the service manifest |
| service.ports | list | `[8080]` | Which ports use (! this port is used even inside the deployment) |
| service.type | string | `"ClusterIP"` | Which type of service to use |
| serviceAccount | object | - | Service account configuration |
| serviceMonitor.create | bool | `false` | Create or not the service monitor |
| serviceMonitor.endpoints | list | `[]` |  |
| sidecars | list | `[]` | Sidecars, each object has exactly the same schema as a Pod, except it does not have an apiVersion or kind |
| strategy | object | {} | strategy type for deployment: Recreate or RollingUpdate |
| terminationGracePeriodSeconds | int | `30` | Termination grace period in seconds |
| tmpVolumeMount | object | `{"create":true,"mounts":[{"mountPath":"/tmp","name":"tmp"}]}` | Configure optional tmp volume to mount (Use instance storage) |
| tmpVolumeMount.mounts | list | `[{"mountPath":"/tmp","name":"tmp"}]` | Mounts to add to the tmp volume: (e.g. [{name: "tmp", mountPath: "/tmp"}]]) |
| tolerations | list | `[]` | Pod taints toleration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
