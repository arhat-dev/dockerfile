#!/bin/bash

set -ex

# ref: https://gitlab.com/gitlab-org/build/CNG/-/raw/master/shared/build-scripts/cleanup-gems

ruby_dir=${1:-"vendor/bundle/ruby"}

# exclude rubygems build cache
rm -rf "${ruby_dir}"/*/cache

# exclude test and some vendor folders
rm -rf \
  "${ruby_dir}"/*/gems/*/spec \
  "${ruby_dir}"/*/gems/*/test \
  "${ruby_dir}"/*/gems/*/tests

# Some vendor folders (e.g. licensee) are needed by GitLab.
# For now, exclude the most space-consuming gems until
# there's a better way to whitelist directories.
rm -rf \
  "${ruby_dir}"/*/gems/rugged*/vendor \
  "${ruby_dir}"/*/gems/libyajl2*/**/vendor

# ACE editor includes a bundle of Javascrip contents (13M)
# Commented here, because these sources are needed for asset compilation
#rm -rf \
#  "${ruby_dir}"/*/gems/ace-rails*/vendor \

# exclude gem build logs
rm -rf \
  "${ruby_dir}"/*/extensions/*/*/*/mkmf.log \
  "${ruby_dir}"/*/extensions/*/*/*/gem_make.out

# exclude C sources
rm -rf \
  "${ruby_dir}"/*/gems/*/ext/*.c \
  "${ruby_dir}"/*/gems/*/ext/*/*.c \
  "${ruby_dir}"/*/gems/*/ext/*.o \
  "${ruby_dir}"/*/gems/*/ext/*/*.o

# exclude other gem files
rm -rf \
  "${ruby_dir}"/*/gems/*/*.gemspec \
  "${ruby_dir}"/*/gems/*/*.md \
  "${ruby_dir}"/*/gems/*/*.rdoc \
  "${ruby_dir}"/*/gems/*/*.sh \
  "${ruby_dir}"/*/gems/*/*.txt \
  "${ruby_dir}"/*/gems/*/*LICENSE* \
  "${ruby_dir}"/*/gems/*/CHANGES* \
  "${ruby_dir}"/*/gems/*/Gemfile \
  "${ruby_dir}"/*/gems/*/Guardfile \
  "${ruby_dir}"/*/gems/*/README* \
  "${ruby_dir}"/*/gems/*/Rakefile \
  "${ruby_dir}"/*/gems/*/run_tests.rb \
  "${ruby_dir}"/*/gems/*/Documentation \
  "${ruby_dir}"*/gems/*/bench \
  "${ruby_dir}"/*/gems/*/contrib \
  "${ruby_dir}"/*/gems/*/doc \
  "${ruby_dir}"/*/gems/*/doc-api \
  "${ruby_dir}"/*/gems/*/examples \
  "${ruby_dir}"/*/gems/*/fixtures \
  "${ruby_dir}"/*/gems/*/gemfiles \
  "${ruby_dir}"/*/gems/*/libtest \
  "${ruby_dir}"/*/gems/*/man \
  "${ruby_dir}"/*/gems/*/sample_documents \
  "${ruby_dir}"/*/gems/*/samples \
  "${ruby_dir}"/*/gems/*/sample \
  "${ruby_dir}"/*/gems/*/script \
  "${ruby_dir}"/*/gems/*/t

# Exclude additional test files from specific gems
rm -rf \
  "${ruby_dir}"/*/gems/grpc-*/src/ruby/spec

find "${ruby_dir}" -name '*.gem' -type f -print -delete
find "${ruby_dir}"/*/gems -name 'doc' -type d -print -exec rm -r {} +
