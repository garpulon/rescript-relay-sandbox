# Dev vs Prod
Services are defined in compose for now. We translate them into kubernetes services. 

Until multiple instances of containers need to be load balanced, this should be fine. 

At such a time as load balancing, cloud functions, and other functionality is needed, a more in depth kubernetes integration would be necessary. 

# Kompose
https://kompose.io will translate docker-compose files into kubernetes deployment files