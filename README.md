# K8s Microservice Template &middot; [![GitHub Release](https://img.shields.io/github/v/release/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/releases) [![GitHub Issues](https://img.shields.io/github/issues/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/issues) [![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)

The `aks-microservice-chart-blueprint` chart is the best way to release your
microservice into pagoPA K8s environment. It contains all the required
components to get started, and it has several architectural aspects already
configured.

Some of the key benefits of this chart are:

- Highly secure environment thanks to Secret Store CSI Provider;
- Ingress HTTPS connection;
- Improved scalability and reliability thanks to Keda;
- Automatic rollout to update pod environment thanks to Reloader;

## Installation

This is the official and recommended method to adopt this chart.

### Quick start

Create a `helm` folder inside your microservice project in which install the
Helm chart:

``` shell
mkdir helm && cd helm
```

Add Helm repo:

``` shell
helm repo add pagopa-microservice https://pagopa.github.io/aks-microservice-chart-blueprint
```

> If you had already added this repo earlier, run `helm repo update` to retrieve
  the latest versions of the packages.

Add a very basic configuration in `Chart.yaml`:

``` shell
cat <<EOF > Chart.yaml
apiVersion: v2
name: my-microservice
description: My microservice description
type: application
version: 1.0.0
appVersion: 1.0.0
dependencies:
- name: microservice-chart
  version: 1.0.0
  repository: "https://pagopa.github.io/aks-microservice-chart-blueprint"
EOF
```

Install the dependency:

``` shell
helm dep build
```

Create a `values-<env>.yaml` for each environment:

``` shell
touch values-dev.yaml values-uat.yaml values-prod.yaml
```

Override all values that you need, and form the root of your project install
the chart:

``` sh
helm upgrade -i -n mynamespace -f helm/values-dev.yaml mymicroservice helm
```

### Example

In the [`example`](example/) folder, you can find a working example. It
is an elementary version of an Azure Function App written in NodeJS.

It has three functions:

- `ready` that responds to the readiness probe;
- `live` that responds to the liveness probe;
- `secrets` that return a USER and a PASS taken respectively from a K8s ConfigMap
  and an Azure Key Vault.

To try it locally use either the [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash)
or [Docker](example/Dockerfile).

You can also find a [generic pipeline](example/.devops).

#### Static Application Security Testing

We strongly suggest performing SAST on your microservice Helm chart. You could
look at this [GitHub Action](.github/workflows/check_helm.yml).

### Configuration Properties

| Parameter | Description | Mandatory | Default |
| --- | --- | --- | --- |
| `image` |  | Yes | - |
| `image.repository` | Microservice image | Yes | - |
| `image.tag` | Microservice image tag | No | `v1.0.0` |
| `image.pullPolicy` | Microservice image pull policy | No | `Always` |
| `namespace` | Namespace in which deploy the microservice | Yes | - |
| `nameOverride` | Helm chart name override | No | `""` |
| `service` | | Yes | - |
| `service.type` | Service type | Yes | `ClusterIP` |
| `service.port` | Service port (used into `deployment.image.port`) | Yes | `80` |
| `livenessProbe` | | Yes | - |
| `livenessProbe.httpGet.path` | Live (health) path used by app | Yes | `/healthz/live` |
| `livenessProbe.httpGet.path` | live (health) port used by app | Yes | `80` |
| `livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness or readiness probes are initiated. | Yes | `60` |
| `livenessProbe.failureThreshold` | When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. | Yes | `6` |
| `livenessProbe.periodSeconds` | How often (in seconds) to perform the probe. | Yes | `10` |
| `readinessProbe` | | Yes | - |
| `readinessProbe.httpGet.path` | Ready (health) path used by app | Yes | `/healthz/live` |
| `readinessProbe.httpGet.port` | Ready (health) port used by app | Yes | `80` |
| `readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness or readiness probes are initiated. | Yes | `60` |
| `readinessProbe.failureThreshold` | When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. | Yes | `6` |
| `readinessProbe.periodSeconds` | How often (in seconds) to perform the probe. | Yes | `10` |
| `deployment` | | Yes | - |
| `deployment.create` | Create deployment descriptor | Yes | `1` |
| `fullnameOverride` | Helm chart fullname override | No | `""` |
| `ingress` | | No | - |
| `ingress.create` | Create an ingress | No | `false` |
| `ingress.host` | Host of the microservice | Yes | - |
| `ingress.path` | URL matching pattern | Yes | - |
| `ingress.pathType` | Path matching rule | No | `ImplementationSpecific` |
| `ingress.forceSslRedirect` | Redirect HTTP requests | No | `true` |
| `ingress.rewriteTarget` | Redirect HTTP requests rewrite rule | No | `/$1` |
| `serviceAccount` | | No | - |
| `serviceAccount.create` | Create a service account | Yes | `false` |
| `serviceAccount.annotations` | Service account annotations | No | `{}` |
| `serviceAccount.name` | Service account name | Yes | - |
| `podAnnotations` | Pod annotations | No | `{}` |
| `podSecurityContext` | | No | - |
| `podSecurityContext.seccompProfile` | | No | - |
| `podSecurityContext.seccompProfile.type` | Pod seccomp profile | No | `RuntimeDefault` |
| `securityContext` | Security Context | No | - |
| `securityContext.allowPrivilegeEscalation` | Disable pod privilege escalation | No | `false` |
| `resources` | | No | - |
| `resources.requests` | | No | - |
| `resources.requests.memory` | Pod minimum memory allocation | No | `"96Mi"` |
| `resources.requests.cpu` | Pod minimum cpu allocation | No | `"40m"` |
| `resources.limits` | | No | - |
| `resources.limits.memory` | Pod maximum memory allocation | No | `"128Mi"` |
| `resources.limits.cpu` | Pod maximum cpu allocation | No | `"150m"` |
| `autoscaling` | | No | - |
| `autoscaling.enable` | Enable autoscaling | No | `false` |
| `autoscaling.minReplica` | Autoscaling minimum replicas | No | `1` |
| `autoscaling.maxReplica` | Autoscaling maximum replicas | No | `1` |
| `autoscaling.pollingInterval` | Autoscaling event polling intervall | No | `30` seconds |
| `autoscaling.cooldownPeriod` | Autoscaling cooldown period | No | `300` seconds |
| `autoscaling.triggers` | Autoscaling triggers as per [Keda scalers](https://keda.sh/docs/2.6/scalers/) | Yes | - |
| `envConfig` | Map like `<env_name>: <value>` | No | - |
| `envSecret` | Map like `<env_name>: <key_vault_key>` | No | - |
| `secretProviderClass` |  | Yes | - |
| `secretProviderClass.create` | Create the secret provider class | Yes | `true` |
| `keyvault` | | Only if ingress.create or envSecret | - |
| `keyvault.name` | Azure Key Vault name from which retrieve secrets | Yes | - |
| `keyvault.tenantId` | Azure tenant id of the Key Vault | Yes | - |
| `nodeSelector` | K8s node selectors | No | - |
| `tolerations` | Pod taints toleration | No | - |
| `affinity` | Pod labels affinity | No | - |

### Upgrading

Change version of the dependency and run the update:

``` shell
cd helm && helm dep update .
```

## Advanced

For more information, visit the [complete documentation](https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/479658690/Microservice+template).

## Development

Clone the repository and run the setup script:

``` shell
git clone git@github.com:pagopa/aks-microservice-chart-blueprint.git
cd aks-microservice-chart-blueprint.git
sh /bin/setup
```

### Warning

Setup script installs a version manager tool that may introduce
compatibility issues in your environment. To prevent any potential
problems, you can install these dependencies manually or with your
favourite tool:

- NodeJS 14.17.3
- Helm 3.8.0

### Publish

The branch `gh-pages` contains the GitHub page content and all released charts.
To update the page content, use `bin/publish`.

## Known issues and limitations

- None.

## ToDo

- Should we remove some properties and hardcode them (like `image.pullPolicy`)?
