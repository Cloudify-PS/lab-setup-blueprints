#!/bin/bash
#run the e2e on the local env- k8s for the app
sudo yum install python-netaddr
sudo source /opt/mgmtworker/env/bin/activate
sudo pip install netaddr

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant

#### cleansups
cfy executions start uninstall -d "openstack-example-network" >> /tmp/cfy_status.txt 2>&1 &
cfy deployments delete "openstack-example-network" >> /tmp/cfy_status.txt 2>&1
cfy blueprints delete "openstack-example-network" >> /tmp/cfy_status.txt 2>&1 &

##upload plugins

cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.1.0/cloudify_openstack_plugin-3.1.0-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.1.0/plugin.yaml >> /tmp/cfy_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml >> /tmp/cfy_status.txt 2>&1 &

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
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/aws-example-network.zip -n blueprint.yaml -b "aws-network" >> /tmp/cfy_status.txt 2>&1 &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/openstack-example-network.zip -n blueprint.yaml -b "openstack-network" >> /tmp/cfy_status.txt 2>&1 &
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/azure-example-network.zip -n blueprint.yaml -b "azure-network" &
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/gcp-example-network.zip -n blueprint.yaml -b "gcp-network" &

######### DB LB APP
### DB LB APP Infra
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-infrastructure.zip -n aws.yaml -b "public-cloud-vm" >> /tmp/cfy_status.txt 2>&1 &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-infrastructure.zip -n openstack.yaml -b "private-cloud-vm" >> /tmp/cfy_status.txt 2>&1 &
### DB LB APP DB
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "db-aws-app-bp" >> /tmp/cfy_status.txt 2>&1 &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-db-app-bp" >> /tmp/cfy_status.txt 2>&1 &
### DB LB APP LP
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "aws-lb-app-bp" >> /tmp/cfy_status.txt 2>&1 &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-lb-app-bp-bp" >> /tmp/cfy_status.txt 2>&1 &
### DB LB APP Drupal
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n public-cloud-application.yaml -b "aws-drupal-bp" >> /tmp/cfy_status.txt 2>&1 &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-app.zip  -n private-cloud-application.yaml -b "openstack-drupal-bp" >> /tmp/cfy_status.txt 2>&1 &
### DB LB APP Wordpress
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/db-lb-app-kube_app.zip -n application.yaml -b "kube-wordpress-app-bp" >> /tmp/cfy_status.txt 2>&1 &

######### Create Kubernetes Cluster Openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-7/kubernetes.zip -n openstack.yaml -b "kubernetes-bp" >> /tmp/cfy_status.txt 2>&1 &

cfy deployments create -b "openstack-network-bp"  openstack-network -i external_network_id=2a68ccf6-6722-42f0-a300-de647e55be28 >> /tmp/cfy_status.txt 2>&1 
cfy executions start install -d "openstack-network" >> /tmp/cfy_status.txt 2>&1

######create and install deployments of apps on infra VMs

cfy deployments create -b "openstack-db-app-bp" db-app -i network_deployment_name=openstack-network >> /tmp/cfy_status.txt 2>&1 &
cfy deployments create -b "openstack-lb-app-bp" lb-app -i network_deployment_name=openstack-network >> /tmp/cfy_status.txt 2>&1 &
cfy deployments create -b "openstack-drupal-bp" drupal-app -i network_deployment_name=openstack-network >> /tmp/cfy_status.txt 2>&1 &

#cfy executions start install -d "db-app"
#cfy executions start install -d "lb-app"
#cfy executions start install -d "drupal-app"
