cfy profiles use localhost -u admin -p admin -t default_tenant

# Upload blueprints
###
cfy blueprints upload -n vyos-vnf-branch.yaml    -b "vYos-vnf-branch-VPN-blueprint"                    https://github.com/Cloudify-PS/vyos-sdwan-vnf-blueprint/archive/master.zip

cfy blueprints upload -n vyos-vnf-hq-baseline.yaml    -b "vYos-vnf-hub-VPN-blueprint"                    https://github.com/Cloudify-PS/vyos-sdwan-vnf-blueprint/archive/master.zip


