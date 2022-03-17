add_subdirectory(KernelKit)

add_executable(kernel.elf
  kernel.c
  boot.S
)

add_dependencies(kernel.elf KernelKit)

target_compile_options(kernel.elf PUBLIC $<$<COMPILE_LANGUAGE:C>:-fpic -ffreestanding -std=gnu99 -O2 -Wall -Wextra>)
target_compile_options(kernel.elf PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-fpic -ffreestanding>)
target_link_libraries(kernel.elf PUBLIC "-nostdlib -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld ${CMAKE_CURRENT_BINARY_DIR}/KernelKit/sum.o")
