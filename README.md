# Grafana Helm Chart Deployment

This repository contains the configuration and `values.yaml` file for deploying Grafana using the Bitnami Helm chart. It includes custom settings to resolve common permission issues and ensures that Grafana runs smoothly on Kubernetes with persistent storage.

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository automates the deployment of Grafana, an open-source platform for monitoring and observability, using Helm on a Kubernetes cluster. The Helm chart is based on the official Bitnami container image of Grafana.

It includes:
- A customized `values.yaml` file to handle permission issues for persistent volumes.
- Optional debugging configurations to help troubleshoot deployment issues.

## Prerequisites

To deploy Grafana using this repository, you will need:

- A Kubernetes cluster (version 1.18 or higher recommended)
- Helm 3 installed
- kubectl configured to access your Kubernetes cluster
- A Persistent Volume (PV) or Persistent Volume Claim (PVC) available for Grafana data storage

## Installation

To install Grafana using the Bitnami Helm chart with the provided `values.yaml`, follow these steps:

1. **Add the Bitnami repository (if not already added):**

   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

2. **Clone this repository:**

   ```bash
   git clone https://github.com/yourusername/grafana-helm-deployment.git
   cd grafana-helm-deployment
   ```

3. **Install Grafana using Helm:**

   ```bash
   helm install my-release oci://registry-1.docker.io/bitnamicharts/grafana -f values.yaml
   ```

4. **Check that the Grafana pod is running:**

   ```bash
   kubectl get pods
   ```

5. **Access Grafana:**
   - If you're using a service of type `ClusterIP`, you can forward the Grafana port locally:
   
     ```bash
     kubectl port-forward svc/my-release-grafana 3000:3000
     ```
   - Access Grafana at `http://localhost:3000` in your browser.

   - Default login credentials are:
     - Username: `admin`
     - Password: `bitnami`

## Configuration

The provided `values.yaml` contains several customizations to handle permission issues and persistent storage for Grafana. Key configurations include:

- **Persistent Volume Storage**: The chart uses a Persistent Volume Claim (PVC) for storing Grafana's data.
- **Security Context**: The container is configured to run as a non-root user (`runAsUser: 1001`) with the correct permissions (`fsGroup: 1001`) for persistent volume access.
- **InitContainer**: An `initContainer` is used to fix directory permissions before the main Grafana container starts.
  
### Customizing Values

You can modify the `values.yaml` file to adjust the configuration to your needs, such as:

- Enabling ingress
- Changing resource limits
- Customizing Grafana dashboards and plugins

To apply changes, update the `values.yaml` file and upgrade the release:

```bash
helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/grafana -f values.yaml
```

## Usage

Once deployed, Grafana can be accessed through the service's exposed port. You can log in and start creating dashboards, adding data sources, and configuring alerts.

For further details on using Grafana, check the [Grafana documentation](https://grafana.com/docs/).

## Troubleshooting

### 1. **Permission Denied for `/opt/bitnami/grafana/data/plugins`:**
   If you see the error `mkdir: cannot create directory '/opt/bitnami/grafana/data/plugins': Permission denied`, this could indicate a permissions issue with the Persistent Volume.

   - Ensure the `initContainer` is configured to fix the permissions:
     ```yaml
     initContainers:
       - name: fix-permissions
         image: busybox
         command: ['sh', '-c', 'chown -R 1001:1001 /opt/bitnami/grafana/data && chmod -R 775 /opt/bitnami/grafana/data']
     ```

   - Re-deploy the release:
     ```bash
     helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/grafana -f values.yaml
     ```

### 2. **Grafana Pod Stuck in `CrashLoopBackOff`:**
   If the Grafana pod is in a `CrashLoopBackOff` state, check the pod logs for detailed error messages:
   ```bash
   kubectl logs <grafana-pod-name>
   ```

   Ensure the Persistent Volume has the correct permissions and that Grafana can write to the required directories.

### 3. **Accessing Grafana:**
   If you are unable to access Grafana, ensure that the port forwarding is correctly configured or that your service type is set appropriately (e.g., `LoadBalancer` or `ClusterIP`).

## Contributing

If you would like to contribute, please feel free to submit a pull request or open an issue for any bugs or feature requests. Contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to update the repository URL, default values, and other specifics based on your project. This `README.md` provides an overview of the project and instructions for deployment, making it easier for others to understand and contribute.
