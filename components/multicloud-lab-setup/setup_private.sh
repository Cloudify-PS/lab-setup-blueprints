#!/bin/bash
#run the e2e on the local env- k8s for the app
sudo yum install python-netaddr
sudo source /opt/mgmtworker/env/bin/activate
sudo pip install netaddr

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant

#### cleansups
cfy executions start uninstall -d "openstack-example-network" &
cfy deployments delete "openstack-example-network"
cfy blueprints delete "openstack-example-network" &

##upload plugins

cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml &
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml &
cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml &
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.0.0/cloudify_openstack_plugin-3.0.0-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.0.0/plugin.yaml
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml &

############ create secrets
cfy secrets create openstack_username -s admin &
cfy secrets create openstack_password -s cloudify1234 &
cfy secrets create openstack_tenant_name -s admin &
cfy secrets create openstack_region -s RegionOne &
cfy secrets create openstack_auth_url -s http://10.10.25.1:5000/v2.0 &
cfy secrets create openstack_project_name -s admin &
cfy secrets create base_image_id -s aee5438f-1c7c-497f-a11e-53360241cf0f
cfy secrets create base_flavor_id -s 4d798e17-3439-42e1-ad22-fb956ec22b54


#########  Cloud network environments.
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/aws-example-network.zip -n blueprint.yaml -b "aws-network" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/openstack-example-network.zip -n blueprint.yaml -b "openstack-network" &
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/azure-example-network.zip -n blueprint.yaml -b "azure-network" &
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/gcp-example-network.zip -n blueprint.yaml -b "gcp-network" &

######### DB LB APP
### DB LB APP Infra
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-infrastructure.zip -n aws.yaml -b "public-cloud-vm" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-infrastructure.zip -n openstack.yaml -b "private-cloud-vm" &
### DB LB APP DB
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "db-aws-app-bp" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-db-app-bp" &
### DB LB APP LP
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "aws-lb-app-bp" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-lb-app-bp-bp" &
### DB LB APP Drupal
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "aws-drupal-bp" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-drupal-bp" &
### DB LB APP Wordpress
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-kube_app.zip -n application.yaml -b "kube-wordpress-app-bp" &

######### Create Kubernetes Cluster Openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/kubernetes.zip -n openstack.yaml -b "kubernetes-bp" &

cfy deployments create -b "openstack-network-bp"  openstack-network -i external_network_id=2a68ccf6-6722-42f0-a300-de647e55be28 &
cfy executions start install -d "openstack-network"

######create and install deployments of apps on infra VMs

cfy deployments create -b "openstack-db-app-bp" db-app -i network_deployment_name=openstack-network &
cfy deployments create -b "openstack-lb-app-bp" lb-app -i network_deployment_name=openstack-network &
cfy deployments create -b "openstack-drupal-bp" drupal-app -i network_deployment_name=openstack-network &

#cfy executions start install -d "db-app"
#cfy executions start install -d "lb-app"
#cfy executions start install -d "drupal-app"
