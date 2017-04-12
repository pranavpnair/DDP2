#include <stdio.h>
#include<sys/time.h>



__device__ void barrier(float *vector,int i) {
 unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    vector[id] = id;
    int flag=0;
    for(int g=1;g<=i;g++){
    	if(g%2==0)
    		flag++;
    	else
    		flag--;
    	__syncthreads();//barrier here
 
    }
}

__global__ void five(float * d_out, float * d_in,int val1,int val2){
	
	int idx = threadIdx.x;
	
	switch(idx%val1){
	    case 0: barrier(d_in,val2);break;
	    case 1: barrier(d_in,val2);break;
	    case 2: barrier(d_in,val2);break;
	    case 3: barrier(d_in,val2);break;
	    case 4: barrier(d_in,val2);break;
	    case 5: barrier(d_in,val2);break;
	    case 6: barrier(d_in,val2);break;
	    case 7: barrier(d_in,val2);break;
	    case 8: barrier(d_in,val2);break;
	    case 9: barrier(d_in,val2);break;
	    case 10: barrier(d_in,val2);break;
	    case 11: barrier(d_in,val2);break;
	    case 12: barrier(d_in,val2);break;
	    case 13: barrier(d_in,val2);break;
	    case 14: barrier(d_in,val2);break;
	    case 15: barrier(d_in,val2);break;
	    case 16: barrier(d_in,val2);break;
	    case 17: barrier(d_in,val2);break;
	    case 18: barrier(d_in,val2);break;
	    case 19: barrier(d_in,val2);break;
	    case 20: barrier(d_in,val2);break;
	    case 21: barrier(d_in,val2);break;
	    case 22: barrier(d_in,val2);break;
	    case 23: barrier(d_in,val2);break;
	    case 24: barrier(d_in,val2);break;
	    case 25: barrier(d_in,val2);break;
	    case 26: barrier(d_in,val2);break;
	    case 27: barrier(d_in,val2);break;
	    case 28: barrier(d_in,val2);break;
	    case 29: barrier(d_in,val2);break;
	    case 30: barrier(d_in,val2);break;
	    case 31: barrier(d_in,val2);break;
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
	
	
	for(int v1=31;v1>=1;v1-=2){
		for(int v2=10000;v2>=1000;v2-=400){
		
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);

			for(long long int j=0;j<3000000;j++){
				five<<<1, ARRAY_SIZE>>>(d_out, d_in,v1,v2);
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
		
