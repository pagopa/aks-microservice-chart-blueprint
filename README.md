# K8s Microservice Template &middot; [![GitHub Release](https://img.shields.io/github/v/release/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/releases) [![GitHub Issues](https://img.shields.io/github/issues/pagopa/aks-microservice-chart-blueprint?style=flat)](https://github.com/pagopa/aks-microservice-chart-blueprint/issues) [![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)

The `aks-microservice-chart-blueprint` chart is the best way to release your
microservice into PagoPA K8s environment. It contains all the required
components to get started, and it has several architectural aspects already
configured.

Some of the key benefits of this chart are:

- Highly secure environment thanks to Secret Store CSI Provider;
- Ingress HTTPS connection;
- Improved scalability and reliability thanks to **Keda**;
- Simpified way to setup secrets and configMaps

## Architecture

To see the entire architecture please see this page [architecture](docs/ARCHITECTURE.md)

## Changelog

see [CHANGELOG](CHANGELOG) to see the new features and the breking changes

## Pre requisites

- helm & kubernetes

### Static analysis

Install:

- <https://github.com/norwoodj/helm-docs>

## Installation

This is the official and recommended method to adopt this chart.

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
  version: 1.19.0
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

## Template/App mandatory resources and configuration

To work as expect this template must request:

App:

- has liveness and readiness endpoints
- you know which are the probes for your application, because are mandatory

Azure:

- TLS certificate are present into the kv (for ingress)
- Managed POD identity are created

K8s:

- Reloader of other tools that allow to restar the pod in case of some of the config map or secret are changed

## Final Result

Here you can find a result of the template [final result](docs/FINAL_RESULT_EXAMPLE.md)

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

## Yaml chart configuration properties (values.yaml)

see [README/Microservice Chart configuration](charts/microservice-chart/README.md) to understand how to use the values.

### Yaml: how to load values from externals config maps and use as ENV variable

Is possibile to load inside the deployment the values of an external config map, into ENV variables.

To do so, you can use this example snippet code:

```yaml
envConfigMapExternals:
  progressive-delivery-mock-one:
    PLAYER_INITIAL_LIVES_ENV: player_initial_lives
    UI_PROPERTIES_FILE_NAME_ENV: ui_properties_file_name
```

```yaml
envConfigMapExternals:
  <config map name>:
    <ENV variable name>: <key name inside the config map>
```

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

## Breaking changes

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


## Breaking changes

### v2.1.0

*fileShare*:

Now use azure storage file and mount in a pod to `/mnt/file-azure/{{ name }}/..` (Es. `/mnt/file-azure/certificates/java-cacerts`)
(Attention key vault must contains two keys, `azurestorageaccountname` and `azurestorageaccountkey`. See https://learn.microsoft.com/en-us/azure/aks/azure-files-volume and storage file share named as fileShare.folders.name)
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
```
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
