#include <stdio.h>
#include <cuda.h>
#include<sys/time.h>
__global__ void dkernel(unsigned *vector, unsigned vectorsize,int N) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id<vectorsize)   
        vector[id]+=N;  
}

#define BLOCKSIZE 1024


int main(int nn, char *str[]) {
    unsigned long long N = 1024;
    unsigned *vector, *hvector;
    unsigned vec[N];
    for (int i = 0; i < N; i++) {
		vec[i] = i;
	}
	
    cudaMalloc(&vector, N * sizeof(unsigned));
    cudaMemcpy(vector, vec, N * sizeof(unsigned), cudaMemcpyHostToDevice);
    hvector = (unsigned *)malloc(N * sizeof(unsigned));
    unsigned nblocks = ceil((float)N / BLOCKSIZE);
//    printf("nblocks = %d\n", nblocks);

//here we run  the kernel in a loop which runs 1024 times.
	for(int j=1024;j<1000000;j+=10000) {
		struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
    	for(int i=0;i<j;i++)
    	    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N,i);
    	gettimeofday(&tv2, NULL);

		printf ("%d\t%f\n",j,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
   	}
    cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);
    /*for (unsigned ii = 0; ii < N; ++ii) {
    printf("%4d ", hvector[ii]);
    }*/
    return 0;
}
