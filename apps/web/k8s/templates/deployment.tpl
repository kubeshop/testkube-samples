apiVersion: apps/v1
kind: Deployment
metadata:
  name: samples-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: samples-web
  template:
    metadata:
      labels:
        app: samples-web
    spec:
      containers:
        - name: samples-web
          image: {{ include "common.images.image" ( dict "imageRoot" .Values.image "global" .Values.global) }}
          imagePullPolicy: Always
          ports:
            - name: http-web
              containerPort: 3001
