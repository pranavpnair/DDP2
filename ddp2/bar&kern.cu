#include <stdio.h>
#include <cuda.h>
#include<sys/time.h>
__global__ void dkernel(unsigned *vector, unsigned vectorsize,int N,int v2) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id<vectorsize)   
        vector[id]+=N;
    int flag=0;  
     for(int g=1;g<=v2;g++){
    	if(g%2==0)
    		flag++;
    	else
    		flag--;
    	__syncthreads();//barrier here
 
    }
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
	for(int v1=10000;v1>=1;v1-=1000){
	for(int j=1000000;j>=1;j-=10000) {
		struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
    	for(int i=0;i<j;i++){
    	    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N,i,v1);
    	     cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);}
    	gettimeofday(&tv2, NULL);
	
		printf ("%d %d %f\n",j,v1,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
		cudaDeviceSynchronize();
   	}
   	}
   
    /*for (unsigned ii = 0; ii < N; ++ii) {
    printf("%4d ", hvector[ii]);
    }*/
    return 0;
}
