cfy profiles use localhost -u admin -p admin -t default_tenant
# Install the webserve
####
cfy blueprints upload -n openstack-vm-blueprint-ws.yaml -b "private-webserver-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/private-webserver-blueprint-master.zip
cfy deployments create -b "private-webserver-bp" private-webserver
cfy executions start install -d "private-webserver"

# Upload blueprints
###
cfy blueprints upload -n fortigate-vnf.yaml     -b "fortigate-vnf-bp"                    https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
cfy blueprints upload -n openstack-vm-lan.yaml  -b "openstack-vnf-infra"                 https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip
cfy blueprints upload -n fortigate-vnf-portforward-bp.yaml -b "fortigate-portforward-bp" https://storage.reading-a.openstack.memset.com:8080/swift/v1/ca0c4540c8f84ad3917c40b432a49df8/Blueprints/NFVLAb/nfv-scenario-blueprint-master.zip

# Create Deployments for Stage1
######
cfy deployments create -b "openstack-vnf-infra" sample-openstack-vnf-infra -i 'vnf_name=sample;image_url=https://s3-eu-west-1.amazonaws.com/cloudify-labs/images/FG562-DZ.img;vnf_config_port=22'

# Create deployments for Stage2&3
#####
cfy deployments create -b "fortigate-vnf-bp" fortigate-vnf
cfy deployments create -b "fortigate-portforward-bp" fortigate-portforward
