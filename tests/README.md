# Testing

This directory contains the test suite for the library using Google Test framework.

## Running Tests

### Prerequisites

- CMake 3.16 or higher
- C99 compatible compiler (GCC, Clang, MSVC)
- CTest (comes with CMake)
- Google Test (automatically downloaded if not found)

### Building and Running Tests

```bash
# Build with tests enabled
cmake -DMYLIB_BUILD_TESTS=ON ..
make

# Run tests using CTest (recommended)
ctest --verbose

# Or run tests directly with Google Test options
./test_mylib --gtest_verbose
./test_mylib --gtest_filter="*Basic*"  # Run only tests matching pattern
```

### Test Options

The project supports several CMake options for testing:

| Option | Default | Description |
|--------|---------|-------------|
| `MYLIB_BUILD_TESTS` | `ON` (standalone) | Build test programs |
| `MYLIB_ENABLE_COVERAGE` | `OFF` | Enable code coverage (requires Debug build) |

### Google Test Options

Google Test provides many command-line options for test execution:

```bash
# Run specific test suites
./test_mylib --gtest_filter="MyLibBasicTest.*"

# Run tests with detailed output
./test_mylib --gtest_verbose

# Run tests in random order
./test_mylib --gtest_shuffle

# Stop on first failure
./test_mylib --gtest_break_on_failure

# List all available tests
./test_mylib --gtest_list_tests
```

### Code Coverage

When `MYLIB_ENABLE_COVERAGE=ON` and build type is `Debug`, code coverage is automatically enabled for tests.

## Test Structure

- `test_main.c` - Main test file with Google Test test cases
- Add new test files as needed
- Update `CMakeLists.txt` to include new test source files

## Test Framework

The tests use Google Test framework with comprehensive assertion macros:

### Basic Assertions
```c
EXPECT_EQ(expected, actual);     // Equal
EXPECT_NE(val1, val2);          // Not equal
EXPECT_TRUE(condition);         // True
EXPECT_FALSE(condition);        // False
```

### String Assertions
```c
EXPECT_STREQ(str1, str2);       // String equal
EXPECT_STRNE(str1, str2);       // String not equal
EXPECT_STRCASEEQ(str1, str2);   // Case-insensitive string equal
```

### Floating Point Assertions
```c
EXPECT_FLOAT_EQ(val1, val2);    // Float equal
EXPECT_DOUBLE_EQ(val1, val2);   // Double equal
EXPECT_NEAR(val1, val2, abs_error); // Near with tolerance
```

### Comparison Assertions
```c
EXPECT_LT(val1, val2);          // Less than
EXPECT_LE(val1, val2);          // Less than or equal
EXPECT_GT(val1, val2);          // Greater than
EXPECT_GE(val1, val2);          // Greater than or equal
```

## Adding New Tests

### 1. Test Fixtures (Recommended)

```c
class MyLibFeatureTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Set up test fixtures here
        // Example: mylib_init();
    }

    void TearDown() override {
        // Clean up test fixtures here
        // Example: mylib_cleanup();
    }
};

TEST_F(MyLibFeatureTest, TestSpecificFeature) {
    // Test implementation
    EXPECT_EQ(mylib_function(), expected_result);
}
```

### 2. Simple Tests

```c
TEST(MyLibSimpleTest, TestBasicFunction) {
    // Test implementation
    EXPECT_TRUE(mylib_basic_function());
}
```

### 3. Adding New Test Files

1. Create new test files (e.g., `test_feature.c`)
2. Add them to `TEST_SOURCE_FILES` in `tests/CMakeLists.txt`
3. Implement test cases using Google Test macros
4. No need to modify `main()` - Google Test handles test discovery

### Example Test Structure

```c
#include <gtest/gtest.h>
#include "mylib.h"

class MyLibAdvancedTest : public ::testing::Test {
protected:
    void SetUp() override {
        ASSERT_EQ(mylib_init(), MYLIB_SUCCESS);
    }

    void TearDown() override {
        mylib_cleanup();
    }
};

TEST_F(MyLibAdvancedTest, ComplexOperation) {
    // Test setup
    int result = mylib_complex_function(input);
    
    // Assertions with custom messages
    EXPECT_EQ(result, expected) << "Complex function should return expected value";
    EXPECT_GT(result, 0) << "Result should be positive";
    EXPECT_NEAR(result, 3.14, 0.01) << "Result should be close to pi";
}
```

## Continuous Integration

For CI/CD pipelines, use:

```bash
# Build and test in one command
cmake -DMYLIB_BUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Debug ..
make
ctest --output-on-failure

# Or run with Google Test directly for more control
./test_mylib --gtest_output=xml:test_results.xml
```

## Google Test Features

- **Test Discovery**: Automatically finds and runs all tests
- **Test Fixtures**: SetUp/TearDown for test environment
- **Parameterized Tests**: Run same test with different inputs
- **Death Tests**: Test for crashes and assertions
- **Mocking**: Create mock objects for testing
- **XML Output**: Generate test reports for CI systems
- **Parallel Execution**: Run tests in parallel for speed