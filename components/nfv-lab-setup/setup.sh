#!/bin/bash


sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1



### This line is required to set the prifile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

#upload plugins
ctx logger info "Uploading plugins"
# upload openstack v2.14.7 for old openstack version and plugin
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.14.7/cloudify_openstack_plugin-2.14.7-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-openstack-plugin/releases/download/2.14.7/plugin.yaml >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-diamond-plugin/1.3.17/cloudify_diamond_plugin-1.3.17-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/diamond-plugin/1.3.17/plugin.yaml >> /tmp/lab_status.txt 2>&1

ctx logger info "installing openstack-network"
cfy executions start install -d "openstack-network-example" >> /tmp/lab_status.txt 2>&1
# Upload blueprints
###
ctx logger info "Uploading blueprints"
cfy blueprints upload -n openstack-vm-blueprint-ws.yaml -b "private-webserver-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/private-webserver-blueprint-master.zip >> /tmp/lab_status.txt 2>&1

cfy blueprints upload -n fortigate-vnf.yaml     -b "fortigate-vnf-bp"                    https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip >> /tmp/lab_status.txt 2>&1
cfy blueprints upload -n openstack-vm-lan.yaml  -b "openstack-vnf-infra"                 https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip >> /tmp/lab_status.txt 2>&1
cfy blueprints upload -n fortigate-vnf-portforward-bp.yaml -b "fortigate-portforward-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip >> /tmp/lab_status.txt 2>&1


# Install the webserver
####
ctx logger info "creating deployment webserver"
cfy deployments create -b "private-webserver-bp" private-webserver >> /tmp/lab_status.txt 2>&1
ctx logger info "installing deployment webserver"
cfy executions start install -d "private-webserver" >> /tmp/lab_status.txt 2>&1

# Create deployments for Stage2&3
#####
ctx logger info "creating deployment VNF"
cfy deployments create -b "fortigate-vnf-bp" fortigate-vnf >> /tmp/lab_status.txt 2>&1
cfy deployments create -b "fortigate-portforward-bp" fortigate-portforward >> /tmp/lab_status.txt 2>&1
