{{/*
Expand the name of the chart.
*/}}
{{- define "microservice-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
When critical is false, appends "-non-core" suffix to resource names.
*/}}
{{- define "microservice-chart.fullname" -}}
{{- $fullname := "" }}
{{- if .Values.fullnameOverride }}
{{- $fullname = .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- $fullname = .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $fullname = printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- if not .Values.critical }}
{{- $fullname = printf "%s-non-core" $fullname | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- $fullname }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "microservice-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name (.Values.image.tag | default .Chart.Version) | replace "@sha256:" "_" | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "microservice-chart.labels" -}}
helm.sh/chart: {{ include "microservice-chart.chart" . }}
helm.sh/blueprint-version: {{ .Chart.Version }}
{{ include "microservice-chart.selectorLabels" . }}
{{- include "microservice-chart.extraLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Extra labels
*/}}
{{- define "microservice-chart.extraLabels" -}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ (.Values.image.tag | default .Chart.AppVersion) | replace "@sha256:" "_" | trunc 63 | quote }}
{{- end }}
{{- if .Values.azure.workloadIdentityEnabled }}
azure.workload.identity/use: "{{ .Values.azure.workloadIdentityEnabled }}"
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "microservice-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microservice-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
canaryDelivery: "false"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "microservice-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "microservice-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Tolerations block: merges user-defined tolerations with the nonCritical toleration when critical=false.
*/}}
{{- define "microservice-chart.tolerationsBlock" -}}
{{- $tolerations := .Values.tolerations | default list }}
{{- if not .Values.critical }}
{{- $nonCriticalToleration := list (dict "key" "dedicated" "operator" "Equal" "value" "nonCritical" "effect" "NoSchedule") }}
{{- $tolerations = concat $nonCriticalToleration $tolerations }}
{{- end }}
{{- if $tolerations }}
tolerations:
  {{- toYaml $tolerations | nindent 2 }}
{{- end }}
{{- end }}

{{/*
NodeSelector block: adds nodeSelector for critical=false when critical=false.
*/}}
{{- define "microservice-chart.nodeSelectorBlock" -}}
{{- $nodeSelector := .Values.nodeSelector | default dict }}
{{- if not .Values.critical }}
{{- $nonCriticalNodeSelector := dict "critical" "false" }}
{{- $nodeSelector = merge $nodeSelector $nonCriticalNodeSelector }}
{{- end }}
{{- if $nodeSelector }}
nodeSelector:
  {{- toYaml $nodeSelector | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Affinity block: renders user-defined affinity if provided.
*/}}
{{- define "microservice-chart.affinityBlock" -}}
{{- $affinity := .Values.affinity | default dict }}
{{- if $affinity }}
affinity:
  {{- toYaml $affinity | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Default topologySpreadConstraints configuration
*/}}
{{- define "microservice-chart.defaultTopologySpreadConstraints" -}}
- labelSelector:
    matchLabels:
      app.kubernetes.io/instance: {{ .Release.Name }}
  maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: DoNotSchedule
- labelSelector:
    matchLabels:
      app.kubernetes.io/instance: {{ .Release.Name }}
  maxSkew: 1
  topologyKey: kubernetes.io/hostname
  whenUnsatisfiable: DoNotSchedule
{{- end }}
