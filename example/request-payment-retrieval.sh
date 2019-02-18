curl -H "Content-Type: application/json" -X POST -d '{"variables": {"amount": {"value":555,"type":"long"}, "item": {"value":"item-xyz"} } }' http://localhost:8084/engine-rest/process-definition/key/payment-retrieval/start

