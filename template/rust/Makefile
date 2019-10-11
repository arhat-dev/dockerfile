.build_dir:
	mkdir -p build

rust: .build_dir
	cargo build --release
	cp target/release/rust build/rust
	strip build/rust

build-image:
	docker build -t sample-rust:latest .
