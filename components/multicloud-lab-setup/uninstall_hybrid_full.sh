#!/bin/bash

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

#### cleansups
#cfy executions start uninstall -d "wordpress-app" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "wordpress-app" --force >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "kube-wordpress-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "aws-lb" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "aws-lb"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "aws-lb-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "aws-db" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "aws-db"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "aws-db-bp"  >> /tmp/lab_status.txt 2>&1 &


cfy executions start uninstall -d "aws-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "aws-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "aws-network-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "kubernetes" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "kubernetes"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "kubernetes-bp"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "public-cloud-vm" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "public-cloud-vm"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "public-cloud-vm"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "private-cloud-vm" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "private-cloud-vm"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "private-cloud-vm"  >> /tmp/lab_status.txt 2>&1 &

cfy executions start uninstall -d "openstack-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-network-bp"  >> /tmp/lab_status.txt 2>&1 &
