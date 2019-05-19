#!/bin/bash
#### this is modified for lab version based on CFY 4.6

sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1


cfy blueprints upload https://github.com/cloudify-examples/nodecellar-auto-scale-auto-heal-blueprint/archive/4.3.zip -n openstack.yaml -b "private-webserver-bp" --validate >> /tmp/lab_status.txt 2>&1


cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-baseline-bp.yaml -b  fortigate-vnf-baseline-bp --validate >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/arikyakir/fortigate-pf-vnf-blueprint/archive/master.zip -n fortigate-vnf-portforward-bp.yaml -b  fortigate-portforward-vnf-config --validate >> /tmp/lab_status.txt 2>&1


cfy executions start uninstall -d "config" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "config"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "fortigate-portforward-vnf-config"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "firewall" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "firewall"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "fortigate-vnf-baseline-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "private-webserver" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "private-webserver"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "private-webserver-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "openstack-example-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1 &
