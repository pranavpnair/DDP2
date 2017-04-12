#include <stdio.h>
#include <cuda.h>
#include<sys/time.h>

__global__ void dkernel(unsigned *vector, unsigned vectorsize) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id<vectorsize)   
        vector[id]++;  
}

#define BLOCKSIZE 1024


int main(int nn, char *str[]) {
    unsigned long long N=1024;
    for(int j=1;j<1024;j+=10){
    struct timeval  tv1, tv2;
	gettimeofday(&tv1, NULL);
    unsigned *vector, *hvector;
    unsigned vec[N*j];
    for (int i = 0; i < N*j; i++) {
		vec[i] = i;
	}
	
    cudaMalloc(&vector, N * sizeof(unsigned));
    cudaMemcpy(vector, vec, N * sizeof(unsigned), cudaMemcpyHostToDevice);
    hvector = (unsigned *)malloc(N * sizeof(unsigned));
    unsigned nblocks = ceil((float)N / BLOCKSIZE);
//    printf("nblocks = %d\n", nblocks);
    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N);
    cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);
    
    gettimeofday(&tv2, NULL);

		printf ("%d\t%f\n",j,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    }
    return 0;
}
