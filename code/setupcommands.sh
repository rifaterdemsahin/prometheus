helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/grafana -f values.yaml
kubectl logs <grafana-pod-name>
kubectl describe pod <grafana-pod-name>
kubectl get pvc

