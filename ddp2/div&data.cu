#include <stdio.h>
#include <cuda.h>
#include<sys/time.h>

__global__ void seventeen(unsigned *vector, unsigned vectorsize,int val1){
	int idx = threadIdx.x;
	unsigned id;
	switch(idx%val1){
	    case 0:     id = blockIdx.x * blockDim.x + threadIdx.x;
    				if(id<vectorsize)   
        			vector[id]++;  break;
	    case 1:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 2:      id = blockIdx.x * blockDim.x + threadIdx.x;
    				if(id<vectorsize)   
        			vector[id]++;  break;
	    case 3:      id = blockIdx.x * blockDim.x + threadIdx.x;
    				if(id<vectorsize)   
        			vector[id]++;  break;
	    case 4:      id = blockIdx.x * blockDim.x + threadIdx.x;
    				if(id<vectorsize)   
        			vector[id]++;  break;
	    case 5:      id = blockIdx.x * blockDim.x + threadIdx.x;
    				if(id<vectorsize)   
        			vector[id]++;  break;
	    case 6:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 7:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 8:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 9:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 10:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 11:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 12:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 13:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 14:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 15:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 16:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 17:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 18:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 19:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 20:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 21:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 22:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 23:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 24:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 25:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 26:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 27:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 28:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 29:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 30:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	    case 31:      id = blockIdx.x * blockDim.x + threadIdx.x;
					if(id<vectorsize)   
						vector[id]++;  break;
	}
	__syncthreads();
}



#define ARRAY_SIZE 1024


int main(int nn, char *str[]) {
    unsigned N=1024;
   for(int v1=32;v1>=1;v1--){
		for(int j=1024;j>=1;j-=10){
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);
			unsigned *vector, *hvector;
			unsigned vec[ARRAY_SIZE*j];
			for (int i = 0; i < 1024*j; i++) {
				vec[i] = i;
			}
			int N = 1024;
			cudaMalloc(&vector, N * sizeof(unsigned));
			cudaMemcpy(vector, vec, N * sizeof(unsigned), cudaMemcpyHostToDevice);
			hvector = (unsigned *)malloc(N * sizeof(unsigned));
			unsigned nblocks = ceil((float)N / 1024);
		//    printf("nblocks = %d\n", nblocks);
			seventeen<<<100, 1024>>>(vector, N,v1);
			cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);

			gettimeofday(&tv2, NULL);
			
				printf ("%d %d %f\n",v1,j,
					 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
					 (double) (tv2.tv_sec - tv1.tv_sec));
			cudaDeviceSynchronize();		
		}
	}
    return 0;
}
