{{/* nginx helpers */}}

{{- define "nginx.name" -}}
{{- printf "nginx" -}}
{{- end -}}

{{- define "nginx.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "nginx.name" .) -}}
{{- end -}}

{{- define "nginx.labels" -}}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "v1.0"
app.kubernetes.io/component: nginx
app.kubernetes.io/part-of: nginx-service
{{- end -}}

