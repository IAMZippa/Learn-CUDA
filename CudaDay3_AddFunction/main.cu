#include "Header.h"

// 版本：Visual Studio 2019 + CUDA 11.8

int main()
{
	int N = 100000000; // size of float 

	// 1.1 alloc memory in CPU
	float* h_a = (float*)malloc(N * sizeof(float));
	float* h_b = (float*)malloc(N * sizeof(float));
	float* h_c = (float*)malloc(N * sizeof(float));

	// 1.2 initialize memory in CPU
	for (int i = 0; i < N; i++)
	{
		h_a[i] = i;
		h_b[i] = i;
	}

	// 2.1 alloc memory in GPU
	float* d_a, *d_b, *d_c;
	cudaMalloc(&d_a, N * sizeof(float)); // 注意这个语法，不要用错了
	cudaMalloc(&d_b, N * sizeof(float));
	cudaMalloc(&d_c, N * sizeof(float));

	// 2.2 copy memory from CPU to GPU
	cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, N * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, h_c, N * sizeof(float), cudaMemcpyHostToDevice);

	// 3 run function in GPU
	int blockPerGrid = (N + BlockSize - 1) / BlockSize;

	add_function_GPU<<<blockPerGrid, BlockSize >>> (d_a, d_b, d_c, N);
	cudaDeviceSynchronize(); // do remember to Synchronize

	// 3.1 copy memory from GPU to CPU
	cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);

	// 3.2 Compare GPU and CPU Results
	for (int i = 0; i < N; i++)
	{
		int h_c_CPU = h_a[i] + h_b[i];
		if (h_c[i] != h_c_CPU)
		{
			printf("Error!");
		}
	}
	printf("Same results between CPU and GPU\n");

	// let's see the running time between CPU and GPU
	{
		auto start = std::chrono::high_resolution_clock::now();  // 开始计时

		for (int istep = 0; istep < 20; istep++)
		{
			add_function_CPU(h_a, h_b, h_c, N);
		}

		auto end = std::chrono::high_resolution_clock::now();  // 结束计时
		std::chrono::duration<double> elapsed = end - start;   // 计算时间差
		// 输出当前步的执行时间
		printf("CPU exeTime %f seconds \n", elapsed.count());
	}

	{
		auto start = std::chrono::high_resolution_clock::now();  // 开始计时

		for (int istep = 0; istep < 20; istep++)
		{
			add_function_GPU << <blockPerGrid, BlockSize >> > (d_a, d_b, d_c, N);
			cudaDeviceSynchronize();
		}

		auto end = std::chrono::high_resolution_clock::now();  // 结束计时
		std::chrono::duration<double> elapsed = end - start;   // 计算时间差
		// 输出当前步的执行时间
		printf("GPU exeTime %f seconds \n", elapsed.count());
	}

	// 4
	cudaFree(d_a);
	cudaFree(d_a);
	cudaFree(d_a);

	free(h_a);
	free(h_b);
	free(h_c);
}


