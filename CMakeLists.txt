cmake_minimum_required(VERSION 3.16)

#=============================================================================
# PROJECT CONFIGURATION
#=============================================================================
# Basic project setup, versioning, and testing framework initialization
project(
  "mylib"
  VERSION 0.1.0
  DESCRIPTION "A C library."
  LANGUAGES C
)

#-----------------------------------------------------------------------------
# BUILD MODE DETECTION
#-----------------------------------------------------------------------------
# Detect if this is a standalone build or being included as a subdirectory
string(
  COMPARE EQUAL
  "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_SOURCE_DIR}"
  MYLIB_IS_STANDALONE_BUILD
)


#-----------------------------------------------------------------------------
# COMPILER-SPECIFIC SETTINGS
#-----------------------------------------------------------------------------
# Configure compiler flags and options for GCC/Clang toolchains
set(MYLIB_DEFAULT_BUILD_TYPE "Debug")

set(MYLIB_COMPILE_OPTIONS
  -Wall
  -Wextra
  -Wpedantic

  -Wno-gnu-zero-variadic-macro-arguments
  # add new clang or gnu compile options here...
)

#-----------------------------------------------------------------------------
# CMAKE GLOBAL SETTINGS
#-----------------------------------------------------------------------------
# Set global CMake behavior, C standard, and build system options
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_USE_RELATIVE_PATHS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ${MYLIB_IS_STANDALONE_BUILD})

#-----------------------------------------------------------------------------
# PROJECT OPTIONS
#-----------------------------------------------------------------------------
# Include user-configurable build options
include(CMakeOptions.txt)

#-----------------------------------------------------------------------------
# BUILD TYPE CONFIGURATION
#-----------------------------------------------------------------------------
# Set default build type for standalone builds
if (MYLIB_IS_STANDALONE_BUILD AND CMAKE_BUILD_TYPE STREQUAL "")
  message("${PROJECT_NAME} | warn: Build type wasn't specified. Automatically set to \"${MYLIB_DEFAULT_BUILD_TYPE}\".")
  set(CMAKE_BUILD_TYPE ${MYLIB_DEFAULT_BUILD_TYPE})
endif()


#-----------------------------------------------------------------------------
# BUILD INFORMATION DISPLAY
#-----------------------------------------------------------------------------
# Print project information and configuration summary
include(CMakeInfo.txt)

#-----------------------------------------------------------------------------
# SOURCE FILES CONFIGURATION
#-----------------------------------------------------------------------------
# Define source files for the library
set(MYLIB_SOURCE_FILES
  src/main.c
  # add new source files here...
)

#=============================================================================
# LIBRARY TARGET CREATION
#=============================================================================
# Create the main library target with appropriate configuration
if(MYLIB_BUILD_SHARED)
  add_library(mylib SHARED ${MYLIB_SOURCE_FILES})
  target_compile_definitions(mylib PUBLIC __MYLIB_SHARED__)
  target_compile_definitions(mylib PRIVATE __MYLIB_EXPORT__)
else()
  add_library(mylib STATIC ${MYLIB_SOURCE_FILES})
endif()

target_include_directories(mylib PUBLIC include)
target_include_directories(mylib PRIVATE .)

target_compile_options(mylib PRIVATE ${MYLIB_COMPILE_OPTIONS})

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  target_compile_definitions(mylib PUBLIC __MYLIB_DEBUG__)
endif()

if(MYLIB_BUILD_EXAMPLE)
  add_subdirectory(example)
endif()

if(MYLIB_BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()
