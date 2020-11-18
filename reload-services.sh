nohup kubectl scale -n microservicios-vfnpoc deployment organization --replicas=0 >/dev/null 2>&1
nohup kubectl scale -n microservicios-vfnpoc deployment employee --replicas=0 >/dev/null 2>&1
nohup kubectl scale -n microservicios-vfnpoc deployment organization --replicas=0 >/dev/null 2>&1
echo All deployment down 🥸
nohup kubectl scale -n microservicios-vfnpoc deployment organization --replicas=1 >/dev/null 2>&1
nohup kubectl scale -n microservicios-vfnpoc deployment employee --replicas=1 >/dev/null 2>&1
nohup kubectl scale -n microservicios-vfnpoc deployment organization --replicas=1 >/dev/null 2>&1
echo 🚀 All deployment up
