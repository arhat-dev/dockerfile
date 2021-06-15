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

PROTON_BRIDGE_VERSION := v1.8.5
.download-proton-bridge-src:
	git clone --branch "${PROTON_BRIDGE_VERSION}" \
		https://github.com/ProtonMail/proton-bridge.git
	sed -i 's/github.com\/docker\/docker-credential-helpers\/secretservice/fmt/g' proton-bridge/pkg/keychain/helper_linux.go
	sed -i 's/return \&secretservice\.Secretservice.*, nil/return nil, fmt\.Errorf\("not supported"\)/g' proton-bridge/pkg/keychain/helper_linux.go

MK_PROTON_BRIDGE := CGO_ENABELD=0 GOOS=linux BUILD_TAGS='netgo' make -C proton-bridge build-nogui
proton-bridge-linux-amd64: .app-build-dir .download-proton-bridge-src
	GOARCH=amd64 \
		$(MK_PROTON_BRIDGE)
	mv proton-bridge/proton-bridge /app/build/$@

proton-bridge-linux-armv6: .app-build-dir .download-proton-bridge-src
	GOARCH=arm GOARM=6 \
		$(MK_PROTON_BRIDGE)
	mv proton-bridge/proton-bridge /app/build/$@

proton-bridge-linux-armv7: .app-build-dir .download-proton-bridge-src
	GOARCH=arm GOARM=7 \
		$(MK_PROTON_BRIDGE)
	mv proton-bridge/proton-bridge /app/build/$@

proton-bridge-linux-arm64: .app-build-dir .download-proton-bridge-src
	GOARCH=arm64 \
		$(MK_PROTON_BRIDGE)
	mv proton-bridge/proton-bridge /app/build/$@
