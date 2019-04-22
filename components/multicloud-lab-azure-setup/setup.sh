## multicloud that boots azure (in addition to AWS)

#!/bin/bash
### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant
# upload the e2e
####

cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml
cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml
cfy plugins upload https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/releases/download/2.3.2/cloudify_kubernetes_plugin-2.3.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/releases/download/2.3.2/plugin.yaml


###  upload network service BPs
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/aws-example-network.zip -n aws.yaml -b "aws-network" --validate
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/azure-example-network.zip -n azure.yaml -b "azure-network" --validate
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/gcp-example-network.zip -n gcp.yaml -b "gcp-network" --validate

### craeet Kubernets cluster BP for openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-2/kubernetes.zip -n openstack.yaml -b "k8s" --validate


### craeet Kubernets cluster deployment on openstack
cfy deployments create -b "k8s" k8s-deployemnt -i region=RegionOne
   -i external_network=external_network \
   -i image=05bb3a46-ca32-4032-bedd-8d7ebd5c8100 \
   -i flavor=4d798e17-3439-42e1-ad22-fb956ec22b54
cfy executions start install -d "k8s-deployemnt"
