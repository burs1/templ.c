# Testing

This directory contains the test suite for the library using Check framework.

## Running Tests

### Building and Running Tests

```bash
# Build with tests enabled
cmake -DMYLIB_BUILD_TESTS=ON ..
make

# Run tests using CTest (recommended)
ctest --verbose

# Or run tests directly
./test_main
```

### Test Options

The project supports several CMake options for testing:

| Option | Default | Description |
|--------|---------|-------------|
| `MYLIB_BUILD_TESTS` | `ON` (standalone) | Build test programs |
| `MYLIB_ENABLE_COVERAGE` | `OFF` | Enable code coverage (requires Debug build) |

### Check Framework Options

Check provides command-line options for test execution:

```bash
# Run tests with detailed output
./test_main -v

# Run tests in fork mode (default)
./test_main -f

# Run tests in no-fork mode
./test_main -n

# Run specific test suite
./test_main -s MyLibBasicTest
```

### Code Coverage

When `MYLIB_ENABLE_COVERAGE=ON` and build type is `Debug`, code coverage is automatically enabled for tests.

## Test Structure

- `test_main.c` - Main test file with Check test cases
- Add new test files as needed
