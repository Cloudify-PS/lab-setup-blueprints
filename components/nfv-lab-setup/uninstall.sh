#!/bin/bash
#### this is modified for lab version based on CFY 4.6

sudo rm -f /tmp/lab_status.txt
sudo yum install -y  python-netaddr >> /tmp/lab_status.txt 2>&1
sudo sh -c "  ./opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1
sudo sh -c "source /opt/mgmtworker/env/bin/activate ; pip install netaddr" >> /tmp/lab_status.txt 2>&1

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1


cfy executions start uninstall -d "fortigate-portforward" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "fortigate-portforward"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "fortigate-portforward-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "fortigate-vnf" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "fortigate-vnf"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "fortigate-vnf-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "private-webserver" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "private-webserver"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "private-webserver-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "openstack-vnf-infra" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-vnf-infra"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-vnf-infra"  >> /tmp/lab_status.txt 2>&1 &
