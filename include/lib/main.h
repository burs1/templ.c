/*
 * Copyright 2025 Ilya Buravov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file include/lib/main.h
 * @brief Main library header file
 * @author Ilya Buravov (ilburale@gmail.com)
 * @details This header file contains the main function declarations for the library.
 *          It serves as a template for the actual library interface.
 *          Includes examples of documenting structures, enums, typedefs, and functions.
 *          Replace the example declarations with your actual library API.
 */

#pragma once

#include "apidef.h"
#include <stdbool.h>
#include <stdint.h>

/**
 * @brief Library status codes
 * @details Defines the possible status codes that library functions can return.
 */
typedef enum
{
  MYLIB_SUCCESS = 0, /**< Operation completed successfully */

  /**
   * @brief Operation failed due to invalid parameters
   * @details This error occurs when one or more parameters passed to the function
   *          are invalid, null, or out of acceptable range. Check parameter values
   *          and ensure they meet the function requirements.
   */
  MYLIB_ERROR_INVALID_PARAMS
} mylib_status_t;

/**
 * @brief Configuration structure for library initialization
 * @details Contains configurable parameters for initializing the library.
 */
typedef struct
{
  uint32_t max_operations; /**< Maximum number of concurrent operations */

  /**
   * @brief Custom callback function
   * @details Optional callback function for custom event handling.
   * @param event_type The type of event that occurred
   * @param user_data User-provided data pointer
   */
  void (*callback) (int event_type, void *user_data);
} mylib_config_t;

/**
 * @brief Handle type for library operations
 * @details Opaque handle type used to reference library objects.
 */
typedef struct mylib_handle mylib_handle_t;

/**
 * @brief Callback function type for operation completion
 * @details Function pointer type for callbacks that are invoked when
 *          asynchronous operations complete.
 * @param result The result of the operation
 * @param user_data User-provided data pointer
 */
typedef void (*mylib_callback_t) (mylib_status_t result, void *user_data);

/**
 * @brief Initialize the library
 * @details Initializes the library with default settings.
 * @return @ref mylib_status_t - MYLIB_SUCCESS on success, error code on failure
 * @since Version 1.0
 */
__MYLIB_API__ mylib_status_t mylib_init (void);

/**
 * @brief Process data with callback
 * @details Processes the provided data and calls the callback function when complete.
 *          The processing is performed asynchronously and the callback will be invoked
 *          from a separate thread when the operation finishes.
 * @param data Pointer to data to process (must not be NULL)
 * @param size Size of data in bytes (must be greater than 0)
 * @param callback Callback function to call when processing is complete
 * @param user_data User data to pass to callback function
 * @return @ref mylib_status_t - MYLIB_SUCCESS on success, error code on failure
 * @note The callback is called asynchronously from a worker thread
 * @warning The data pointer must remain valid until the callback is called
 * @see mylib_callback_t for callback function signature
 * @since Version 1.0
 */
__MYLIB_API__ mylib_status_t mylib_process_data (
  const void *data, size_t size, mylib_callback_t callback, void *user_data
);
