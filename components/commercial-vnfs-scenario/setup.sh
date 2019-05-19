#!/bin/bash
sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
### COMMERCIAL VNFs SCENARIO on AZURE ###########

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1


## upload plugins

cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml >> /tmp/lab_status.txt 2>&1


#########  Cloud network environments.
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/aws-example-network.zip -n blueprint.yaml -b "aws-network" >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/azure-example-network.zip -n blueprint.yaml -b "azure-network" >> /tmp/lab_status.txt 2>&1

######### APPS
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/commercial-vnf-e2e.zip -n azuree2e.yaml -b "Azure-E2E" >> /tmp/lab_status.txt 2>&1
