# Architecture

![Architecture](arch/template-arch.drawio.png)

## Helm/Kubernetes Objects

### Deployment

#### PODs

The deployment contains two pods:

1. **app pod**: dedicated to app

1. **alpine/crt-mounter**: util pod used to load the tls certificate for ingress from kv. This was mandatory because we need a way to load the tls cerficate

#### Secrets

The deployment use SecretProviderClass (connected to azure via SecretStoreCSIPRovider) to load secrets.
In this case the secrets are loaded from the KV, and converted to secret and ENVIROMENT variables that are used by the pods

```yaml
  envSecret:
    aks-api-url: cstar-d-weu-dev01-aks-apiserver-url

```

#### Config Maps

The config maps are created automatically from the values definied inside the helm template

```yaml
  envConfig:
    APP: foo
```

## Secret provider class

The secret provider class allows to define:

* which key vault to use
* which kind of secret or certificate to load
* setup azure information to contact the key vault

All the operations are done via the Managed Pod Identity that allows the connection

### Documentation

<https://secrets-store-csi-driver.sigs.k8s.io/concepts.html#secretproviderclass>
<https://secrets-store-csi-driver.sigs.k8s.io/concepts.html>

## Service

Service as usual

## NGNIX Ingress

The ngnix ingress allow to configure a host (with the tls certificate that must be present into the kv) and the path to use for that ingress.

Multiple ingress can be created with the same host but mandatory with different paths

## Keda scale object

With Keda is possibile to autoscale the pods (keda wraps the HPA) and allow us to choose more business metrics like: request, status from objecs, ecc.. and not only cpu and ram.

With Keda and the defined Managed pod identity is possible to connect to logs analytics to load data directly from azure. And avoid to create a prometheus.
