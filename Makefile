.PHONY: all
all: check test build

.PHONY: check
check: ## Lint code
	gofmt -s -l $(shell go list -f '{{ .Dir }}' ./... ) | grep ".*\.go"; if [ "$$?" = "0" ]; then exit 1; fi
	go vet ./cmd/... ./pkg/...

format:
	gofmt -s -w $(shell go list -f '{{ .Dir }}' ./... )
.PHONY: format

.PHONY: build
build: ## Build binary
	go build -v -o ci-operator ./cmd/ci-operator
	go build -v -o ci-operator-checkconfig ./cmd/ci-operator-checkconfig

.PHONY: install
install: ## Install binary
	go install ./cmd/ci-operator
	go install ./cmd/ci-operator-checkconfig

.PHONY: test
test: ## Run tests
	go test ./...

.PHONY: help
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
