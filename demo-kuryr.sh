#!/usr/bin/env bash

# ENV
. demo-magic.sh
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "
clear

pe "cd /home/centos/devstack/"

pe "source openrc admin"

p "## This is Devstack Openstack Deployment"

pe "systemctl list-units devstack@* --no-pager"

pe "clear"

p "## Kuryr and Kubernetes components"

pe "systemctl list-units devstack@ku* --no-pager"

pe "clear"

pe "docker ps"

pe "kubectl get nodes"

p ""


p "## Kick up a pod" 

pe "kubectl run demo --image=demo:demo"


p "## Boot a Vm"

pe "nova boot --flavor m1.tiny --image cirros testvm && sleep 10"

p "## Check the vm and the containers created"

pe "openstack server list -c Name -c Networks -c 'Image Name'"
pe "kubectl get pods -o wide"

pod=$(kubectl get pods -l run=demo -o jsonpath='{.items[].metadata.name}')

pod_ip=$(kubectl get pod $pod -o jsonpath='{.status.podIP}')

vm_ip=$(openstack server list -c 'Networks' | grep -v Network | awk '{ print$2 }' | cut -d "=" -f2- | sed 's/,$//')

pe "clear"

echo $pod have this $pod_ip IP

echo "test_vm have this IP $vm_ip "

p "## Kuryr Magic has happened!"
openstack port list | grep $pod_ip

p "## Test connectivity"

#pe "kubectl exec -ti $pod /bin/bash"

kubectl exec $pod -- bash -c "ping -c4 $vm_ip"


# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""

