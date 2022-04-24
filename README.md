[![GitHub Release](https://img.shields.io/github/v/release/pagopa/template-microservizio-k8s?style=flat)](https://github.com/pagopa/template-microservizio-k8s/releases)
[![GitHub Issues](https://img.shields.io/github/issues/pagopa/template-microservizio-k8s?style=flat)](https://github.com/pagopa/template-microservizio-k8s/issues)
[![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)

# K8s Microservice Template

The `template-microservizio-k8s` chart is the best way to release your
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
$ mkdir helm && cd helm
```

Add Helm repo:

``` shell
helm repo add pagopa-microservice https://pagopa.github.io/template-microservizio-k8s
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.


Add a very basic configuration in `Chart.yaml`:

``` shell
$ cat <<EOF > Chart.yaml
apiVersion: v2
name: my-microservice
description: My microservice description
type: application
version: 1.0.0
appVersion: 1.0.0
dependencies:
- name: microservice-chart
  version: 1.0.0
  repository: "https://pagopa.github.io/template-microservizio-k8s"
EOF
```

Install the dependency:

``` shell
$ helm dep build
```

Create a `values-<env>.yaml` for each environment:

``` shell
$ touch values-dev.yaml values-uat.yaml values-prod.yaml
```

Override all values that you need, and form the root of your project install
the chart:

``` sh
$ helm upgrade -i -n mynamespace -f helm/values-dev.yaml mymicroservice helm
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

| Parameter | Description | Default |
| --- | --- | --- |
| `image.repository` | Microservice image | `""` |
| `image.tag` | Microservice image tag | `v1.0.0` |
| `image.pullPolicy` | Microservice image pull policy | `Always` |
| `namespace` | Namespace in which deploy the microservice | `""` |
| `nameOverride` | Helm chart name override | `""` |
| `fullnameOverride` | Helm chart fullname override | `""` |
| `serviceAccount.create` | Create a service account | `false` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |
| `podAnnotations` | Pod annotations | `{}` |
| `podSecurityContext` | Pod security context | - |
| `podSecurityContext.seccompProfile.type` | Pod seccomp profile | `RuntimeDefault` |
| `securityContext` | Security Context | - |
| `securityContext.allowPrivilegeEscalation` | Disable pod privilege escalation | `false` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `resources.requests.memory` | Pod minimum memory allocation | `"96Mi"` |
| `resources.requests.cpu` | Pod minimum cpu allocation | `"40m"` |
| `resources.limits.memory` | Pod maximum memory allocation | `"128Mi"` |
| `resources.limits.cpu` | Pod maximum cpu allocation | `"150m"` |
| `autoscaling.minReplica` | Autoscaling minimum replicas | `1` |
| `autoscaling.maxReplica` | Autoscaling maximum replicas | `1` |
| `autoscaling.pollingInterval` | Autoscaling event polling intervall | `30` seconds |
| `autoscaling.cooldownPeriod` | Autoscaling cooldown period | `300` seconds |
| `autoscaling.triggers` | Autoscaling triggers as per [Keda scalers](https://keda.sh/docs/2.6/scalers/) | `[]` |
| `envConfig` | Map like `<env_name>: <value>` | `{}` |
| `envSecret` | Map like `<env_name>: <key_vault_key>` | `{}` |
| `keyvault.name` | Azure Key Vault name from which retrieve secrets | `""` |
| `keyvault.tenantId` | Azure tenant id of the Key Vault | `""` |
| `nodeSelector` | K8s node selectors | `{}` |
| `tolerations` | Pod taints toleration | `[]` |
| `affinity` | Pod labels affinity | `{}` |

### Upgrading

Change version of the dependency and run the update:

``` shell
$ cd helm && helm dep update .
```

## Advanced

For more information, visit the [complete documentation](https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/479658690/Microservice+template).

## Development

Clone the repository and run the setup script:

``` shell
$ git clone git@github.com:pagopa/template-microservizio-k8s.git
$ cd template-microservizio-k8s.git
$ ./bin/setup
```

#### Warning

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

