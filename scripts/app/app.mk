GO_ARGS := GOOS=linux GO111MODULE=on GOPROXY=direct GOSUMDB=off

HYDROXIDE_PKG := github.com/emersion/hydroxide/cmd/hydroxide@v0.2.11
GOPATH := $(shell go env GOPATH)

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
