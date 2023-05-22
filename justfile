default: gen lint

gen:
    flutter pub get
    flutter_rust_bridge_codegen \
        --llvm-path /usr/local/opt/llvm/bin \
        --rust-input native/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h \
        --dart-decl-output lib/bridge_definitions.dart

    cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h

lint:
    cd native && cargo fmt
    dart format .

clean:
    flutter clean
    cd native && cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

# vim:expandtab:sw=4:ts=4
