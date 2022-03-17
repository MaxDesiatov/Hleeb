add_custom_command(
  OUTPUT sum.o
  COMMAND ${CMAKE_Swift_COMPILER} -target arm-unknown-none-eabi -I ${CMAKE_BINARY_DIR}/swift -c ${CMAKE_CURRENT_SOURCE_DIR}/sum.swift -o sum.o
  COMMAND ${CMAKE_STRIP} --remove-section=.ARM.exidx --strip-symbol=__aeabi_unwind_cpp_pr0 ${CMAKE_CURRENT_BINARY_DIR}/sum.o
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

add_custom_target(KernelKit DEPENDS sum.o)
add_dependencies(KernelKit swiftCore)
add_dependencies(KernelKit swiftOnoneSupport)
