kubectl scale -n microservicios-vfnpoc deployment organization --replicas=0
kubectl scale -n microservicios-vfnpoc deployment employee --replicas=0
kubectl scale -n microservicios-vfnpoc deployment department --replicas=0
echo "All deployment down 🥸"
kubectl scale -n microservicios-vfnpoc deployment organization --replicas=1
kubectl scale -n microservicios-vfnpoc deployment employee --replicas=1
kubectl scale -n microservicios-vfnpoc deployment department --replicas=1
echo "🚀 All deployment up"
