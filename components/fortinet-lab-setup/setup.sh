#!/bin/bash
#### this is modified for lab version based on CFY 4.6

sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

# upload openstack v2.14.7 for old openstack version and plugin
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.14.7/cloudify_openstack_plugin-2.14.7-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-openstack-plugin/releases/download/2.14.7/plugin.yaml >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-diamond-plugin/1.3.17/cloudify_diamond_plugin-1.3.17-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/diamond-plugin/1.3.17/plugin.yaml >> /tmp/lab_status.txt 2>&1


cfy executions start uninstall -d "openstack-example-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1 &

cfy blueprints upload https://github.com/cloudify-examples/openstack-example-network/archive/4.5.0.1.zip -n simple-blueprint.yaml -b "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy deployments create -b "openstack-example-network"  openstack-example-network -i external_network_name=external_network >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "openstack-example-network" >> /tmp/lab_status.txt 2>&1

# Install the webserver
####
#cfy blueprints upload -n openstack-vm-blueprint-ws.yaml -b "private-webserver-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/private-webserver-blueprint-master.zip
#cfy blueprints upload https://github.com/cloudify-examples/nodecellar-auto-scale-auto-heal-blueprint/archive/master.zip -n openstack.yaml -b "private-webserver-bp" --validate

## upload prive webserver BP
cfy blueprints upload https://github.com/cloudify-examples/nodecellar-auto-scale-auto-heal-blueprint/archive/4.3.zip -n openstack.yaml -b "private-webserver-bp" --validate >> /tmp/lab_status.txt 2>&1


#### upload the vFW BPs prior to isntall of HTTPD
cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-baseline-bp.yaml -b  fortigate-vnf-baseline-bp --validate >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-portforward-bp.yaml -b  fortigate-portforward-vnf-config --validate >> /tmp/lab_status.txt 2>&1

#### install HTTPD
cfy deployments create -b "private-webserver-bp" private-webserver >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "private-webserver" >> /tmp/lab_status.txt 2>&1

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
