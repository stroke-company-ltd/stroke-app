
# Getting started with development
## Setup rust (required)
### Add Rust Compile Targets
```bash 
rustup target add \
  aarch64-linux-android \
  armv7-linux-androideabi \
  x86_64-linux-android \
  i686-linux-android
```

### Install required crates
```bash
  cargo install cargo-ndk --version ^2.7.0
```
```bash
  cargo install flutter_rust_bridge_codegen
```
```bash
  cargo install cargo-xcode
```

## Install Android NDK (required)
 - Open Android Studio
 - Goto Android Studio > SDK Manager > SDK Tools
 - Install *NDK (Side by Side)*
 - Find Android NDK location  
   - On linux (one of the following):
     - *$ANDROID_SDK/ndk*
     - *$ANDROID_SDK/ndk_bundle*
 - Setup ANDROID_NDK Gradle Property
   ```bash
    echo "ANDROID_NDK"=(path-to-ndk) >> ~/.gradle/gradle.properties
   ```
   Note that, (path-to-ndk) must be the full path without home abbreviation (~/) !

## Git Configuration (optional)
```bash 
git config pull.rebase true
```
```bash 
git config submodule.recurse true
```

## Generating rust bridge code.
### Install just.
see https://github.com/casey/just for Installtion instruction.
### Generate bridge code.
goto root directory of repo.
```
just
```
that's it.

### Troubleshooting
#### Ensure that CPATH is a enviroment variable. (required to generate rust bridge)
```bash
export CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include"
```

