deploy:
	kubectl apply -f kube-geoip.yaml
	kubectl wait --for=condition=ready pod geoip
	kubectl port-forward geoip 8000:8000

clean:
	kubectl delete -f kube-geoip.yaml