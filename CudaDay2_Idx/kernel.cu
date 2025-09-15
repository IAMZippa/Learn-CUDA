#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>


void addfunction(int N, float* h_a, float* h_b, float* h_c)
{
	for (int i = 0; i < N; i++)
	{
		h_c[i] = h_a[i] + h_b[i];
	}
}

int main()
{
	// 1 memory alloc in CPU
	int N = 5;
	float* h_a = new float[N]();
	float* h_b = new float[N]();
	float* h_c = new float[N]();

	// initialize 
	for (int i = 0; i < N; i++)
	{
		h_a[i] = i;
		h_b[i] = i * 2;
		printf("%d %f %f %f\n", i, h_a[i], h_b[i], h_c[i]);
	}





}

