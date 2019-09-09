#!/bin/bash
#### this is modified for lab version based on CFY 4.6

ctx logger info "clear logs - check log at /tmp/lab_status.txt"
sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

ctx logger info "Uploading plugins"
# upload openstack v2.14.7 for old openstack version and plugin
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.14.7/cloudify_openstack_plugin-2.14.7-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-openstack-plugin/releases/download/2.14.7/plugin.yaml >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-diamond-plugin/1.3.17/cloudify_diamond_plugin-1.3.17-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/diamond-plugin/1.3.17/plugin.yaml >> /tmp/lab_status.txt 2>&1

ctx logger info "Clear old openstaclk-example deployment"
cfy executions start uninstall -d "openstack-example-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1 &

ctx logger info "Uploading openstack nwtork blueprint"
cfy blueprints upload https://github.com/arikyakir/openstack-example-network/archive/master.zip -n simple-blueprint.yaml -b "openstack-network-bp"  >> /tmp/lab_status.txt 2>&1

ctx logger info "Create openstack nwtork deployment"
cfy deployments create -b "openstack-network-bp"  openstack-network -i external_network_name=external_network >> /tmp/lab_status.txt 2>&1
cfy executions start install -d "openstack-network" >> /tmp/lab_status.txt 2>&1


## upload prive webserver BP
ctx logger info "Upload webserver blueprint"
<<<<<<< HEAD
cfy blueprints upload https://github.com/arikyakir/nodecellar-blueprint/archive/master.zip -n openstack.yaml -b "private-webserver-bp" --validate >> /tmp/lab_status.txt 2>&1
=======
cfy blueprints upload https://github.com/arikyakir/nodecellar-auto-scale-auto-heal-blueprint/archive/master.zip -n openstack.yaml -b "private-webserver-bp" --validate >> /tmp/lab_status.txt 2>&1
>>>>>>> 84ff37b95c4368ffe7d1c611a7f2970fa2dd261c


#### upload the vFW BPs prior to isntall of HTTPD
ctx logger info "Upload Fortigate blueprints"
cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-baseline-bp.yaml -b  fortigate-vnf-baseline-bp --validate >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-portforward-bp.yaml -b  fortigate-portforward-vnf-config --validate >> /tmp/lab_status.txt 2>&1

#### install HTTPD

ctx logger info "Create private webserver deployment"
cfy deployments create -b "private-webserver-bp" private-webserver -i network_blueprint_name="openstack-network-bp";network_blueprint_archive="https://github.com/arikyakir/openstack-example-network/archive/master.zip";network_deployment_name="openstack-network";network_blueprint_main_yaml="simple-blueprint.yaml">> /tmp/lab_status.txt 2>&1
ctx logger info "Install private webserver deployment"
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
