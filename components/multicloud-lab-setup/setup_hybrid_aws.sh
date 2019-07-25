#!/bin/bash

#############make sure to create AWS secrets as follow
# cfy secrets create aws_access_key_id -s VALUE &
# cfy secrets create aws_secret_access_key -s VALUE &
# cfy secrets create ec2_region_name -s VALUE &
# cfy secrets create ec2_region_endpoint -s VALUE &
# cfy secrets create availability_zone -s VALUE &
# cfy secrets create aws_availability_zone -s VALUE &
# cfy secrets create aws_region_name -s VALUE &
#############
############# ,ake sure ti create Openstack secrets as follow
############# create secrets
#cfy secrets create openstack_username -s VALUE &
#cfy secrets create openstack_password -s VALUE &
#cfy secrets create openstack_tenant_name -s VALUE &
#cfy secrets create openstack_region -s RegionOne &
#cfy secrets create openstack_auth_url -s http://URL:5000/v2.0 &
#cfy secrets create openstack_project_name -s admin &
#cfy secrets create base_image_id -s VALUE &
#cfy secrets create base_flavor_id -s VALUE &
###############################

sudo rm -f /tmp/lab_status.txt

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

ctx logger info "installing netaddr & ipaddr"
sudo su
/opt/mgmtworker/env/bin/pip install netaddr ipaddr

#### cleansups
ctx logger info "Performing Cleanups"
cfy executions start uninstall -d "openstack-example-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1 &

##upload plugins
ctx logger info "Uploading Plugins"
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml  >> /tmp/lab_status.txt 2>&1
#cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml  >> /tmp/lab_status.txt 2>&1 &
#cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml  >> /tmp/lab_status.txt 2>&1 &
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml  >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.1.0/cloudify_openstack_plugin-3.2.0-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.2.0/plugin.yaml  >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.4.0/cloudify_ansible_plugin-2.4.0-py27-none-linux_x86_64-centos-Core.wgn  -y http://www.getcloudify.org/spec/ansible-plugin/2.4.0/plugin.yaml >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-fabric-plugin/1.5.1/cloudify_fabric_plugin-1.5.1-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/fabric-plugin/1.5.1/plugin.yaml


############ create secrets
ctx logger info "Creating Secrets"
cfy secrets create openstack_username -s admin &
cfy secrets create openstack_password -s cloudify1234 &
cfy secrets create openstack_tenant_name -s admin &
cfy secrets create openstack_region -s RegionOne &
cfy secrets create openstack_auth_url -s http://10.10.25.1:5000/v2.0 &
cfy secrets create openstack_project_name -s admin &
cfy secrets create base_image_id -s aee5438f-1c7c-497f-a11e-53360241cf0f &
cfy secrets create base_flavor_id -s 4d798e17-3439-42e1-ad22-fb956ec22b54 &


#########  Cloud network environments.
ctx logger info "Uploading Network blueprints"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/aws-example-network.zip -n blueprint.yaml -b "aws-network-bp"  >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/openstack-example-network.zip -n blueprint.yaml -b "openstack-network-bp"  >> /tmp/lab_status.txt 2>&1

######### DB LB APP  BPs on AWS and openstack
### DB LB APP Infra
ctx logger info "Uploading dblb blueprints"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-infrastructure.zip -n aws.yaml -b "public-cloud-vm"  >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-infrastructure.zip -n openstack.yaml -b "private-cloud-vm"  >> /tmp/lab_status.txt 2>&1

### DB LB APP DB
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-db.zip -n public-cloud-application.yaml -b "aws-db-bp"  >> /tmp/lab_status.txt 2>&1
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-db.zip -n private-cloud-application.yaml -b "openstack-db-app"  >> /tmp/lab_status.txt 2>&1

### DB LB APP LP
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-lb.zip -n public-cloud-application.yaml -b "aws-lb-bp"  >> /tmp/lab_status.txt 2>&1
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-lb.zip -n private-cloud-application.yaml -b "openstack-lb-app"  >> /tmp/lab_status.txt 2>&1

### DB LB APP Drupal
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-app.zip -n public-cloud-application.yaml -b "aws-drupal" & >> /tmp/lab_status.txt 2>&1
#cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-app.zip -n private-cloud-application.yaml -b "openstack-drupal"  >> /tmp/lab_status.txt 2>&1
### DB LB APP Wordpress
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/db-lb-app-kube_app.zip -n application.yaml -b "kube-wordpress-bp"  >> /tmp/lab_status.txt 2>&1

####cleansups
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network" >> /tmp/lab_status.txt 2>&1

######### Create Kubernetes Cluster Openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-11/kubernetes.zip -n openstack.yaml -b "kubernetes-bp" >> /tmp/lab_status.txt 2>&1

cfy deployments create -b "openstack-network-bp"  openstack-network -i external_network_id=2a68ccf6-6722-42f0-a300-de647e55be28 >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "openstack-network" >> /tmp/lab_status.txt 2>&1 &

cfy deployments create -b "aws-network-bp"  aws-network >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "aws-network" >> /tmp/lab_status.txt 2>&1

#### create and isnatll deployments of infra VMs + kube
ctx logger info "preparing k8s"
cfy deployments create -b "kubernetes-bp"  kubernetes -i public_subnet_cidr=10.1.18.0/24 -i external_network_id=2a68ccf6-6722-42f0-a300-de647e55be28 -i region_name=RegionOne -i image_id=aee5438f-1c7c-497f-a11e-53360241cf0f -i flavor_id=4d798e17-3439-42e1-ad22-fb956ec22b54 >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "kubernetes" >> /tmp/lab_status.txt 2>&1 &

######create and install deployments of apps on infra VMs +kube app
ctx logger info "Creating Deplyments for db and lb"
cfy deployments create -b "aws-db-bp" aws-db -i infrastructure--resource_name_prefix=db -i infrastructure--network_deployment_name=aws-network >> /tmp/lab_status.txt 2>&1
cfy deployments create -b "aws-lb-bp" aws-lb -i infrastructure--resource_name_prefix=lb -i infrastructure--network_deployment_name=aws-network -i database_deployment=aws-db >> /tmp/lab_status.txt 2>&1

ctx logger info "Executing install workflows for db "
cfy executions start install -d "aws-db" >> /tmp/lab_status.txt 2>&1
sleep 60
ctx logger info "Executing install workflows for lb"
cfy executions start install -d "aws-lb" >> /tmp/lab_status.txt 2>&1

cfy deployments create -b "kube-wordpress-bp" wordpress-app -i load_balancer_deployment=aws-lb -i kubernetes_deployment=kubernetes >> /tmp/lab_status.txt 2>&1
#cfy executions start install -d "wordpress-app" &
