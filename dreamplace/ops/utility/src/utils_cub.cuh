/**
 * File              : utils_cub.cuh
 * Author            : Yibo Lin <yibolin@pku.edu.cn>
 * Date              : 06.25.2021
 * Last Modified Date: 06.25.2021
 * Last Modified By  : Yibo Lin <yibolin@pku.edu.cn>
 */

#ifndef _DREAMPLACE_UTILITY_UTILS_CUB_CUH
#define _DREAMPLACE_UTILITY_UTILS_CUB_CUH

#include "utility/src/namespace.h"

// include cub in a safe manner
// CUDA 12.1 uses cuda::std namespace 
// Note: system CUB at /usr/local/cuda/include is used
// Solution: Do NOT use namespace wrapper, use cub directly
#include "cub/cub.cuh"

#endif
