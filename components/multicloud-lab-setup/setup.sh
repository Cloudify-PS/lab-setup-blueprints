#!/bin/bash
### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant
# upload the e2e
####

cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml

###  network service BP
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/aws-example-network.zip -n aws.yaml -b "aws-network" --validate
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/azure-example-network.zip -n azure.yaml -b "azure-network" --validate
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/gcp-example-network.zip -n gcp.yaml -b "gcp-network" --validate


### craeet Kubernets cluster BP for openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/kubernetes.zip -n openstack.yaml -b "k8s" --validate



cfy deployments create -b "k8s" k8s-deployemnt
cfy executions start install -d "k8s-deployemnt"
