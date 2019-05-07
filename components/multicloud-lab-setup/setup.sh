#!/bin/bash
sudo yum install python-netaddr
sudo source /opt/mgmtworker/env/bin/activate
sudo pip install netaddr

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant

# upload the e2e
####

##upload plugins

cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/plugin.yaml
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml
cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.0.0/cloudify_openstack_plugin-3.0.0-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.0.0/plugin.yaml
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml

#########  Cloud network environments.
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/aws-example-network.zip -n blueprint.yaml -b "aws-network"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/openstack-example-network.zip -n blueprint.yaml -b "openstack-network"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/azure-example-network.zip -n blueprint.yaml -b "azure-network"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/gcp-example-network.zip -n blueprint.yaml -b "gcp-network"

######### DB LB APP
### DB LB APP Infra
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-infrastructure.zip -n aws.yaml -b "public-cloud"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-infrastructure.zip -n openstack.yaml -b "private-cloud"
### DB LB APP DB
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-db.zip -n public-cloud-application.yaml -b "public-cloud-db"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-db.zip -n private-cloud-application.yaml -b "private-cloud-db"
### DB LB APP LP
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-lb.zip -n public-cloud-application.yaml -b "public-cloud-lb"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-lb.zip -n private-cloud-application.yaml -b "private-cloud-lb"
### DB LB APP Drupal
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-app.zip -n public-cloud-application.yaml -b "public-cloud-drupal"
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-app.zip -n private-cloud-application.yaml -b "private-cloud-drupal"
### DB LB APP Wordpress
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/db-lb-app-kube_app.zip -n application.yaml -b "kube-wordpress"

######### Create Kubernetes Cluster Openstack
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-4/kubernetes.zip -n openstack.yaml -b "kubernetes"






