#include <stdio.h>
#include <cuda.h>
#include <sys/time.h>
__global__ void dkernel(unsigned *vector, unsigned vectorsize,int i) {
 unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    vector[id] = id;
    for(int g=1;g<=i;g++)
    	__syncthreads();//barrier here
 
    
}
#define BLOCKSIZE 1024


int main(int nn, char *str[]) {
    unsigned N = 1024;
    unsigned *vector, *hvector;
    cudaMalloc(&vector, N * sizeof(unsigned));
    hvector = (unsigned *)malloc(N * sizeof(unsigned));
    unsigned nblocks = ceil((float)N / BLOCKSIZE);
    printf("nblocks = %d\n", nblocks);
     for(int i=1;i<=1000;i+=200){
    	struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
		for(long int j=0;j<10000000;j++)
    		dkernel<<<i, i>>>(vector, N,i);
    gettimeofday(&tv2, NULL);

		printf ("%d\t%f\n",i,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    	
    }
    cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);
 /*   for (unsigned ii = 0; ii < N; ++ii) {
    printf("%4d ", hvector[ii]);
    }*/
    return 0;
}
