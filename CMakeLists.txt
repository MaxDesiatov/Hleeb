#   Part of the Raspberry-Pi Bare Metal Tutorials
#   https://www.valvers.com/rpi/bare-metal/
#   Copyright (c) 2013, Brian Sidebotham

#   This software is licensed under the MIT License.
#   Please see the LICENSE file included with this software.

# CMake build environment for the Valvers Raspberry-Pi bare metal tutorials

# CMake 2.8.10 Documentation: http://www.cmake.org/cmake/help/v2.8.10/cmake.html

cmake_minimum_required(VERSION 3.18)

# Mark the language as C so that CMake doesn't try to test the C++
# cross-compiler's ability to compile a simple program because that will fail
project(Hleeb C ASM Swift)

add_subdirectory(uswift)
add_subdirectory(Sources)
