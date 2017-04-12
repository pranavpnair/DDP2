#include <stdio.h>
#include<sys/time.h>


__device__ void dkernel(float *vector, unsigned vectorsize,int N) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id<vectorsize)   
        vector[id]+=N;  
}

__global__ void five(float * d_in, int val1,int val2){
	
	int idx = threadIdx.x;
	
	switch(idx%val1){
	    case 0: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 1: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 2: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 3: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 4: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 5: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 6: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 7: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 8: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 9: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 10: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 11: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 12: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 13: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 14: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 15: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 16: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 17: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 18: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 19: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 20: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 21: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 22: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 23: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 24: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 25: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 26: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 27: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 28: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 29: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 30: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	    case 31: for(int i=0;i<val2;i++)dkernel(d_in,1024,val2);break;
	}
	__syncthreads();
}




int main(int argc, char ** argv) {
	const int ARRAY_SIZE = 1024;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

	// generate the input array on the host
	float h_in[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in[i] = float(i);
	}
	float h_out[ARRAY_SIZE];

	// declare GPU memory pointers
	float * d_in;
	float * d_out;

	// allocate GPU memory
	cudaMalloc((void**) &d_in, ARRAY_BYTES);
	cudaMalloc((void**) &d_out, ARRAY_BYTES);

	// transfer the array to the GPU
	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
	
	
	for(int v1=32;v1>=1;v1--){
		for(int v2=1000;v2>=1;v2-=100){
		
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);

			for(long long int j=0;j<1000000;j++){
				five<<<1, ARRAY_SIZE>>>(d_in,v1,v2);
				cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);
				cudaDeviceSynchronize();
			}
			
			gettimeofday(&tv2, NULL);
			printf ("%d %d %f\n",v1,v2,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
		}
	}
	// copy back the result array to the CPU
	

	cudaFree(d_in);
	cudaFree(d_out);

	return 0;
}
		
