add_executable(example main.c)
target_link_libraries(example PRIVATE mylib)
target_compile_options(example PRIVATE ${MYLIB_COMPILE_OPTIONS})