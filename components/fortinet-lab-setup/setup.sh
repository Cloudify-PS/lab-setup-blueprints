#!/bin/bash
### This line is required to set the prifile
cfy profiles use localhost -u admin -p admin -t default_tenant

# upload openstack v2.14.7 for old openstack version and plugin
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.14.7/cloudify_openstack_plugin-2.14.7-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-openstack-plugin/releases/download/2.14.7/plugin.yaml

# Install the webserver
####
#cfy blueprints upload -n openstack-vm-blueprint-ws.yaml -b "private-webserver-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/private-webserver-blueprint-master.zip
#cfy blueprints upload https://github.com/cloudify-examples/nodecellar-auto-scale-auto-heal-blueprint/archive/master.zip -n openstack.yaml -b "private-webserver-bp" --validate 

#specific version for support openstack kilo and plugin
cfy blueprints upload https://github.com/cloudify-examples/nodecellar-auto-scale-auto-heal-blueprint/archive/4.3.zip -n openstack.yaml -b "private-webserver-bp" --validate 


#### upload the vFW BPs prior to isntall of HTTPD
cfy blueprints upload https://github.com/Cloudify-PS/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-baseline-bp.yaml -b  fortigate-vnf-baseline-bp --validate
cfy blueprints upload https://github.com/Cloudify-PS/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-portforward-bp.yaml -b  fortigate-portforward-vnf-config --validate

#### install HTTPD
cfy deployments create -b "private-webserver-bp" private-webserver
cfy executions start install -d "private-webserver"

# Upload blueprints
###  marked local from memset, change to te cmore complex versions
#cfy blueprints upload -n fortigate-vnf.yaml     -b "fortigate-vnf-bp"                    https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
#cfy blueprints upload -n openstack-vm-lan.yaml  -b "openstack-vnf-infra"                 https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
#cfy blueprints upload -n fortigate-vnf-portforward-bp.yaml -b "fortigate-portforward-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip



# Create Deployments for Stage1
######
#cfy deployments create -b "openstack-vnf-infra" sample-openstack-vnf-infra -i 'vnf_name=sample;image_url=https://s3-eu-west-1.amazonaws.com/cloudify-labs/images/FG562-DZ.img;vnf_config_port=22'

# Create deployments for Stage2&3
#####
#cfy deployments create -b "fortigate-vnf-bp" fortigate-vnf
#cfy deployments create -b "fortigate-portforward-bp" fortigate-portforward

