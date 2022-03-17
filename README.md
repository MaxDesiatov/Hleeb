[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://vshymanskyy.github.io/StandWithUkraine/)

## Swift running on bare metal Raspberry Pi 2

Hleeb (Ukrainian "хліб" for "bread") is collection of sample code allowing to run trivial Swift functions on bare
metal Raspberry Pi 2, aspiring to become an OS kernel in some distant future.

But Swift already runs on Raspberry Pi, what's the big deal?

Existing port of Swift to Raspberry Pi runs in Linux user space, relying on the Linux kernel for memory management
and I/O. With Hleeb we're trying to implement foundations of an OS kernel from scratch, utilizing Swift for it as
much as possible.

## Requirements

Hleeb relies on [uSwift](https://github.com/compnerd/uswift) as a minimalistic replacement for the Swift standard
library. Additionally, [a patch enabling bare metal targets](https://github.com/swiftwasm/swift/pull/4374) is
required for the Swift toolchain to compile Hleeb.

On macOS the requirements can be installed with [Homebrew](https://brew.sh) by executing `brew bundle` in the root
directory of a clone of this repository.

## How to build

### Building a Swift toolchain for bare metal development

0. Make sure you have at least 20-50 GB of free storage for the toolchain build. 8 GB is the minimal amount of RAM,
16 GB is recommended. This was tested on macOS Big Sur with Xcode 13.2, earlier versions may work but weren't tested.
Building on Linux may work, but may need to adjust these steps accordingly.

1. Create a `swift-source` directory for the toolchain build in your working directory and navigate to it:

```
mkdir swift-source
cd swift-source
```

2. Clone `maxd/baremetal` branch of [this Swift toolchain fork](https://github.com/swiftwasm/swift/pull/4374).
   The patch is currently hosted in the SwiftWasm repository since bare metal target is just as useful when developing
   for WebAssembly:

```
git clone https://github.com/swiftwasm/swift.git
cd swift
git checkout maxd/baremetal
```

3. Build the toolchain (this may take up to an hour on MacBook Air M1 or more an older hardware):

```
./utils/webassembly/ci.sh && cd ../..
```

### Building Hleeb

1. Clone [uSwift](https://github.com/compnerd/uswift) in your working directory:

```
git clone https://github.com/compnerd/uswift.git
```

2. Clone Hleeb directory on the same level as uSwift, it has to be adjacent. This directory structure is important,
   since Hleeb symlinks the uSwift repository. We may consider converting this setup to use git submodules in the future.

```
git clone https://github.com/MaxDesiatov/Hleeb.git
```

3. Build with CMake and Ninja, we're using `LLVM_BIN` points to LLVM installed on M1, you may need to adjust this path
   if you're building on Intel. You also need to adjust `SWIFT_BIN` to the path of your freshly built Swift toolchain
   with bare metal support:

```
cmake -B build -DLLVM_BIN=/opt/homebrew/opt/llvm/bin/ \
  -DSWIFT_BIN=<your_bare_metal_swift_toolchain_bin_path> \
  -DCMAKE_TOOLCHAIN_FILE=./toolchain-arm-none-eabi.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -G Ninja -S . && \
ninja -C build
```

### Testing Hleeb

Run `./test.sh` after a successful build. This will execute the newly built "kernel" in QEMU emulating Raspberry Pi 2.
You should see the following output:

```
42
Hello, kernel World!
```

Number 42 is computed with Swift code as a sum of numbers 40 and 2, called from the C code. Eventually we'd like
to rewrite remaining C code that controls [UART](https://en.wikipedia.org/wiki/UART) in Swift, as soon as pointer
types are fully working in uSwift.

For now we're leaving testing procedure on real RPi hardware as an exercise for the reader. See [this 
tutorial](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials#-usb-serial-output) for more details on
USB serial output, which is currently the only way to get output from Hleeb when running on real hardware.

## Acknowledgments and educational resources

- [Fork of apple/swift with modifications to the stdlib to use in a bare metal kernel](https://github.com/spevans/swift-kstdlib)
- [OSDev.org Wiki](https://wiki.osdev.org/Main_Page)
- [Learn to write an embedded OS in Rust](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials)
- [earning operating system development using Linux kernel and Raspberry Pi](https://github.com/s-matyukevich/raspberry-pi-os)

## License

Where not stated otherwise, Hleeb is available under the Apache 2.0 license.
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the [LICENSE](https://github.com/swiftwasm/Tokamak/blob/main/LICENSE) file for
more info.

This repository also incorporates code available under BSD-3 and MIT licenses, which is specified in headers of
corresponding files.
