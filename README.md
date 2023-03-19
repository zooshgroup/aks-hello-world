# Hello world Kubernetes (Azure - AKS)
#### Prerequisites
- install Azure CLI https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows
- install Terraform https://developer.hashicorp.com/terraform/downloads
- install kubectl https://kubernetes.io/releases/download/#kubectl
- install Helm https://helm.sh/docs/helm/helm_install/

#### Create kubernetes on Azure (some resources required a paid plan or the starting credits when registering a new account)
1. If you dont have a subscription register, create a [free account](https://azure.microsoft.com/free/)
2. `az login` (copy the id and use in the next command as the subscription id)
3. `az account set --subscription "<subscription_id_or_subscription_name>"`
4. go into the aks-terraform folder
5. `terraform apply`
6. when you finished using the cluster you should destroy it with `terraform destroy`

#### Install hello world application on the cluster
1. `az aks get-credentials --resource-group aks-hello-world --name aks-hello-world` (get credentials)
2. test connection to the cluster, `kubectl get nodes` it should return 1 node
3. `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
4. `helm install ingress-nginx ingress-nginx/ingress-nginx --create-namespace --namespace hello-world --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz` (install ingress controller)
5. go into the app folder
6. `kubectl apply -f hello-world.yaml --namespace hello-world` (add hello world application)
7. `kubectl apply -f ingress.yaml --namespace hello-world` (add hello world application ingress)
8. get the external ip address of the cluster `kubectl --namespace hello-world get services -o wide -w ingress-nginx-controller`
9. test the application by visiting the ip address

https://learn.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
https://learn.microsoft.com/en-us/azure/aks/ingress-basic

# Hello world Kubernetes (minikube)
1. dowload/install minikube https://minikube.sigs.k8s.io/docs/start/ (you can find useful commands as well)
2. `minikube start`
3. `kubectl apply -f hello-world.yaml --namespace hello-world` (add hello world application)
4. we can skip the ingress and forward the port `kubectl port-forward service/hello-world 7080:80 -n hello-world`
5. you can test the app at http://localhost:7080/