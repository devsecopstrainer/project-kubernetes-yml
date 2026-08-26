#!/bin/bash

set -e

echo "==> 1. Installing NGINX Ingress Controller (if not already installed)"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml

echo "==> Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "==> 2. Creating namespace"
kubectl apply -f idream-namespace.yaml

echo "==> 3. Creating DB secret"
kubectl apply -f db/db-secret.yaml

echo "==> 4. Deploying API layer"
kubectl apply -f api/api-configmap.yaml
kubectl apply -f api/api-deployment.yaml
kubectl apply -f api/api-service.yaml

echo "==> 5. Deploying UI layer"
kubectl apply -f ui/ui-deployment.yaml
kubectl apply -f ui/ui-service.yaml

echo "==> 6. Applying ingress"
kubectl apply -f idream-ingress.yaml

echo "==> Script ends here <=="
