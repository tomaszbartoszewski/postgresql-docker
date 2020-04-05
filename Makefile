build_test_image:
	cd tests_docker; \
	docker build -f ./Dockerfile . -t pgtap-tester:latest

tests:
	./tests_runner.sh

.PHONY: build_test_image tests