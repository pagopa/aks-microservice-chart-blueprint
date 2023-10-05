<!-- markdownlint-disable MD029  -->
# Migration guide

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
