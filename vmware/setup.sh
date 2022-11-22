kubectl apply -f ./vmware/vcsim_deployment.yml

while ! kubectl get deployment -n konveyor-forklift vcsim; do sleep 5; done
kubectl wait deployment -n konveyor-forklift vcsim --for condition=Available=True --timeout=180s

kubectl apply -f ./vmware/vsphere_provider.yml
kubectl apply -f ./vmware/manual_deploy_migration_vsphere.yml