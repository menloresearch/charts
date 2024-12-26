{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name $.Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if $.Values.serviceAccount.create }}
{{- default (include "common.fullname" .) $.Values.serviceAccount.name }}
{{- else }}
{{- default "default" $.Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
define inject annotation
*/}}
{{- define "common.injectAnnotation" -}}
{{- if eq $.Values.instrumentation.type "java" }}
instrumentation.opentelemetry.io/inject-java: "true"
{{- end }}
{{- if eq $.Values.instrumentation.type  "dotnet" }}
instrumentation.opentelemetry.io/inject-dotnet: "true"
{{- end }}
{{- if eq $.Values.instrumentation.type "go" }}
instrumentation.opentelemetry.io/inject-go: "true"
{{- end }}
{{- if eq $.Values.instrumentation.type "nodejs" }}
instrumentation.opentelemetry.io/inject-nodejs: "true"
{{- end }}
{{- if eq $.Values.instrumentation.type "python" }}
instrumentation.opentelemetry.io/inject-python: "true"
{{- end }}
{{- end }}