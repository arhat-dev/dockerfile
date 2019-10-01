.build_dir:
	mkdir -p build

rust: .build_dir
	cargo build --release
	mv target/release/rust build/rust

build-image:
	docker build -t sample-rust:latest .
