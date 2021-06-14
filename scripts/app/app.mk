GO_ARGS := GOOS=linux GO111MODULE=on GOPROXY=direct GOSUMDB=off

GOPATH := $(shell go env GOPATH)

.app-build-dir:
	mkdir -p /app/build

HYDROXIDE_PKG := github.com/emersion/hydroxide/cmd/hydroxide@v0.2.18
hydroxide-linux-amd64: .app-build-dir
	$(GO_ARGS) GOARCH=amd64 go get $(HYDROXIDE_PKG)
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-armv6: .app-build-dir
	$(GO_ARGS) GOARCH=arm GOARM=6 go get $(HYDROXIDE_PKG)
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-armv7: .app-build-dir
	$(GO_ARGS) GOARCH=arm GOARM=7 go get $(HYDROXIDE_PKG)
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;

hydroxide-linux-arm64: .app-build-dir
	$(GO_ARGS) GOARCH=arm64 go get $(HYDROXIDE_PKG)
	find $(GOPATH)/bin -name 'hydroxide' -exec mv {} /app/build/$@ \;


KUBEVAL_PKG := github.com/instrumenta/kubeval@0.16.3
kubeval-linux-amd64: .app-build-dir
	$(GO_ARGS) GOARCH=amd64 go get $(KUBEVAL_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv6: .app-build-dir
	$(GO_ARGS) GOARCH=arm GOARM=6 go get $(KUBEVAL_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv7: .app-build-dir
	$(GO_ARGS) GOARCH=arm GOARM=7 go get $(KUBEVAL_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-arm64: .app-build-dir
	$(GO_ARGS) GOARCH=arm64 go get $(KUBEVAL_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;
