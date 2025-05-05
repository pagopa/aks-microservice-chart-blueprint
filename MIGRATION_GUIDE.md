<!-- markdownlint-disable MD029  -->
# Migration guide

## migration to v7.7

> This version fixes KEDA helm managing, regarding the helm manifest to support delete.

To migrate to this version, it is crucial to label and annotate our ScaledObject (if it exists) as follows:

```bash
kubectl label scaledobject <name> app.kubernetes.io/instance=<release-name> --overwrite
kubectl label scaledobject <name> app.kubernetes.io/managed-by=Helm --overwrite
kubectl annotate scaledobject <name> meta.helm.sh/release-name=<release-name> --overwrite
kubectl annotate scaledobject <name> meta.helm.sh/release-namespace=<namespace> --overwrite
```

Where **name** is the name of the existing ScaledObject and **release-name** the name of helm release name.

### Example of migration

Here is an example.

```bash
kubectl label scaledobject v7-java-helm-complete-test-foo-microservice-chart app.kubernetes.io/instance=v7-java-helm-complete-test-foo --overwrite -n testit
kubectl label scaledobject v7-java-helm-complete-test-foo-microservice-chart app.kubernetes.io/managed-by=Helm --overwrite -n testit
kubectl annotate scaledobject v7-java-helm-complete-test-foo-microservice-chart meta.helm.sh/release-name=v7-java-helm-complete-test-foo --overwrite -n testit
kubectl annotate scaledobject v7-java-helm-complete-test-foo-microservice-chart meta.helm.sh/release-namespace=testit --overwrite -n testit
```

After labeling and annotating the ScaledObject run again the deployment and check with this useful command.
```bash
helm get manifest <release-name> -n <namespace> | grep ScaledObject -A 10
```

**They must return the rows with the ScaledObject definition, otherwise 
the import was not done, and you have to redo the annotations and labeling.** 

## (Breaking) from v5.x to v7.x

> This version drop the support for the POD IDENTITY

To use the workload identity and be able to load secrets directly from kv, you need to setup this two things.

### Service account name linked to workload identity

Add this yaml tag with the service account info

```yaml
  microservice-chart:
    serviceAccount:
      name: testit-workload-identity
```

> this service account was setuped before (infra), and linked to the workload identity

### Workload Identity ClientID (aka: User managed identity clientID)

To be able to use the workload identity is mandatory to setup the client id associated to this one.
To do so, you will have to pass as a parameter as shown below

```yaml
microservice-chart:
  azure:
    # -- Azure Workload Identity Client ID (e.g. qwerty123-a1aa-1234-xyza-qwerty123)
    workloadIdentityClientId: qwerty123-a1aa-1234-xyza-qwerty123
```

or you can override with an helm parameter in this way bellow, if you don't want to commit this value

```yaml
--set microservice-chart.azure.workloadIdentityClientId="$CLIENT_ID"
```

> the client id is not secret, this is why we can put into git

## from v2.x to v5.3+

the guaranteed version of 5.x is 5.3 which contains all the fixes necessary to minimize the inconvenience of a migration

### Default behaviors in v5

1. `securityContext` now has the following configuration to allow you to comply with the minimum security configurations of the pods

  ```yaml
  securityContext:
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - all
  ```

### Parameters changed

1. `tmpVolumeMount` -> (formelly `tmpFolder`) If you need a temp folder for example for logs or temp data use this properties `tmpVolumeMount`. In this way you can create a tmp folder without disabling `readOnlyRootFilesystem`.

  ```yaml
  tmpVolumeMount:
    create: true
    mounts:
      - name: tmp
        mountPath: /tmp
      - name: logs
        mountPath: /app/logs
  ```

2. `externalConfigMapFiles` -> (formelly `fileConfigExternals`) see readme

3. `configMapFromFile` -> (formelly `fileConfig`) see readme

4. `externalConfigMapValues` -> (formelly `envConfigMapExternals`) see readme
