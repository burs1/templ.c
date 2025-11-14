/*
  Copyright 2025 Ilya Buravov

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  @file test_main.c
  @brief Check framework for mylib
  @author Ilya Buravov (ilburale@gmail.com)
  @details This file provides Check framework integration for the library.
          It includes test cases using Check macros and can be extended
          with additional test functions. The framework provides comprehensive
          testing capabilities with detailed output and assertions.
*/

#include <check.h>
#include <stdlib.h>

// Include your library header here
// #include "mylib.h"

/*
  @brief Test suite for basic functionality
  @details This test suite demonstrates how to write test cases using Check.
          It includes basic assertion tests and commented examples for testing
          actual library functions. Add your own test cases here following the
          same pattern.
*/

/*
  @brief Test basic assertion functionality
  @details This test verifies that the basic testing infrastructure is working.
*/
START_TEST (test_basic_assertion)
{
  ck_assert_int_eq (1, 1);
  ck_assert (1 == 1);
  ck_assert (1 != 0);
}
END_TEST

/*
  @brief Test string operations
  @details Example test for string-related functionality.
*/
START_TEST (test_string_operations)
{
  const char *test_string = "Hello, World!";
  ck_assert_ptr_nonnull (test_string);
  ck_assert_str_eq (test_string, "Hello, World!");
  ck_assert_str_ne (test_string, "Goodbye, World!");
}
END_TEST

/*
  @brief Test numeric operations
  @details Example test for numeric functionality.
*/
START_TEST (test_numeric_operations)
{
  int a = 5;
  int b = 3;

  ck_assert_int_eq (a + b, 8);
  ck_assert_int_gt (a, b);
  ck_assert_int_le (b, a);
  ck_assert_double_eq_tol (3.14159, 3.14, 0.01);
}
END_TEST

/*
  @brief Create test suite
  @details Creates and returns a test suite with all test cases.
*/
Suite *mylib_suite (void)
{
  Suite *s;
  TCase *tc_core;

  s = suite_create ("MyLibBasicTest");

  /* Core test case */
  tc_core = tcase_create ("Core");

  tcase_add_test (tc_core, test_basic_assertion);
  tcase_add_test (tc_core, test_string_operations);
  tcase_add_test (tc_core, test_numeric_operations);

  suite_add_tcase (s, tc_core);

  return s;
}

/*
  @brief Main function to run tests
  @details Creates the test suite, runs it, and returns the exit status.
*/
int main (void)
{
  int      number_failed;
  Suite   *s;
  SRunner *sr;

  s  = mylib_suite ( );
  sr = srunner_create (s);

  srunner_run_all (sr, CK_NORMAL);
  number_failed = srunner_ntests_failed (sr);
  srunner_free (sr);

  return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
