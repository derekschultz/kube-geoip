# kube-geoip

A simple Python API server that fetches latitude and longitude information via [GeoLite2](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data?lang=en) for a given IP and outputs to JSON format.

The API runs via a Kubernetes deployment, and it will download the latest database from [MaxMind](https://www.maxmind.com/en/geoip2-services-and-databases) prior to starting the API server.

Endpoint: `127.0.0.1:8000/lookup/{ip_addr}`

The MaxMind database is updated every couple of weeks. To quickly demonstrate that our deployment can automatically update the MaxMind database and restart the API server, a Kubernetes cronjob resource restarts the pods every 5 minutes. This is done using `kubectl rollout restart deployment/geoip-deployment`. Note: the default service account does not have permissions to restart a deployment, therefore a `ServiceAccount`, `Role` and `RoleBinding` are used to enable this feature.

## Prerequisites

* [Docker for Desktop](https://www.docker.com/products/docker-desktop/)

## How to run

`make deploy` - will run `kubectl apply -f kube-geoip.yaml`, wait for the pods to be in `Ready` state and then start port-forwarding

`make test` - will test a couple of curl commands against the API, checking valid and invalid IPs
