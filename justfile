default: gen lint

gen:
    flutter pub get
    flutter_rust_bridge_codegen \
        --llvm-path /usr/local/opt/llvm/bin \
        --rust-crate-dir native \
        -r native/src/api.rs \
        -d lib/bridge_generated.dart \
        -c ios/Runner/bridge_generated.h \
        -e macos/Runner/ \
        --dart-decl-output lib/bridge_definitions.dart \
        --wasm

lint:
    cargo fmt
    dart format .

clean:
    flutter clean
    cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

# vim:expandtab:sw=4:ts=4
