deploy:
	kubectl apply -f kube-geoip.yaml
	kubectl wait --for=condition=ready pod -l app=geoip
	kubectl port-forward $$(kubectl get pods -l app=geoip -o=jsonpath='{.items[0].metadata.name}') 8000:8000

forward:
	kubectl port-forward $$(kubectl get pods -l app=geoip -o=jsonpath='{.items[0].metadata.name}') 8000:8000

clean:
	kubectl delete -f kube-geoip.yaml

docker-build:
	docker build -t bobloblaw/geoip --no-cache .

docker-push:
	docker push bobloblaw/geoip

test:
	@echo "Testing valid IPs..."
	curl 127.0.0.1:8000/lookup/110.111.112.113
	@echo
	curl 127.0.0.1:8000/lookup/8.8.8.8
	@echo
	@echo "Testing invalid IPs..."
	curl 127.0.0.1:8000/lookup/123.456.789.101112
	@echo
	curl 127.0.0.1:8000/lookup/256.256.256.256