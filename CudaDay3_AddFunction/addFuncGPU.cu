#include "Header.h"

__global__ void add_function_GPU(float* a, float* b, float* c, int N)
{
	// 对于当前线程所在的网格块，这个网格块在网格中的索引
	int block_id = blockIdx.x + blockIdx.y * gridDim.x + blockIdx.z * gridDim.x * gridDim.y;

	// 对于当前线程，由于网格块索引带来的线程总数，以及当前线程在当前网格块中的索引
	int thread_id = (block_id * blockDim.x * blockDim.y * blockDim.z)
		+ (threadIdx.x + threadIdx.y * blockDim.x + threadIdx.z * blockDim.x * blockDim.y);

	if (thread_id < N)
	{
		c[thread_id] = a[thread_id] + b[thread_id];

		//printf("Block(%d %d %d) = %d || Thread(%d %d %d) = %d %f %f %f\n", blockIdx.x, blockIdx.y, blockIdx.z, block_id,
		//	threadIdx.x, threadIdx.y, threadIdx.z, thread_id, a[thread_id], b[thread_id], c[thread_id]);
	}
}