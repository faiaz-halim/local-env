# Setup your local dev/test kubernetes cluster in 5 minutes!!*

*The above claim depends on your internet and processing power. \^-\^

This repository exists only to get rid of the phrase, **"But it works in my pc!"**
The cluster bootstrap mechanism currently supports debian based releases preferably Ubuntu. Windows and Mac docker desktop based installation is under consideration.

# Components

|Tool                                                               |Version    |
|-------------------------------------------------------------------|-----------|
|[Docker](https://docs.docker.com/engine/release-notes/)			|25.0.3		|
|[Kubectl](https://kubernetes.io/releases/)							|1.29.2 	|
|[KinD](https://github.com/kubernetes-sigs/kind/releases)          	|0.21.0		|
|[Helm](https://github.com/helm/helm/releases)						|3.14.2		|
|[Helmfile](https://github.com/helmfile/helmfile/releases)			|0.162.0	|
|[Calico](https://github.com/projectcalico/calico/releases)			|3.25.0		|
|[Nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/releases)	|4.0.18		|
|[Elasticsearch](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch)	|8.12.2	|
|[Kibana](https://github.com/bitnami/charts/tree/main/bitnami/kibana)				|8.12.1	|
|[Fluent Bit](https://github.com/bitnami/charts/tree/main/bitnami/fluent-bit)		|2.2.2	|
|[Prometheus](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus)	|2.49.1	|
|[Grafana](https://github.com/bitnami/charts/tree/main/bitnami/grafana)				|10.3.3	|
|[Metric Server](https://github.com/bitnami/charts/tree/main/bitnami/metrics-server)|0.7.0	|

# Installation



## Prerequisite

Make needs to be installed
```
sudo apt update
sudo apt install make
```

## Fresh Install

Running this for the first time and don't have docker, kubectl, kind, helm, helmfile installed?
```
make first
```

## General Install

Install the cluster with all components if you have docker, kubectl, kind, helm, helmfile installed already.
```
make up
```

## Uninstall

Destroy the cluster and nfs configuration. This will not delete nfs shared directory contents.
```
make down
```
> **Important**: Make sure to update `server` in `nfs.yaml` under `dev/values` directory. If you are not sure, reinstall the cluster with `make down up`

## Install Applications

> **Optional**: Point to this cluster's kubeconfig
```
export KUBECONFIG=~/.kube/config
```
If the applications are already available as a helm chart, add them in `helmfile.yaml` and run,
```
make apply
```
Alternatively apply application manifests with kubectl,
```
kubectl apply -f <your_yaml_manifest_file_or_directory>
```

## Dashboards

> **Info**: Port 30000-30020 and 32767 are already open. You can open more in `cluster/kind-config.yaml` as well.

### Kibana

Get the `elastic` user password to access Kibana `http://localhost:30000/`
```
kubectl get secrets/elasticsearch-kibana -n platform --template='{{ index .data "kibana-password" | base64decode}}'
```

### Grafana

Get the `admin` user password to access Grafana `http://localhost:30001/`
```
kubectl get secrets/prometheus-grafana -n platform --template='{{index .data "admin-password" | base64decode}}'
```

### Prometheus

Prometheus dashboard at `http://localhost:30002/`

### Alertmanager

Alertmanager dashboard at `http://localhost:30003/`
