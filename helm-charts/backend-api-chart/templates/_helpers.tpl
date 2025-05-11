{{/* backend-api helpers */}}

{{- define "backend-api.name" -}}
{{- printf "backend-api" -}}
{{- end -}}

{{- define "backend-api.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "backend-api.name" .) -}}
{{- end -}}

{{- define "backend-api.labels" -}}
app.kubernetes.io/name: {{ include "backend-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "v1.0"
app.kubernetes.io/component: backend-api
app.kubernetes.io/part-of: backend-api-service
{{- end -}}

