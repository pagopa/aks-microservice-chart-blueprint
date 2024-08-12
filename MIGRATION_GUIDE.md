<!-- markdownlint-disable MD029  -->
# Migration guide

## (Breaking) from v5.x to v7.x

To use the workload identity and be able to load secrets directly from kv, you need to setup this two things.

### Service account linked to workload identity

```yaml
  serviceAccount:
    name: testit-workload-identity
```

> this service account was setuped before, and linked to the workload identity

### POD Identity

Was removed

### Workload ClientID (ex Pod Identity)

to be able to use the workload identity is mandatory to setup the client id associated to this one. To do so, you will have to pass as a parameter (DON'T COMMIT AS VALUE) as shown below

```yaml
azure:
  # -- (bool) Enable workload identity
  workloadIdentityEnabled: true
  # -- Azure Workload Identity Client ID (e.g. qwerty123-a1aa-1234-xyza-qwerty123)
  workloadIdentityClientId: ""
```

```yaml
--set microservice-chart.azure.workloadIdentityClientId="$CLIENT_ID"
```

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
