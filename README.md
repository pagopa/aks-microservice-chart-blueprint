# K8s Microservice Template &middot; [![GitHub Release](https://img.shields.io/github/v/release/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/releases) [![GitHub Issues](https://img.shields.io/github/issues/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/issues) [![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)

The `aks-microservice-chart-blueprint` chart is the best way to release your
microservice into PagoPA K8s environment. It contains all the required
components to get started, and it has several architectural aspects already
configured.

Some of the key benefits of this chart are:

- Highly secure environment thanks to `Workload Identity` and secrets load by SecretProviderClass;
- Ingress HTTPS connection;
- Improved scalability and reliability thanks to **Keda**;
- Simpified way to setup secrets and configMaps

> ⚠️ The 7.x version drop compatibility to podIdentity and use workload identity

## Architecture

To see the entire architecture please see this page [architecture](docs/ARCHITECTURE.md)

## Changelog

see [CHANGELOG](CHANGELOG) to see the new features and the breking changes

## Migration guide

please see this page about how to manage a migration for one version to another [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

## Pre requisites

- helm & kubernetes

## Installation

This is the official and recommended method to adopt this chart.

## LTS support

To support the various teams we have decided that the 2.x releases and the 5.x releases will have LTS support.

By LTS we mean support aimed at solving bugs or blocking problems, but not new features for which it will be necessary to upgrade the version

These are the supported LTS releases and until when:

- `2.x`: March 2024
- `5.x`: July 2024

### Quick start

Create a `helm` folder inside your microservice project in which install the
Helm chart:

```shell
mkdir helm && cd helm
```

Add Helm repo:

```shell
helm repo add pagopa-microservice https://pagopa.github.io/aks-microservice-chart-blueprint
```

> If you had already added this repo earlier, run `helm repo update` to retrieve
> the latest versions of the packages.

Add a very basic configuration in `Chart.yaml`:

```shell
cat <<EOF > Chart.yaml
apiVersion: v2
name: my-microservice
description: My microservice description
type: application
version: 1.0.0
appVersion: 1.0.0
dependencies:
- name: microservice-chart
  version: 7.1.1
  repository: "https://pagopa.github.io/aks-microservice-chart-blueprint"
EOF
```

Install the dependency:

```shell
helm dep build
```

Create a `values-<env>.yaml` for each environment:

```shell
touch values-dev.yaml values-uat.yaml values-prod.yaml
```

Override all values that you need, and form the root of your project install
the chart:

```sh
helm upgrade -i -n <namespace name> -f <file with values> <name of the helm chart> <chart folder>

helm upgrade -i -n mynamespace -f helm/values-dev.yaml mymicroservice helm
```

### Upgrading

Change version of the dependency and run the update:

```shell
cd helm && helm dep update .
```

## 🧭 Template/App mandatory resources and configuration

To work as expect this template must request:

App:

- has liveness and readiness endpoints
- you know which are the probes for your application, because are mandatory

Azure:

- TLS certificate are present into the kv (for ingress)
- Azure: Managed POD identity was created

K8s:

- Reloader of other tools that allow to restar the pod in case of some of the config map or secret are changed

## 🔨 Functionality & Values keys/Yaml chart configuration properties (values.yaml)

see [README/Microservice Chart configuration](charts/microservice-chart/README.md) to understand how to use the values.

### `Workload Identity`

To use the workload identity and be able to load secrets directly from kv, follow the [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md).

### `forceRedeploy`: allow to re-create pod every time an helm release is launched

If you want to force the re-deploy of pods without changing values, you can use this value

```yaml
microservice-chart:
  deployment:
    forceRedeploy: true
```

this can be very usefull when you need to updated the values of a config map or secret

  ⚠️ ArgoCD: this field can be a problem with argocd because it change one label to force the re-deploy and argocd can think that is an `out of sync`

### `envConfig`: load values in an internal configmap with the same name of the release

Is possible to load env variables inside the pod, with the creation of a configmap called as the release name

```yaml
  envConfig:
    <env variable name>: <value>

  envConfig:
    APP: foo
    MY_APP_COLOR: "green"
```

### `envSecret`: load secrets from keyvault and add as env variables

```yaml
  envSecret:
    <env variable name>: <secret name inside kv>

  envSecret:
    MY_MANDATORY_SECRET: dvopla-d-neu-dev01-aks-apiserver-url

  # configuration
  keyvault:
    name: "dvopla-d-blueprint-kv"
    tenantId: "7788edaf-0346-4068-9d79-c868aed15b3d"
```

### `configMapFromFile`: load file defined inside internal value configMap and mount in a pod as file

this property allows to load from a configMap (denfined inside the values) a file, and mount into pod as file.

the default file path is `/mnt/file-config/<file name>`

```yaml
  configMapFromFile:
    <key and filename>: <value>

  configMapFromFile:
    logback.xml: |-
      <?xml version="1.0" encoding="UTF-8"?>
      <configuration scan="true" scanPeriod="30 seconds">
          <root level="INFO">
              <appender-ref ref="CONSOLE_APPENDER_ASYNC" />
          </root>
      </configuration>
```

### `externalConfigMapValues`: load values from others configmaps and load as env variables

> usefull when you have a shared configmap and you want to load his values.

- `ENV VARIABLE NAME`: how the variable must be named inside pod, very usefull for example for spring that have some problems with variables that have hippen in the name
- `key inside config maps`: which key to load inside the env variable name

```yaml

  externalConfigMapValues:
    <configmap name>:
      <ENV VARIABLE NAME>: <key inside config maps>

  externalConfigMapValues:
    external-configmap-values-complete-1:
      DATABASE_DB_NANE: database-db-name

    external-configmap-values-complete-2:
      PLAYER-INITIAL-LIVES: player-initial-lives
      UI_PROPERTIES_FILE_NAME: ui-properties-file-name
```

### `externalConfigMapFiles`: load files values from others configmaps and load inside pod as files

> usefull when you have a shared config map with files, and you want to load inside your pod

All the files are created inside the path: `/mnt/file-config-external/<config-map-name>/`

```yaml

  externalConfigMapFiles:
    create: true
    configMaps:
      - name: <config map name>
        key: <config map key>
        mountPath: <complete mount path with file name> #(Optional)

  externalConfigMapFiles:
    create: true
    configMaps:
      - name: external-configmap-files
        key: game.properties
        mountPath: "/config/game.properties"
      - name: external-configmap-files
        key: user-interface.xml
```

### `tmpVolumeMount`: allow to create local folders with write permissions

This volume is create inside the AKS default disk, please don't use to store data, but use only as a tmp folder

```yaml
  tmpVolumeMount:
    create: true
    mounts:
      - name: tmp
        mountPath: /tmp
      - name: logs
        mountPath: /logs
```

### `persistentVolumeClaimsMounts`: allow to create local folders with persistent volumes (pv) and write permissions

This volume use a pvc to persist the data

```yaml
  persistentVolumeClaimsMounts:
    create: true
    mounts:
      - name: pdf-pvc
        mountPath: /pdf
        pvcName: blueprint-hdd-pvc
```

### `PodDisruptionBudget`

```yaml
  podDisruptionBudget:
    create: true
    minAvailable: 0
```

### `Affinity/HA (nodeAffinity & podAntiAffinity)`

This snippet allows to install pod into different nodes, created in different AZ's

```yaml
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: node_type
            operator: In
            values:
            - user
        - matchExpressions:
          - key: elastic
            operator: In
            values:
            - eck
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              aadpodidbinding: blueprint-pod-identity
          namespaces: ["blueprint"]
          topologyKey: topology.kubernetes.io/zone
```

This code snippet in AKS forces the pods not to be all in the same node but to distribute themselves as much as possible in nodes created in different AZs, this is not blocking but only a desire, in fact if it is not possible the pods will still be deployed inside a node

```yaml
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              aadpodidbinding: blueprint-pod-identity
          namespaces: ["blueprint"]
          topologyKey: topology.kubernetes.io/zone
```

### Tolerations

```yaml
  tolerations:
    - effect: "NoSchedule"
      key: "paymentWalletOnly"
      operator: "Equal"
      value: "true"
```

### Probe: Liveness, Readiness, Starup

#### `livenessProbe`

```yaml
  livenessProbe:
    httpGet:
      path: /status/live
      port: 8080
    initialDelaySeconds: 10
    failureThreshold: 6
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    terminationGracePeriodSeconds: 30
```

#### `readinessProbe`

```yaml
  readinessProbe:
    httpGet:
      path: /status/ready
      port: 8080
    initialDelaySeconds: 30
    failureThreshold: 6
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
```

#### `startupProbe`

```yaml
  startupProbe:
    create: true
    handlerType: "exec"
    exec:
      command: ["/bin/sh", "-c", '[ -d "/csv" ]']
    httpGet:
      path: /status/ready
      port: 8080
    initialDelaySeconds: 1
    failureThreshold: 6
    periodSeconds: 10
    timeoutSeconds: 10
    successThreshold: 1
    terminationGracePeriodSeconds: 30
```

### `canary`: example with canary

```yaml
...
  envConfig:
    TO_OVERWRITE: "original-value"
    COMMON: "same"
  envSecret:
    SEC_COMMON: 'common-secret'
    SEC_TO_OVERWRITE: 'value-to-overwrite'
  keyvault:
    name: "pagopa-kv"
    tenantId: "123123123123123"


  canaryDelivery:
   ...
    envConfig:
      TO_OVERWRITE: "over-witten"
      NEW_ITEM: "new item"
    envSecret:
      SEC_NEW_ITEM: 'new-secret'
      SEC_TO_OVERWRITE: 'new-value'
```

In a Canary deployment, the configurations from the `envConfig` of the stable version are merged with its own configuration.
It is the same for the `envSecret`.

You can add new variables to the canary (see `SEC_NEW_ITEM`) or overwrite values of the stable version (see `SEC_TO_OVERWRITE`).

### `Postman tests`

> ℹ️ this section is not directly used by aks blueprint but is a place holder for release pipelines. It was inserted here to centralize the information and its documentation

In order to use postman tests you need to configure your yaml as follows:

```yaml
postman-test:
  run: true
  repoName: arc-be
  dir: postman
  collectionName: "pagopa-arc-E2E.postman_collection.json"
  envVariablesFile: "arc_DEV.postman_environment.json" #inside azdo secure files
```

### `Service Monitors`

The **Service Monitor** allows you to configure and send metrics from your 
application to **Prometheus**, both locally hosted and managed, 
using this new version of the configuration module. This feature is essential 
for monitoring application health and gaining real-time insights into its performance.

```yaml
serviceMonitor:
  create: true
  endpoints:
    - interval: 10s
      targetPort: 9092
      path: /
    - interval: 10s
      targetPort: 9091
      path: /metrics
  promethuesManaged: true
```

1. `create: true`
Enables automatic creation of a dedicated Service Monitor for Prometheus.
2. **`endpoints`**
A list of endpoints defined to allow Prometheus to scrape metrics from the monitoring targets.
    - **`interval`**: Specifies how frequently Prometheus should scrape metrics from the endpoint (e.g., every 10 seconds).
    - **`targetPort`**: Sets the port Prometheus should connect to in order to access metrics.
    - **`path`**: Defines the HTTP path where metrics are exposed — e.g., `/` for general information and `/metrics` for specific monitoring data.
3. `promethuesManaged: true`
Enables integration with a **managed Prometheus system**. This option is useful when using Prometheus as a managed service (e.g., in cloud environments), allowing the Service Monitor to automatically adjust to such setups.

### More info

See [README/Postman tests](charts/microservice-chart/README.md) to understand how to use the values.

## Advanced

For more information, visit the [complete documentation](https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/479658690/Microservice+template).

## Development

Clone the repository and run the setup script:

```shell
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

## Breaking changes

### v2.4.0

*livenessProbe*
*readinessProbe*
Now chose if enable tcpSocket ot httpGet

```yaml
  livenessProbe:
    handlerType: httpGet <httpGet|tcpSocket>
  readinessProbe:
    handlerType: httpGet <httpGet|tcpSocket>
```

### v2.3.0

*fileConfigExternals*:

Now create file from external config map

```yaml
  fileConfigExternals:
    create: true
    configMaps:
      - name: nodo-cacerts
        key: cacerts
```

### v2.2.0

*serviceMonitor*:

Now create service monitor for send metrics to prometheus

```yaml
  serviceMonitor:
    create: true
    endpoints:
      - interval: 10s #micrometer
        targetPort: 9092
        path: /
      - interval: 10s #cinnamon
        targetPort: 9091
        path: /metrics
```

### v2.1.0

*fileShare*:

Now use azure storage file and mount in a pod to `/mnt/file-azure/{{ name }}/..` (Es. `/mnt/file-azure/certificates/java-cacerts`)
(Attention key vault must contains two keys, `azurestorageaccountname` and `azurestorageaccountkey`. See <https://learn.microsoft.com/en-us/azure/aks/azure-files-volume> and storage file share named as fileShare.folders.name)

```yaml
  fileShare:
    create: true
    folders:
      - name: certificates
        readOnly: false
        mountOptions: "dir_mode=0777,file_mode=0777,cache=strict,actimeo=30"
      - name: firmatore
        readOnly: false
        mountOptions: "dir_mode=0777,file_mode=0777,cache=strict,actimeo=30"
```

*envFieldRef*:

Now map environment from a Pod Information

```yaml
  envFieldRef:
    NAMESPACE: "metadata.namespace"
    SERVICE_HTTP_HOST: "status.podIP"
```

*fileConfig*:

Now load file inside configMap and mount in a pod to `/mnt/file-config/..` (Es. `/mnt/file-config/logback.xml`)

```yaml
  fileConfig:
    logback.xml: |-
      <?xml version="1.0" encoding="UTF-8"?>
      <configuration scan="true" scanPeriod="30 seconds">

          <property name="CONSOLE_PATTERN" value="%d %-5level [sid:%X{sessionId}] [can:%X{idCanale}] [sta:%X{idStazione}] [%logger] - %msg [%X{akkaSource}]%n"/>

          <appender name="CONSOLE_APPENDER" class="ch.qos.logback.core.ConsoleAppender">
              <encoder>
                  <pattern>${CONSOLE_PATTERN}</pattern>
                  <charset>utf8</charset>
              </encoder>
          </appender>

          <root level="INFO">
              <appender-ref ref="CONSOLE_APPENDER_ASYNC" />
          </root>
      </configuration>
```

Or use commenad helm for load file while use a subchart

```sh
--set-file 'microservice-chart.fileConfig.logback\.xml'=helm/config/dev/logback.xml
```

### v2.0.0

*service*:

Now use a list of ports and not more a single value

```yaml
  service:
    create: true
    type: ClusterIP
    ports:
    - 8080
    - 4000
```

*ingress*: now you need to specify the service port

```yaml
  ingress:
    create: true
    host: "dev01.rtd.internal.dev.cstar.pagopa.it"
    path: /rtd/progressive-delivery/(.*)
    servicePort: 8080
```

## Static analysis

Install:

- <https://github.com/norwoodj/helm-docs>

## Examples

In the [`example`](example/) folder, you can find a working examples.

### Progessive-delivery

Use spring-boot-app-color to test canary deployment

### Azure function App

It is an elementary version of an Azure Function App written in NodeJS.

It has three functions:

- `ready` that responds to the readiness probe;
- `live` that responds to the liveness probe;
- `secrets` that return a USER and a PASS taken respectively from a K8s ConfigMap
  and an Azure Key Vault.

To try it locally use either the [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash)
or [Docker](example/Dockerfile).

You can also find a [generic pipeline](example/.devops).

### SpringBoot (Java) web app colors

<https://github.com/pagopa/devops-java-springboot-color>

there are two folders called:

- spring-boot-app-bar
- spring-boot-app-foo

This are only a helm chart that install a simple web application written in java springboot.

This can be usefull to check how works aks with two applications

### Static Application Security Testing

We strongly suggest performing SAST on your microservice Helm chart. You could
look at this [GitHub Action](.github/workflows/check_helm.yml).
