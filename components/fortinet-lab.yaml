#!/bin/bash
### This line is required to set the prifile
cfy profiles use localhost -u admin -p admin -t default_tenant
# Install the webserve
####
cfy blueprints upload -n openstack-vm-blueprint-ws.yaml -b "private-webserver-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/private-webserver-blueprint-master.zip
cfy deployments create -b "private-webserver-bp" private-webserver
cfy executions start install -d "private-webserver"

# Upload blueprints
###
cfy blueprints upload -n fortigate-vnf.yaml     -b "fortigate-vnf-bp"                    https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
cfy blueprints upload -n openstack-vm-lan.yaml  -b "openstack-vnf-infra"                 https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
cfy blueprints upload -n fortigate-vnf-portforward-bp.yaml -b "fortigate-portforward-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip

# Create Deployments for Stage1
######
cfy deployments create -b "openstack-vnf-infra" sample-openstack-vnf-infra -i 'vnf_name=sample;image_url=https://s3-eu-west-1.amazonaws.com/cloudify-labs/images/FG562-DZ.img;vnf_config_port=22'

# Create deployments for Stage2&3
#####
cfy deployments create -b "fortigate-vnf-bp" fortigate-vnf
cfy deployments create -b "fortigate-portforward-bp" fortigate-portforward


## Image Upload

# create Keystone Auth Just Once
sudo ssh  -oStrictHostKeyChecking=no -i /root/remote.rsa cloudify@10.10.25.1 "echo \"export OS_USERNAME=admin ;export OS_PASSWORD=cloudify1234 ; export OS_PROJECT_DOMAIN_NAME=Default ; export OS_USER_DOMAIN_NAME=Default ; export OS_PROJECT_N AME=admin; export OS_AUTH_URL=http://10.10.25.1:5000/v3 \" > keystone_auth "

# Upload Image
sudo ssh  -oStrictHostKeyChecking=no -i /root/remote.rsa cloudify@10.10.25.1 ". keystone_auth ; curl https://s3-eu-west-1.amazonaws.com/cloudify-labs/images/FG562-DZ.img |  glance image-create --disk-format raw --name sample"
sudo ssh  -oStrictHostKeyChecking=no -i /root/remote.rsa cloudify@10.10.25.1 ". keystone_auth ; curl https://s3-eu-west-1.amazonaws.com/cloudify-labs/images/FG562-DZ.img |  glance image-create --disk-format raw --name fortigate"

# Create Flavors
sudo ssh  -oStrictHostKeyChecking=no -i /root/remote.rsa cloudify@10.10.25.1 ". keystone_auth ; openstack flavor create --id '4d798e17-3439-42e1-ad22-fb956ec22b54' --ram 2048 --disk 20 --vcpus 1 --public 1x2"
sudo ssh  -oStrictHostKeyChecking=no -i /root/remote.rsa cloudify@10.10.25.1 ". keystone_auth ; openstack flavor create --id '62ed898b-0871-481a-9bb4-ac5f81263b33' --ram 2048 --disk 20 --vcpus 2 --public 2x2"
