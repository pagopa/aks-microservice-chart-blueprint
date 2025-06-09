# microservice-chart

![Version: 8.0.0](https://img.shields.io/badge/Version-8.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

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
| azure | object | `{"workloadIdentityClientId":"","workloadIdentityEnabled":true}` | Azure configuration (e.g. Workload identities) |
| azure.workloadIdentityClientId | string | `""` | Azure Workload Identity Client ID (e.g. qwerty123-a1aa-1234-xyza-qwerty123) |
| azure.workloadIdentityEnabled | bool | `true` | Enable workload identity |
| canaryDelivery | object | - | This section allow to configure canary deployment |
| canaryDelivery.create | bool | `false` | Beta/Enable Canary/BlueGreen Deployment |
| canaryDelivery.ingress | object | `{"bluegreen":false,"envConfig":{},"envSecret":{},"header":true,"headerName":"X-Canary","headerValue":"pagopa","image":{"repository":"","tag":""},"weightPercent":10}` | Configure how ingress canary should be |
| canaryDelivery.ingress.envConfig | object | `{}` | Environment config to use for the canary container |
| canaryDelivery.ingress.envSecret | object | `{}` | Load secrets as environment variables from kv for the canary container |
| canaryDelivery.ingress.headerName | string | `"X-Canary"` | the header name used to call the canary deployment |
| canaryDelivery.ingress.headerValue | string | `"pagopa"` | the header values used to call the canary deployment |
| canaryDelivery.ingress.image.repository | string | `""` | Docker reposity for the container canary |
| canaryDelivery.ingress.image.tag | string | `""` | Container TAG |
| canaryDelivery.ingress.weightPercent | int | `10` | the weight percent used into canary deployment. Can be used toghether with header |
| configMapFromFile | object | `{}` | Configure files to mount as config map. This files definition are inside the values*.yaml file |
| configMapFromFileCustomPath | string | `"/mnt/file-config"` | CustomPath to allow to choose where to put your files |
| container.args | list | `[]` |  |
| container.command | list | `[]` |  |
| deployment | object | - | Configure deployment |
| deployment.create | bool | `true` | Create or not the deployment manifest |
| deployment.forceRedeploy | bool | `false` | Force redeploy container |
| deployment.replicas | int | `1` | Number of replicas (will be replaced by autoscaling if enabled) |
| deployment.revisionHistoryLimit | int | `3` | Number of revision/replicaSet to have has history + 1 current revision |
| deployment.topologySpreadConstraints | object | `{"config":[],"create":false,"useDefaultConfiguration":false}` | Topology Spread Constraints configuration create: abilita/disabilita la feature useDefaultConfiguration: se true usa la configurazione di default (vedi _helpers.tpl), se false usa config config: array di oggetti topologySpreadConstraints custom |
| envConfig | object | `{}` | Environment config to use for the container |
| envFieldRef | object | `{}` | Environment config from k8s metadata |
| envSecret | object | `{}` | Load secrets as environment variables from kv |
| externalConfigMapFiles | object | {} | Configure values from config maps external to chart. E.g already present into cluster, see documentation |
| externalConfigMapFiles.configMaps | list | `[]` | Config maps to mount as files: e.g. [{name: "configmap", key: "user.xml", mountPath: "/config/user.xml" }] |
| externalConfigMapFilesCustomPath | string | `"/mnt/file-config-external"` | CustomPath to allow to choose where to put your files |
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
| ingress.pathType | string | `"ImplementationSpecific"` | pathType |
| ingress.proxyBodySize | string | `"1m"` | the size allowed by nginx.ingress.kubernetes.io/proxy-body-size for client request body |
| ingress.rewriteTarget | string | `"/$1"` | the rewrite target for ingress |
| ingress.servicePort | int | `8080` | service port to reach |
| keyvault | object | `{"name":"","tenantId":""}` | Configure keyvault to use inside secret prover to load secret directly |
| keyvault.name | string | `""` | Key vault name |
| keyvault.tenantId | string | `""` | Tenant ID |
| livenessProbe | object | {} | LivenessProbe |
| livenessProbe.exec | object | `{"command":[]}` | exec options |
| livenessProbe.exec.command | list | `[]` | Command can be in yaml or array version e.g.: command: ["/bin/sh", "-c", '[ -d "/csv" ]'] |
| livenessProbe.failureThreshold | int | `1` | failureThreshold |
| livenessProbe.handlerType | string | `"httpGet"` | Choose the probe type: "httpGet" or "exec" or "tcpSocket" |
| livenessProbe.httpGet | object | `{"path":"/alive","port":9999}` | httpGet options |
| livenessProbe.httpGet.path | string | `"/alive"` | path |
| livenessProbe.httpGet.port | int | `9999` | port |
| livenessProbe.initialDelaySeconds | int | `1` | initialDelaySeconds |
| livenessProbe.periodSeconds | int | `1` | periodSeconds |
| livenessProbe.successThreshold | int | `1` | successThreshold |
| livenessProbe.tcpSocket | object | `{"port":9999}` | tcpSocket options |
| livenessProbe.tcpSocket.port | int | `9999` | tcpSocket.port |
| livenessProbe.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds |
| livenessProbe.timeoutSeconds | int | `1` | timeoutSeconds |
| nameOverride | string | `""` | Helm chart name override |
| namespace | string | `""` | Namespace in which deploy the microservice |
| nodeSelector | object | `{}` | K8s node selectors |
| persistentVolumeClaimsMounts | object | `{"create":false,"mounts":[]}` | Configure optional volume that will be mount (using a PVC) |
| persistentVolumeClaimsMounts.mounts | list | `[]` | Mounts with pvc volume: (e.g. [{name: "tmp", mountPath: "/tmp", pvcName: "xyz"}]]) |
| podAnnotations | object | `{}` | podAnnotations |
| podDisruptionBudget | object | `{"create":false,"maxUnavailable":"","minAvailable":0}` | generate PodDisruptionBudget |
| podDisruptionBudget.create | bool | `false` | create |
| podDisruptionBudget.maxUnavailable | mutually exclusive with minAvailable | `""` | Max number of pods unavailable before destroy node |
| podDisruptionBudget.minAvailable | mutually exclusive with maxUnavailable | `0` | Min number of pods that must be alive before destroy node |
| podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | podSecurityContext |
| podSecurityContext.seccompProfile | object | `{"type":"RuntimeDefault"}` | seccompProfile |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | type |
| postman-test | object | - | Postman meta tags |
| postman-test.collectionName | string | `""` | collection name path (e.g. `mil-papos.postman_collection.json``) |
| postman-test.dir | string | `""` | directory where the postman file are saved (e.g. `src/test/postman``) |
| postman-test.envVariablesFile | string | `""` | env variable name path (e.g `dev.postman_environment.json``) |
| postman-test.repoName | string | `""` | repoName: github repo name (e.g. `devops-java-springboot-color`) |
| postman-test.run | bool | `true` | Run or not the tests |
| providedVolumeMount | object | {} | Configure how secrets taken from SecretS storage Class are mounted inside the pod |
| readinessProbe | object | {} | ReadinessProbe |
| readinessProbe.exec | object | `{"command":[]}` | exec options |
| readinessProbe.exec.command | list | `[]` | Command can be in yaml or array version e.g.: command: ["/bin/sh", "-c", '[ -d "/csv" ]'] |
| readinessProbe.failureThreshold | int | `1` | failureThreshold |
| readinessProbe.handlerType | string | `"httpGet"` | Choose the probe type: "httpGet" or "exec" or "tcpSocket" |
| readinessProbe.httpGet | object | `{"path":"/alive","port":9999}` | httpGet options |
| readinessProbe.httpGet.path | string | `"/alive"` | path |
| readinessProbe.httpGet.port | int | `9999` | port |
| readinessProbe.initialDelaySeconds | int | `1` | initialDelaySeconds |
| readinessProbe.periodSeconds | int | `1` | periodSeconds |
| readinessProbe.successThreshold | int | `1` | successThreshold |
| readinessProbe.tcpSocket | object | `{"port":9999}` | tcpSocket options |
| readinessProbe.tcpSocket.port | int | `9999` | tcpSocket.port |
| readinessProbe.timeoutSeconds | int | `1` | timeoutSeconds |
| resources | object | - | POD resources section |
| resources.limits | object | `{"cpu":"150m","memory":"128Mi"}` | limits is mandatory |
| resources.limits.cpu | string | `"150m"` | cpu |
| resources.limits.memory | string | `"128Mi"` | memory |
| resources.requests | object | `{"cpu":"40m","memory":"96Mi"}` | request is mandatory |
| resources.requests.cpu | string | `"40m"` | cpu |
| resources.requests.memory | string | `"96Mi"` | memory |
| restartPolicy | string | `"Always"` | Restart policy |
| secretProviderClass | object | `{"create":true}` | Configure secret provider with secrets to mount as environment variables |
| secretProviderClass.create | bool | `true` | create |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["all"]},"readOnlyRootFilesystem":true}` | securityContext |
| securityContext.allowPrivilegeEscalation | bool | `false` | allowPrivilegeEscalation |
| securityContext.capabilities | object | `{"drop":["all"]}` | capabilities |
| securityContext.capabilities.drop | list | `["all"]` | drop |
| securityContext.readOnlyRootFilesystem | bool | `true` | readOnlyRootFilesystem |
| service.create | bool | `true` | create the service manifest |
| service.ports | list | `[8080]` | Which ports use (! this port is used even inside the deployment) |
| service.type | string | `"ClusterIP"` | Which type of service to use |
| serviceAccount | object | - | Service account configuration |
| serviceAccount.create | bool | `false` | Create the service account object. If true use this object, otherwise use only the name reference |
| serviceAccount.name | string | `""` | Service account name, this service account already exists |
| serviceMonitor.create | bool | `false` | Create or not the service monitor |
| serviceMonitor.endpoints | list | `[]` |  |
| serviceMonitor.prometheusManaged | bool | `false` | Enable the compatibility with Azure Prometheus Managed |
| sidecars | list | `[]` | Sidecars, each object has exactly the same schema as a Pod, except it does not have an apiVersion or kind |
| startupProbe | object | {} | startupProbe |
| startupProbe.exec | object | `{"command":[]}` | exec options |
| startupProbe.exec.command | list | `[]` | Command can be in yaml or array version e.g.: command: ["/bin/sh", "-c", '[ -d "/csv" ]'] |
| startupProbe.failureThreshold | int | `1` | failureThreshold |
| startupProbe.handlerType | string | `"httpGet"` | Choose the probe type: "httpGet" or "exec" or "tcpSocket" |
| startupProbe.httpGet | object | `{"path":"/alive","port":9999}` | httpGet options |
| startupProbe.httpGet.path | string | `"/alive"` | path |
| startupProbe.httpGet.port | int | `9999` | port |
| startupProbe.initialDelaySeconds | int | `1` | initialDelaySeconds |
| startupProbe.periodSeconds | int | `1` | periodSeconds |
| startupProbe.successThreshold | int | `1` | successThreshold |
| startupProbe.tcpSocket | object | `{"port":9999}` | tcpSocket options |
| startupProbe.tcpSocket.port | int | `9999` | tcpSocket.port |
| startupProbe.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds |
| startupProbe.timeoutSeconds | int | `1` | timeoutSeconds |
| strategy | object | {} | strategy type for deployment: Recreate or RollingUpdate |
| strategy.rollingUpdate | object | `{"maxSurge":1,"maxUnavailable":0}` | rollingUpdate |
| strategy.rollingUpdate.maxSurge | int | `1` | maxSurge |
| strategy.rollingUpdate.maxUnavailable | int | `0` | maxUnavailable |
| strategy.type | string | `"RollingUpdate"` | type |
| terminationGracePeriodSeconds | int | `30` | Termination grace period in seconds |
| tmpVolumeMount | object | `{"create":true,"mounts":[{"mountPath":"/tmp","name":"tmp"}]}` | Configure optional tmp volume to mount (Use instance storage) |
| tmpVolumeMount.mounts | list | `[{"mountPath":"/tmp","name":"tmp"}]` | Mounts to add to the tmp volume: (e.g. [{name: "tmp", mountPath: "/tmp"}]]) |
| tolerations | list | `[]` | Pod taints toleration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
