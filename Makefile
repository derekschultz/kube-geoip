deploy:
	kubectl apply -f kube-geoip.yaml
	kubectl wait --for=condition=ready pod -l app=geoip
	kubectl port-forward $$(kubectl get pods -l app=geoip -o=jsonpath='{.items[0].metadata.name}') 8000:8000

forward:
	kubectl port-forward $$(kubectl get pods -l app=geoip -o=jsonpath='{.items[0].metadata.name}') 8000:8000

clean:
	kubectl delete -f kube-geoip.yaml