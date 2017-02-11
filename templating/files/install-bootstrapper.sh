#!/bin/bash

# Install Blacksmith Docker
SOCK=unix:///var/run/early-docker.sock
docker -H $SOCK rm -f blacksmith || true
docker -H $SOCK pull {{ (cluster_variable "blacksmith_image") }}
docker -H $SOCK run --name blacksmith --restart=always -d --net=host \
  -v /var/lib/blacksmith/workspaces:/workspace \
  {{ (cluster_variable "blacksmith_image") }} \
    --etcd http://127.0.0.1:2379 \
    --if $1 \
    --cluster-name {{ (cluster_variable "cluster_name") }} \
    --lease-start {{ (cluster_variable "internal_network_workers_start") }} \
    --lease-range {{ (cluster_variable "internal_network_workers_limit") }} \
    --dns {{ (cluster_variable "external_dns") }} \
    --file-server {{ (cluster_variable "file_server") }} \
    --workspace /workspace \
    --workspace-repo {{(cluster_variable "workspace-repo")}}
