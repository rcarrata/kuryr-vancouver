#!/bin/bash

source /home/centos/devstack/openrc > /dev/null

echo "Cleaning vms..."
VM=$(openstack server list | awk '{print $2}' | grep -v ID)
for i in $VM; do nova delete $i; done

echo "Cleaning Pods..."
POD=$(kubectl get deployments | awk '{print $1}' | grep -v NAME)
for i in $POD; do kubectl delete deployment/$i; done

sleep 10

echo "Cheking..." 
kubectl get pods
openstack server list

