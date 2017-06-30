


declare -a workerList=(192.168.1.160 192.168.1.161 192.168.1.162)

for i in  "${workerList[@]}"
  do
    openssl genrsa -out $i-worker-key.pem 2048
    export WORKER_IP=$i
    openssl req -new -key $i-worker-key.pem -out $i-worker.csr -subj "/CN=$i" -config worker-openssl.cnf
    export WORKER_IP=$i
    openssl x509 -req -in $i-worker.csr -CA ../ca/ca.pem -CAkey ../ca/ca-key.pem -CAcreateserial -out $i-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf
  done
