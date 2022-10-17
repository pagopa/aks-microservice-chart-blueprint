# Final result example

Here you can find an example of the template result

```yaml
---
# Source: progressive-delivery/charts/microservice-chart/templates/beta-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: beta-progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "true"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
data:
  MY_APP_COLOR: blue
  progressive-delivery: ok
---
# Source: progressive-delivery/charts/microservice-chart/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "false"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
data:
  APP: foo
  MY_APP_COLOR: green
---
# Source: progressive-delivery/templates/configmaps.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: progressive-delivery-mock-one
  namespace: 
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true
---
# Source: progressive-delivery/templates/configmaps.yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: progressive-delivery-example-two
  namespace: 
data:
  # Configuration values can be set as key-value properties
  database: mongodb
  database_uri: mongodb://localhost:27017

  # Or set as complete file contents (even JSON!)
  keys: |
    image.public.key=771
    rsa.public.key=42
---
# Source: progressive-delivery/charts/microservice-chart/templates/beta-services.yaml
apiVersion: v1
kind: Service
metadata:
  name: beta-progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "true"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - name: beta-app-port-8080-svc
      port: 8080
      targetPort: 8080
      protocol: TCP
    - name: beta-app-port-4000-svc
      port: 4000
      targetPort: 4000
      protocol: TCP
  selector:
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "true"
---
# Source: progressive-delivery/charts/microservice-chart/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "false"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - name: app-port-8080-svc
      port: 8080
      targetPort: 8080
      protocol: TCP
    - name: app-port-4000-svc
      port: 4000
      targetPort: 4000
      protocol: TCP
  selector:
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "false"
---
# Source: progressive-delivery/charts/microservice-chart/templates/beta-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: beta-progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "true"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: microservice-chart
      app.kubernetes.io/instance: progressive-delivery
      canaryDelivery: "true"
  template:
    metadata:
      labels:
        aadpodidbinding: "rtd-pod-identity"
        app.kubernetes.io/name: microservice-chart
        app.kubernetes.io/instance: progressive-delivery
        canaryDelivery: "true"
    spec:
      automountServiceAccountToken: false
      serviceAccountName: default
      securityContext:
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: microservice-chart
          securityContext:
            allowPrivilegeEscalation: false
          image: "ghcr.io/pagopa/devops-java-springboot-color:0.7.1"
          imagePullPolicy: Always
          ports:
            - name: app-port-8080
              containerPort: 8080
              protocol: TCP
            - name: app-port-4000
              containerPort: 4000
              protocol: TCP
          livenessProbe:
            failureThreshold: 6
            httpGet:
              path: /status/live
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
          readinessProbe:
            failureThreshold: 6
            httpGet:
              path: /status/ready
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
          resources:
            limits:
              cpu: 150m
              memory: 256Mi
            requests:
              cpu: 40m
              memory: 256Mi
          volumeMounts:
            - name: secrets-store-inline
              mountPath: "/mnt/secrets-store"
              readOnly: true
          volumeMounts:
            - name: beta-secrets-store-inline
              mountPath: "/mnt/beta-secrets-store"
              readOnly: true
          env:
            # secrets from deployment
            - name: aks-api-url
              valueFrom:
                secretKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: cstar-d-weu-dev01-aks-apiserver-url
            # secrets from canary
            - name: aks-api-url
              valueFrom:
                secretKeyRef:
                  name: beta-progressive-delivery-microservice-chart
                  key: cstar-d-weu-dev01-aks-apiserver-url
            # config map values from main deployment
            - name: APP
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: APP
            - name: MY_APP_COLOR
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: MY_APP_COLOR
            # config map values from canary
            - name: MY_APP_COLOR
              valueFrom:
                configMapKeyRef:
                  name: beta-progressive-delivery-microservice-chart
                  key: MY_APP_COLOR
            - name: progressive-delivery
              valueFrom:
                configMapKeyRef:
                  name: beta-progressive-delivery-microservice-chart
                  key: progressive-delivery
            #external configmap values
            - name: PLAYER_INITIAL_LIVES_ENV
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-mock-one
                  key: player_initial_lives
            - name: UI_PROPERTIES_FILE_NAME_ENV
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-mock-one
                  key: ui_properties_file_name
      volumes:
        - name: beta-secrets-store-inline
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: beta-progressive-delivery-microservice-chart
        - name: secrets-store-inline
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: progressive-delivery-microservice-chart
---
# Source: progressive-delivery/charts/microservice-chart/templates/deployments.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: progressive-delivery-microservice-chart
  namespace: rtd
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "false"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: microservice-chart
      app.kubernetes.io/instance: progressive-delivery
      canaryDelivery: "false"
  template:
    metadata:
      labels:
        aadpodidbinding: "rtd-pod-identity"
        app.kubernetes.io/name: microservice-chart
        app.kubernetes.io/instance: progressive-delivery
        canaryDelivery: "false"
    spec:
      automountServiceAccountToken: false
      serviceAccountName: default
      securityContext:
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: microservice-chart
          securityContext:
            allowPrivilegeEscalation: false
          image: "ghcr.io/pagopa/devops-java-springboot-color:0.7.1"
          imagePullPolicy: Always
          ports:
            - name: app-port-8080
              containerPort: 8080
              protocol: TCP
            - name: app-port-4000
              containerPort: 4000
              protocol: TCP
          livenessProbe:
            failureThreshold: 6
            httpGet:
              path: /status/live
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
          readinessProbe:
            failureThreshold: 6
            httpGet:
              path: /status/ready
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
          resources:
            limits:
              cpu: 150m
              memory: 256Mi
            requests:
              cpu: 40m
              memory: 256Mi
          volumeMounts:
            - name: secrets-store-inline
              mountPath: "/mnt/secrets-store"
              readOnly: true
          env:
            #secrets
            - name: aks-api-url
              valueFrom:
                secretKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: cstar-d-weu-dev01-aks-apiserver-url
            #configmap
            - name: APP
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: APP
            - name: MY_APP_COLOR
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-microservice-chart
                  key: MY_APP_COLOR
            #external configmap values
            - name: PLAYER_INITIAL_LIVES_ENV
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-mock-one
                  key: player_initial_lives
            - name: UI_PROPERTIES_FILE_NAME_ENV
              valueFrom:
                configMapKeyRef:
                  name: progressive-delivery-mock-one
                  key: ui_properties_file_name
      volumes:
        - name: secrets-store-inline
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: progressive-delivery-microservice-chart
---
# Source: progressive-delivery/charts/microservice-chart/templates/beta-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: beta-progressive-delivery-microservice-chart
  namespace: rtd
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 1m
    nginx.ingress.kubernetes.io/satisfy: any
spec:
  ingressClassName: nginx
  rules:
    - host: dev01.rtd.internal.dev.cstar.pagopa.it
      http:
        paths:
          - backend:
              service:
                name: beta-progressive-delivery-microservice-chart
                port:
                  number: 8080
            pathType: ImplementationSpecific
            path: /beta/rtd/progressive-delivery/(.*)
  tls:
    - hosts: [dev01.rtd.internal.dev.cstar.pagopa.it]
      secretName: dev01-rtd-internal-dev-cstar-pagopa-it
---
# Source: progressive-delivery/charts/microservice-chart/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: progressive-delivery-microservice-chart
  namespace: rtd
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 1m
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/satisfy: any
spec:
  ingressClassName: nginx
  rules:
    - host: dev01.rtd.internal.dev.cstar.pagopa.it
      http:
        paths:
          - backend:
              service:
                name: progressive-delivery-microservice-chart
                port:
                  number: 8080
            path: /rtd/progressive-delivery/(.*)
            pathType: ImplementationSpecific
  tls:
    - hosts: [dev01.rtd.internal.dev.cstar.pagopa.it]
      secretName: dev01-rtd-internal-dev-cstar-pagopa-it
---
# Source: progressive-delivery/charts/microservice-chart/templates/beta-secretproviderclass-kv.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: beta-progressive-delivery-microservice-chart
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "true"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  provider: azure
  secretObjects:
    - secretName: beta-progressive-delivery-microservice-chart
      type: Opaque
      data:
      - key: cstar-d-weu-dev01-aks-apiserver-url
        objectName: cstar-d-weu-dev01-aks-apiserver-url
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-rtd-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: cstar-d-weu-dev01-aks-apiserver-url
          objectType: secret
          objectVersion: ""
---
# Source: progressive-delivery/charts/microservice-chart/templates/secretproviderclass-kv.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: progressive-delivery-microservice-chart
  labels:
    helm.sh/chart: microservice-chart-2.0.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: progressive-delivery
    canaryDelivery: "false"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  provider: azure
  secretObjects:
    - secretName: progressive-delivery-microservice-chart
      type: Opaque
      data:
      - key: cstar-d-weu-dev01-aks-apiserver-url
        objectName: cstar-d-weu-dev01-aks-apiserver-url
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-rtd-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: cstar-d-weu-dev01-aks-apiserver-url
          objectType: secret
          objectVersion: ""
```
