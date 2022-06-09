# Final result example

Here you can find an example of the template result

```yaml
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: release-name-microservice-chart
  namespace: idpay
  labels:
    helm.sh/chart: microservice-chart-1.17.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
data:
  APP: foo
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: release-name-microservice-chart
  namespace: idpay
  labels:
    helm.sh/chart: microservice-chart-1.17.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
      name: app-port-8080-svc
  selector:
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: release-name
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name-microservice-chart
  namespace: idpay
  labels:
    helm.sh/chart: microservice-chart-1.17.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: microservice-chart
      app.kubernetes.io/instance: release-name
  template:
    metadata:
      labels:
        aadpodidbinding: "idpay-pod-identity"
        app.kubernetes.io/name: microservice-chart
        app.kubernetes.io/instance: release-name
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
          image: "ghcr.io/pagopa/devops-java-springboot-color:0.6.0"
          imagePullPolicy: Always
          ports:
            - name: app-port-8080
              containerPort: 8080
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
            - name: aks-api-url
              valueFrom:
                secretKeyRef:
                  name: release-name-microservice-chart
                  key: cstar-d-weu-dev01-aks-apiserver-url
            - name: APP
              valueFrom:
                configMapKeyRef:
                  name: release-name-microservice-chart
                  key: APP
        - name: crt-mounter
          securityContext:
            allowPrivilegeEscalation: false
          image: alpine:latest
          command: ['tail', '-f', '/dev/null']
          resources:
            requests:
              memory: 16Mi
              cpu: 50m
            limits:
              memory: 32Mi
              cpu: 100m
          volumeMounts:
            - name: secrets-store-inline-crt
              mountPath: "/mnt/secrets-store-crt"
              readOnly: true
      volumes:
        - name: secrets-store-inline
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: release-name-microservice-chart
        ### ingress tls cert
        - name: secrets-store-inline-crt
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: dev01-idpay-internal-dev-cstar-pagopa-it-release-name-microservice-chart
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: release-name-microservice-chart
  namespace: idpay
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  ingressClassName: nginx
  rules:
    - host: dev01.idpay.internal.dev.cstar.pagopa.it
      http:
        paths:
          - backend:
              service:
                name: release-name-microservice-chart
                port:
                  number: 8080
            path: /idpay/testbar/(.*)
            pathType: ImplementationSpecific
  tls:
    - hosts: [dev01.idpay.internal.dev.cstar.pagopa.it]
      secretName: dev01-idpay-internal-dev-cstar-pagopa-it
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/secretproviderclass-ingress-tls.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: dev01-idpay-internal-dev-cstar-pagopa-it-release-name-microservice-chart
  namespace: idpay
spec:
  provider: azure
  secretObjects:
    - secretName: dev01-idpay-internal-dev-cstar-pagopa-it
      type: kubernetes.io/tls
      data:
        - key: tls.key
          objectName: dev01-idpay-internal-dev-cstar-pagopa-it
        - key: tls.crt
          objectName: dev01-idpay-internal-dev-cstar-pagopa-it
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-idpay-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: dev01-idpay-internal-dev-cstar-pagopa-it
          objectType: secret
          objectVersion: ""
---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/secretproviderclass-kv.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1

kind: SecretProviderClass
metadata:
  name: release-name-microservice-chart
  labels:
    helm.sh/chart: microservice-chart-1.17.0
    app.kubernetes.io/name: microservice-chart
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  provider: azure
  secretObjects:
    - secretName: release-name-microservice-chart
      type: Opaque
      data:
      - key: cstar-d-weu-dev01-aks-apiserver-url
        objectName: cstar-d-weu-dev01-aks-apiserver-url
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-idpay-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: cstar-d-weu-dev01-aks-apiserver-url
          objectType: secret
          objectVersion: ""
---

# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/autoscaling.yaml
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: release-name-microservice-chart
spec:
  podIdentity:
    provider: azure

---
# Source: devops-java-springboot-color-bar/charts/microservice-chart/templates/autoscaling.yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: release-name-microservice-chart
  labels:
   helm.sh/chart: microservice-chart-1.17.0
   app.kubernetes.io/name: microservice-chart
   app.kubernetes.io/instance: release-name
   app.kubernetes.io/version: "0.0.0"
   app.kubernetes.io/managed-by: Helm
spec:
  scaleTargetRef:
    name: release-name-microservice-chart
  minReplicaCount: 1
  maxReplicaCount: 2
  pollingInterval: 30
  cooldownPeriod: 300
  triggers:
    - type: azure-monitor
      authenticationRef:
        name: release-name-microservice-chart
      metadata:
        metricAggregationType: Count
        metricName: ServiceApiHit
        resourceGroupName: dvopla-d-sec-rg
        resourceURI: Microsoft.KeyVault/vaults/dvopla-d-neu-kv
        subscriptionId: ac17914c-79bf-48fa-831e-1359ef74c1d5
        targetValue: "30"
        tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
```
