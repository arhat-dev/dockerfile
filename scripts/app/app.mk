export GO111MODULE=on
export GOPROXY=direct
export GOSUMDB=off

GO_GET := GOOS=linux go get -tags='netgo'

GOPATH := $(shell go env GOPATH)

.app-build-dir:
	mkdir -p /app/build

KUBEVAL_CMD_PKG := github.com/instrumenta/kubeval@v0.16.1
kubeval-linux-amd64: .app-build-dir
	GOARCH=amd64 \
		$(GO_GET) $(KUBEVAL_CMD_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv6: .app-build-dir
	GOARCH=arm GOARM=6 \
		$(GO_GET) $(KUBEVAL_CMD_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-armv7: .app-build-dir
	GOARCH=arm GOARM=7 \
		$(GO_GET) $(KUBEVAL_CMD_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;

kubeval-linux-arm64: .app-build-dir
	GOARCH=arm64 \
		$(GO_GET) $(KUBEVAL_CMD_PKG)
	find $(GOPATH)/bin -name 'kubeval' -exec mv {} /app/build/$@ \;
