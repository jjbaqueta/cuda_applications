#include <iostream>
#include "book.h"

/*
 * In CUDA the codes can be ran on device (GPU) or host (GPU)
 * the __global__ qualifer defines that the function (kernel) should be compiled to run on device instead of the host
 */
__global__ void kernel(int a, int b, int *c) //in this function we define what will run on device
{
	*c = a + b;
} 

int main(void)
{
	int a = 10, b = 10, host_c;	//variables used by host
	int *device_c;	//variable used by device

	/*
	 * Allocates memory directly on device
	 * argument 1: pointer to the pointer to the memory block that you want to allocate
	 * argument 2: block's size that you want to allocate
	 */
	HANDLE_ERROR(cudaMalloc((void**) &device_c, sizeof(int)));

	/*
	 * We call the kernel function and we pass some arguments for function using angle brackets <<<threads, gpu_blocks>>>
	 * argument 1: variable a (value copy)
	 * argument 2: variable b (value copy)
	 * argument 3: variable device_c (pointer to the memory block allocated on device)
	 */
	kernel<<<1,1>>>(a, b, device_c);

	/*
	 * Copy the value of device_c into host_c - data transfer of the DEVICE to HOST
	 * argument 1: pointer to the memory block on host mememory (destination)
	 * argument 2: pointer to the memory block on device memory (source)
	 * argument 3: block's size that you want to transfer
	 * argument 4: instruction that defines the sense of the memory transfer - variations: 
				   cudaMemcpyDeviceToHost, 
				   cudaMemcpyHostToDevice, 
				   cudaMemcpyDeviceToDevice
	 */	
	HANDLE_ERROR(cudaMemcpy(&host_c, device_c, sizeof(int), cudaMemcpyDeviceToHost));

	printf("%d + %d = %d\n", a, b, host_c);
	
	cudaFree(device_c);	//frees memory used on device

	return 0;
}
