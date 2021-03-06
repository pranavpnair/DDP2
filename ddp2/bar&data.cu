#include <stdio.h>
#include <cuda.h>
#include<sys/time.h>

__global__ void seventeen(unsigned *vector, unsigned vectorsize,int v2){
	unsigned id;
	id = blockIdx.x * blockDim.x + threadIdx.x;
	if(id<vectorsize)   
		vector[id]++;  
	__syncthreads();
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
#define ARRAY_SIZE 1024

int main(int nn, char *str[]) {
    unsigned long long N=1024;
   for(int v1=10000;v1>=100;v1-=300){
		for(int j=1024;j>=1;j-=10){
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);
			unsigned *vector, *hvector;
			unsigned vec[ARRAY_SIZE*j];
			for (int i = 0; i < 1024*j; i++) {
				vec[i] = i;
			}
			cudaMalloc(&vector, N * sizeof(unsigned));
			cudaMemcpy(vector, vec, N * sizeof(unsigned), cudaMemcpyHostToDevice);
			hvector = (unsigned *)malloc(N * sizeof(unsigned));
			unsigned nblocks = ceil((float)N / 1024);
		//    printf("nblocks = %d\n", nblocks);
			seventeen<<<100, 1024>>>(vector, N,v1);
			cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);

			gettimeofday(&tv2, NULL);
			
				printf ("%d %d %f\n",j,v1,
					 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
					 (double) (tv2.tv_sec - tv1.tv_sec));
			cudaDeviceSynchronize();		
		}
	}
    return 0;
}
