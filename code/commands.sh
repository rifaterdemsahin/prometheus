# Reinstall
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/grafana -f values.yaml

# Reinstall
helm uninstall my-release 

# Monitor
kubectl logs <grafana-pod-name>
kubectl describe pod <grafana-pod-name>
kubectl get pvc
