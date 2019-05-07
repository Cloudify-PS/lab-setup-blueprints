#!/bin/bash

### COMMERCIAL VNFs SCENARIO on AZURE ###########

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant

# upload the e2e
####

## upload plugins

cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml


#########  Cloud network environments.
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/aws-example-network.zip -n blueprint.yaml -b "aws-network"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/azure-example-network.zip -n blueprint.yaml -b "azure-network"

######### APPS
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/commercial-vnf-e2e.zip -n azuree2e.yaml -b "Azure-E2E"





