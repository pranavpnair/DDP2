
#include <stdio.h>
#include <sys/time.h>


__global__ void coal(int * d_out, int * d_in,int val1,int val2){
	int f;
	int totalSum=1;
	for(int i=0;i<1024;i+=val2)
	{
		f= d_in[i];
		d_out[i]=f*f;
		
	if (threadIdx.x == 0) totalSum = 0;
  	  __syncthreads();

    for(int i=0;i<val1;i++)
    	atomicAdd(&totalSum, d_out[i]);
    __syncthreads();
	}
}


int main(int argc, char ** argv) {
	const int ARRAY_SIZE = 1024;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);

	// generate the input array on the host
	int h_in[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in[i] = int(i);
	}
	int h_out[ARRAY_SIZE];

	// declare GPU memory pointers
	int * d_in;
	int * d_out;

	// allocate GPU memory
	cudaMalloc((void**) &d_in, ARRAY_BYTES);
	cudaMalloc((void**) &d_out, ARRAY_BYTES);

	// transfer the array to the GPU
	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
	


	
	for(int v1=32;v1>=1;v1--){
		for(int v2=10000;v2>=100;v2-=300){
		
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);
		//	cudaEventRecord(start);
			for(long long int j=0;j<1000000;j++){
				coal<<<100, ARRAY_SIZE>>>(d_out, d_in,v1,v2);
				cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);
				cudaDeviceSynchronize();
			}
			
		//	cudaEventSynchronize(stop);
		//	cudaEventElapsedTime(&time, start, stop);
			gettimeofday(&tv2, NULL);
			printf ("%d %d %f\n",v1,v2,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
		}
	}


	cudaFree(d_in);
	cudaFree(d_out);

	return 0;
}
		
