#!/bin/bash
sudo yum install python-netaddr
sudo source /opt/mgmtworker/env/bin/activate
sudo pip install netaddr

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant

#### cleansups

cfy executions start uninstall -d "openstack-example-network" &
 
# upload the e2e
####

##upload plugins

cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml &
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml &
cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml &
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.0.0/cloudify_openstack_plugin-3.0.0-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.0.0/plugin.yaml
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml 

############ create secrets
cfy secrets create openstack_username -s admin &
cfy secrets create openstack_password -s cloudify1234 &
cfy secrets create openstack_tenant_name -s admin &
cfy secrets create openstack_region -s RegionOne &
cfy secrets create openstack_auth_url -s http://10.10.25.1:5000/v2.0 &
cfy secrets create openstack_project_name -s admin &


#########  Cloud network environments.
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/aws-example-network.zip -n blueprint.yaml -b "aws-network" &
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/openstack-example-network.zip -n blueprint.yaml -b "openstack-network" &

######### DB LB APP  BPs on AWS and openstack
### DB LB APP Infra
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-infrastructure.zip -n aws.yaml -b "db-lb-app-aws-infra" &
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-infrastructure.zip -n openstack.yaml -b "db-lb-app-openstack-infra" &
### DB LB APP DB
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-db.zip -n public-cloud-application.yaml -b "aws-db-app" &
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-db.zip -n private-cloud-application.yaml -b "openstack-db-app" &
### DB LB APP LP
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-lb.zip -n public-cloud-application.yaml -b "aws-lb-app" &
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-lb.zip -n private-cloud-application.yaml -b "openstack-lb-app" &
### DB LB APP Drupal
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-app.zip -n public-cloud-application.yaml -b "aws-drupal" &
cfy blueprints upload /home/arik/Documents/work/Cloudify/labs/lab-setup-blueprints/components/multicloud-lab-setup/db-lb-app-app.zip -n private-cloud-application.yaml -b "openstack-drupal" &
### DB LB APP Wordpress
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-5/db-lb-app-kube_app.zip -n application.yaml -b "kube-wordpress-app" &


######### Create Kubernetes Cluster Openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-5/kubernetes.zip -n openstack.yaml -b "kubernetes" &

cfy deployments create -b "openstack-network"  openstack-network -i external_network_id=2a68ccf6-6722-42f0-a300-de647e55be28 &
cfy executions start install -d "openstack-network" &

cfy deployments create -b "aws-network"  aws-network &
cfy executions start install -d "aws-network" &

cfy deployments delete "openstack-example-network" 
cfy blueprints delete "openstack-example-network" &


#### create and isnatll deployments of infra VMs on AWS and openstack
cfy deployments create -b "db-lb-app-aws-infra" db-vm -i resource_name_prefix=db &
cfy deployments create -b "db-lb-app-aws-infra" lb-vm -i resource_name_prefix=lb &
cfy deployments create -b "db-lb-app-openstack-infra" app-vm -i resource_name_prefix=app &

cfy executions start install -d "db-vm" &
cfy executions start install -d "lb-vm" &
cfy executions start install -d "app-vm" &

######create and install deployments of apps on infra VMs +kube app

cfy deployments create -b "aws-db-app" aws-db -i nfrastructure--resource_name_prefix=db &
cfy deployments create -b "aws-lb-app" aws-lb  -i nfrastructure--resource_name_prefix=lb -i database_deployment=aws-db-app 
cfy deployments create -b "openstack-drupal" drupal-app -i load_balancer_deployment=aws-lb-app &

cfy executions start install -d "aws-db-app" &
cfy executions start install -d "aws-lb-app" 
cfy executions start install -d "drupal-app" 


