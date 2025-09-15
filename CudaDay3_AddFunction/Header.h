#pragma once

// CPU
#include <stdio.h>
#include <stdlib.h>
#include <chrono> // clock

void add_function_CPU(float* a, float* b, float* c, int N);

// GPU
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#define BlockSize 256 // total thread within a Block

__global__ void add_function_GPU(float* a, float* b, float* c, int N);

