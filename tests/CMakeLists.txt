#=============================================================================
# TESTS CONFIGURATION
#=============================================================================
# Find Google Test
find_package(GTest QUIET)
if(NOT GTest_FOUND)
  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
    DOWNLOAD_EXTRACT_TIMESTAMP true
  )
  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
endif()



# Test source files
set(TEST_SOURCE_FILES
  test_main.cpp
  # add new test source files here...
)

# Create test executable
add_executable(test_mylib ${TEST_SOURCE_FILES})

# Link with the main library and Google Test using official targets
target_link_libraries(test_mylib PRIVATE 
  mylib
  GTest::gtest_main
)

# Apply same compile options as the main library
target_compile_options(test_mylib PRIVATE ${MYLIB_COMPILE_OPTIONS})

# Set target properties
set_target_properties(test_mylib PROPERTIES
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
    C_EXTENSIONS OFF
)

# Include Google Test module and discover tests automatically
include(GoogleTest)
gtest_discover_tests(test_mylib)

# Enable code coverage for tests if requested
if(MYLIB_ENABLE_COVERAGE AND CMAKE_BUILD_TYPE STREQUAL "Debug")
  if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
    target_compile_options(test_mylib PRIVATE --coverage)
    target_link_libraries(test_mylib PRIVATE --coverage)
    message(STATUS "Code coverage enabled for tests")
  endif()
endif()
