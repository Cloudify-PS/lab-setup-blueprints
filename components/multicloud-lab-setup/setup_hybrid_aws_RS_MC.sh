#!/bin/bash

#############make sure to create AWS secrets as follow
# cfy secrets create aws_access_key_id -s VALUE &
# cfy secrets create aws_secret_access_key -s VALUE &
# cfy secrets create ec2_region_name -s VALUE &
# cfy secrets create ec2_region_endpoint -s VALUE &
# cfy secrets create availability_zone -s VALUE &
# cfy secrets create aws_availability_zone -s VALUE &
# cfy secrets create aws_region_name -s VALUE &
#############
ctx logger info "Clear logs. refer to /tmp/lab_status.txt for logs"
sudo rm -f /tmp/lab_status.txt

ctx logger info "installing netaddr & ipaddr"
sudo su
/opt/mgmtworker/env/bin/pip install netaddr ipaddr

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

#### cleansups
ctx logger info "Performing Cleanups"
cfy executions start uninstall -d "openstack-example-network" -p ignore_failure=true >> /tmp/lab_status.txt 2>&1
cfy deployments delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1
cfy blueprints delete "openstack-example-network"  >> /tmp/lab_status.txt 2>&1 &

##upload plugins
ctx logger info "Uploading plugins"
cfy plugins upload https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.0.2/cloudify_aws_plugin-2.0.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-aws-plugin/releases/download/2.1.0/plugin.yaml  >> /tmp/lab_status.txt 2>&1
#cfy plugins upload https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/cloudify_gcp_plugin-1.4.4-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-cosmo/cloudify-gcp-plugin/releases/download/1.4.4/plugin.yaml  >> /tmp/lab_status.txt 2>&1 &
#cfy plugins upload https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/cloudify_azure_plugin-2.1.2-py27-none-linux_x86_64-centos-Core.wgn -y https://github.com/cloudify-incubator/cloudify-azure-plugin/releases/download/2.1.2/plugin.yaml  >> /tmp/lab_status.txt 2>&1 &
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.0.3/cloudify_ansible_plugin-2.0.3-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/ansible-plugin/2.0.3/plugin.yaml  >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/3.2.2/cloudify_openstack_plugin-3.2.2-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/openstack-plugin/3.2.2/plugin.yaml  >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-ansible-plugin/2.4.0/cloudify_ansible_plugin-2.4.0-py27-none-linux_x86_64-centos-Core.wgn  -y http://www.getcloudify.org/spec/ansible-plugin/2.4.0/plugin.yaml >> /tmp/lab_status.txt 2>&1
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-fabric-plugin/1.5.1/cloudify_fabric_plugin-1.5.1-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/fabric-plugin/1.5.1/plugin.yaml
cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/kubernetes-plugin/2.3.2/kubernetes-plugin-2.3.2-py27-none-linux_x86_64-centos-Core.wgn -y http://www.getcloudify.org/spec/kubernetes-plugin/2.3.2/plugin.yaml

############ create secrets
ctx logger info "Adding RS secrets"
cfy secrets create openstack_username -s arik &
cfy secrets create openstack_password -s RZSX0x5hD5ljbDwDH//727pqszI= &
cfy secrets create openstack_tenant_name -s arik-tenant &
cfy secrets create openstack_region -s RegionOne &
cfy secrets create openstack_auth_url -s https://rackspace-api.cloudify.co:5000/v2.0 &
cfy secrets create openstack_project_name -s arik-tenant &
cfy secrets create base_image_id -s 0847a4c0-99bf-4cb7-9cec-b019eb2fae99 &
cfy secrets create base_flavor_id -s 3 &


cfy secrets create agent_key_private -s "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxW9a7AxxvAIDD0Slu7EBsDY95/vns9TzuZuJiG1dZzWa1TA5
QHOpDomQvXcvPSWzE6qM1Xa5i9oHD3Ixr1qvK2MBgDU6XaYMHK4yJO8nVetMEAqr
rErZH2VHDcVDOZ+5lQ2Lol5rbj6gzuqjW1H5R61T0tDIQHr6+SHgVtVwP6rT2DAf
NIlKqTxYqsevjXhs7YfBzV/OeYJO1qF1NPUepLqv9w2ZGBkT2snSmfTqYiZSGf5b
/W+xH+UTI5U4l13EXdq6GWePFy8hmMxq2X6GX2ie8b4fuCjVWpzAbLYtE8Os4OW+
GJMOlO/AO3n89PrTlFExYJaxMyjRefM3cRgg3wIDAQABAoIBAAaiOTHZMTEZ+DRZ
ICBwUBg1mlrjEePu8cl4umRFGHBRUsR6/FF4EWQVpzFWgdXSIHQ2tMivVoimaLpS
Ie08ZMpWZ0SBhVaEL7/+8lxfVLkEUOfxE9eUJDtz0bFawWl8PmYNsHViKsXngMuz
Ao4c8P1Bi6F3tmLEPw6D3t/MCBt7eMRwckOHshOR16vlMxowhtdLC8wQ23ciN78K
mKIUDoY8p3SkRZm3Be64yrZKYbcGjnn93zGp4HGDp5KqAA6eVZKN71Uo4CQdUDV4
8fGr+9YeUXaFnQ+bdy5WMA+27dWd/Jlwhss9GyT5kQh10NT2Lkfnzx8vz5USG6xf
cZ5GY7ECgYEA7nLrWOnAuPHtMwWid8+ZhSuri/xx52IgQMv1OjTm3aLAU0HVKXGt
fI+mjXXvsyvUbzm0m7cGPxA9yu0ig06cvJvmOegj7ZOY0wzyornwT//QZANWPOa3
q900L+DZgWruluCOK3SvX/nG0slL02h7vSVXvPpcUFRSKLDffHF5mw0CgYEA0/ec
0P2XyV9tdlvNNfPbh7/H2sXsy2xJxVmwOJi9CSt2GKmgV7PVbTzevmNeu9CtybNf
PLmdhESn2m2anfXu0FDG8NXceaOBV8Ftf0YpW5BnrtvpciN1fPxvfmvkZWBO5it1
ikwCj+eTL7W+Z4pJO2S7t/IYG/F5zIl4aS+EQJsCgYBp9QMDlYugI1Dl9UEGwGdV
t9wY7mqnCQGQCZHE9bEJF8MivAQ+0FbpHORDw/5pvbY+XoQVFbVe3Ja4z7sgYhRf
817QqIkejxG/5ucCzGEvC1vMtXbixRsk8by48c91JNE0lkBWqxkrKtDg5bYeETW7
DRb50L6oq29+yWnl4H7LGQKBgQCZ5fsepjDxjW6tc8PP+2kV68GQbwoZPFtnhVH0
FbmSkdKh327CnphEQuC6vO1IUiAMBUcNkPrz0OFKLzAGpkwpRazbqXr1eihr7c2x
jeBzUapmA9c//szL3YCZ+n4OuNkwNreVnNBzaUCtcDh5dqbrD51X1dd5Wl8DiYA6
ZryQJwKBgQDdESUF0Szv9Ydgw6tamaRNwpYirhYG+IDTN/mQJzP2kU+8+DIrC02Y
nS9icb09fLL6+0EwDiqgJYQ1nNH6VUT7hJ9XNkw3aYrUoZS2a8tLrh53yWculKgq
qGYS/sRHMNiCjwj08hdgtoSBHk/QRnnwHp0kLlnITH/jEESnALC4og==
-----END RSA PRIVATE KEY-----"

cfy secrets create agent_key_public -s "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFb1rsDHG8AgMPRKW7sQGwNj3n++ez1PO5m4mIbV1nNZrVMDlAc6kOiZC9dy89JbMTqozVdrmL2gcPcjGvWq8rYwGANTpdpgwcrjIk7ydV60wQCqusStkfZUcNxUM5n7mVDYuiXmtuPqDO6qNbUflHrVPS0MhAevr5IeBW1XA/qtPYMB80iUqpPFiqx6+NeGzth8HNX855gk7WoXU09R6kuq/3DZkYGRPaydKZ9OpiJlIZ/lv9b7Ef5RMjlTiXXcRd2roZZ48XLyGYzGrZfoZfaJ7xvh+4KNVanMBsti0Tw6zg5b4Ykw6U78A7efz0+tOUUTFglrEzKNF58zdxGCDf root@cloudify"


######### DB LB APP  BPs on AWS and openstack
### DB LB APP Infra
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-18/db-lb-app-infrastructure.zip -n aws.yaml -b "public-cloud-vm"  >> /tmp/lab_status.txt 2>&1
cfy blueprints upload https://github.com/cloudify-community/blueprint-examples/releases/download/4.5.5-18/db-lb-app-infrastructure.zip -n openstack.yaml -b "private-cloud-vm"  >> /tmp/lab_status.txt 2>&1

ctx logger info "done upload infra BPs"
