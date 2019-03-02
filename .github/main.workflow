workflow "build_images" {
  on = "push"
  resolves = [
    "push go-builder",
    "push go-scratch",
    "push go-alpine",
  ]
}

action "login @docker_hub" {
  uses = "actions/docker/login@master"
  secrets = [
    "DOCKER_PASSWORD",
    "DOCKER_USERNAME",
  ]
}

# 
# Builders
# 

action "build go-builder" {
  uses = "actions/docker/cli@master"
  args = "build -t arhatdev/go-builder:onbuild -f builder/go-builder.dockerfile ."
}

action "push go-builder" {
  needs = ["build go-builder", "login @docker_hub"]
  uses = "actions/docker/cli@master"
  args = "push arhatdev/go-builder:onbuild"
}

# 
# Containers
# 

action "build go-scratch" {
  needs = "build go-builder"
  uses = "actions/docker/cli@master"
  args = "build -t arhatdev/go-scratch:onbuild -f container/go-scratch.dockerfile ."
}

action "push go-scratch" {
  needs = ["build go-scratch", "login @docker_hub"]
  uses = "actions/docker/cli@master"
  args = "push arhatdev/go-scratch:onbuild"
}

action "build go-alpine" {
  needs = "build go-builder"
  uses = "actions/docker/cli@master"
  args = "build -t arhatdev/go-alpine:onbuild -f container/go-alpine.dockerfile ."
}

action "push go-alpine" {
  needs = ["build go-alpine", "login @docker_hub"]
  uses = "actions/docker/cli@master"
  args = "push arhatdev/go-alpine:onbuild"
}