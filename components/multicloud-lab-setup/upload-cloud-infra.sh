#!/bin/bash

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1


### public cloud VM Infra
cfy blueprints upload $blueprint_archive -n $main_file_name -b $id  >> /tmp/lab_status.txt 2>&1

ctx logger info "done upload cloud-infra BP as ID "$id
