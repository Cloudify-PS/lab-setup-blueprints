#!/bin/bash

### This line is required to set the profile
cfy profiles use localhost -u admin -p admin -t default_tenant >> /tmp/lab_status.txt 2>&1

#### cleansups
cfy blueprints delete $id  >> /tmp/lab_status.txt 2>&1 &
