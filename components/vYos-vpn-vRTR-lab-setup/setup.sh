cfy profiles use localhost -u admin -p admin -t default_tenant

# Upload blueprints
###
cfy blueprints upload -n vyos-vnf-hub-baseline.yaml    -b "vYos-hub-bp"                    https://github.com/cloudify-examples/vyos-vnf-vpn-blueprint/archive/v1.zip

cfy blueprints upload -n vyos-vnf-branch-baseline.yaml    -b "vYos-branch-bp"                    https://github.com/cloudify-examples/vyos-vnf-vpn-blueprint/archive/v1.zip

cfy blueprints upload -n vyos-vpn-config-service.yaml    -b "vYos-vpn-config-bp"                    https://github.com/cloudify-examples/vyos-vnf-vpn-blueprint/archive/v1.zip

