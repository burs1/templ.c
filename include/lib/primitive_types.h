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
*/

/*
  @file include/lib/primitive_types.h
  @brief Primitive type definitions and constants
  @author Ilya Buravov (ilburale@gmail.com)
  @details This header file provides convenient type aliases and constants for
          primitive data types. It includes standard integer types with shorter
          names and their corresponding min/max constants for easier usage.
*/

#pragma once

#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/** @name Unsigned Integer Maximum Values */
/** @{ */
#define U8_MAX  UINT8_MAX  /**< Maximum value for 8-bit unsigned integer */
#define U16_MAX UINT16_MAX /**< Maximum value for 16-bit unsigned integer */
#define U32_MAX UINT32_MAX /**< Maximum value for 32-bit unsigned integer */
#define U64_MAX UINT64_MAX /**< Maximum value for 64-bit unsigned integer */
/** @} */

/** @name Signed Integer Minimum Values */
/** @{ */
#define I8_MIN  INT8_MIN  /**< Minimum value for 8-bit signed integer */
#define I16_MIN INT16_MIN /**< Minimum value for 16-bit signed integer */
#define I32_MIN INT32_MIN /**< Minimum value for 32-bit signed integer */
#define I64_MIN INT64_MIN /**< Minimum value for 64-bit signed integer */
/** @} */

/** @name Signed Integer Maximum Values */
/** @{ */
#define I8_MAX  INT8_MAX  /**< Maximum value for 8-bit signed integer */
#define I16_MAX INT16_MAX /**< Maximum value for 16-bit signed integer */
#define I32_MAX INT32_MAX /**< Maximum value for 32-bit signed integer */
#define I64_MAX INT64_MAX /**< Maximum value for 64-bit signed integer */
/** @} */

/** @name Unsigned Integer Type Aliases */
/** @{ */
typedef uint8_t  u8;  /**< 8-bit unsigned integer type */
typedef uint16_t u16; /**< 16-bit unsigned integer type */
typedef uint32_t u32; /**< 32-bit unsigned integer type */
typedef uint64_t u64; /**< 64-bit unsigned integer type */
/** @} */

/** @name Signed Integer Type Aliases */
/** @{ */
typedef int8_t  i8;  /**< 8-bit signed integer type */
typedef int16_t i16; /**< 16-bit signed integer type */
typedef int32_t i32; /**< 32-bit signed integer type */
typedef int64_t i64; /**< 64-bit signed integer type */
/** @} */

/** @name Floating Point Type Aliases */
/** @{ */
typedef float  f32; /**< 32-bit floating point type */
typedef double f64; /**< 64-bit floating point type */
/** @} */
