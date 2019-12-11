GO_ARGS := GOOS=linux GO111MODULE=on GOPROXY=direct GOSUMDB=off

GOPATH := $(shell go env GOPATH)

HYDROXIDE_PKG := github.com/emersion/hydroxide/cmd/hydroxide@v0.2.11
hydroxide-linux-amd64:
	$(GO_ARGS) GOARCH=amd64 go get $(HYDROXIDE_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-armv6:
	$(GO_ARGS) GOARCH=arm GOARM=6 go get $(HYDROXIDE_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-armv7:
	$(GO_ARGS) GOARCH=arm GOARM=7 go get $(HYDROXIDE_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-arm64:
	$(GO_ARGS) GOARCH=arm64 go get $(HYDROXIDE_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;


KUBEVAL_PKG := github.com/instrumenta/kubeval@0.14.0
kubeval-linux-amd64:
	$(GO_ARGS) GOARCH=amd64 go get $(KUBEVAL_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv6:
	$(GO_ARGS) GOARCH=amd64 go get $(KUBEVAL_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv7:
	$(GO_ARGS) GOARCH=amd64 go get $(KUBEVAL_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-arm64:
	$(GO_ARGS) GOARCH=amd64 go get $(KUBEVAL_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;


CONFTEST_PKG := github.com/instrumenta/conftest@v0.15.0
conftest-linux-amd64:
	$(GO_ARGS) GOARCH=amd64 go get $(CONFTEST_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'conftest' -exec mv {} /app/build/$@ \;

conftest-linux-armv6:
	$(GO_ARGS) GOARCH=amd64 go get $(CONFTEST_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'conftest' -exec mv {} /app/build/$@ \;

conftest-linux-armv7:
	$(GO_ARGS) GOARCH=amd64 go get $(CONFTEST_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'conftest' -exec mv {} /app/build/$@ \;

conftest-linux-arm64:
	$(GO_ARGS) GOARCH=amd64 go get $(CONFTEST_PKG)
	mkdir -p /app/build/
	find $(GOPATH)/bin -name 'conftest' -exec mv {} /app/build/$@ \;
