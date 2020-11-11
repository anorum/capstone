# Udacity Capstone - Blue Green Deployment on K8s
https://github.com/anorum/capstone

The following demonstrates using Jenkins to perform a Blue Green deployment on a Kubernetes cluster spun up using eksctl and ansible.

The Blue Green Deployment is Implemented by spinning up a new deployment, checking its health and then redirecting the LoadBalancer service to the new Deployment if it's successful. 

Step 1) Get the old BlueVersion deployment number
`export BlueVersion=$(kubectl get svc capstone -o=jsonpath='{.spec.selector.version}')`

Step 2) Using the Build Number from the current Jenkins build create a new deployment
`sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app.yml | kubectl apply -f -`

Step 3) Check the Health of the new deployment. 
If it's successful redirect the LoadBalancer service and delete the BlueVersion to the new deployment. 
If it fails then delete the new build deployment
```
if ! kubectl rollout status deployment capstone-${BUILD_NUMBER}; then
                    # Delete the new deployment
                    kubectl delete deployment capstone-${BUILD_NUMBER}
                    kubectl rollout status deployment capstone-${BUILD_NUMBER}
                    exit 1
                else
                    # If the new deployment succeeded then redirect the LoadBalancer service to the new pod
                    sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app-service.yml | kubectl apply -f -

                    # Delete the old BlueVersion deployment
                    kubectl delete deployment capstone-$BlueVersion
                fi 
```
