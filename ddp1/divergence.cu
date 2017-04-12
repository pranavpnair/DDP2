#include <stdio.h>
#include<sys/time.h>


__global__ void square(float * d_out, float * d_in,int mod){
	
	int idx = threadIdx.x;
	float f = d_in[idx];
	switch(idx%32){
	    case 0: d_out[idx] = f*f;break;
	    case 1: d_out[idx] = f*f;break;
	    case 2: d_out[idx] = f*f;break;
	    case 3: d_out[idx] = f*f;break;
	    case 4: d_out[idx] = f*f;break;
	    case 5: d_out[idx] = f*f;break;
	    case 6: d_out[idx] = f*f;break;
	    case 7: d_out[idx] = f*f;break;
	    case 8: d_out[idx] = f*f;break;
	    case 9: d_out[idx] = f*f;break;
	    case 10: d_out[idx] = f*f;break;
	    case 11: d_out[idx] = f*f;break;
	    case 12: d_out[idx] = f*f;break;
	    case 13: d_out[idx] = f*f;break;
	    case 14: d_out[idx] = f*f;break;
	    case 15: d_out[idx] = f*f;break;
	    case 16: d_out[idx] = f*f;break;
	    case 17: d_out[idx] = f*f;break;
	    case 18: d_out[idx] = f*f;break;
	    case 19: d_out[idx] = f*f;break;
	    case 20: d_out[idx] = f*f;break;
	    case 21: d_out[idx] = f*f;break;
	    case 22: d_out[idx] = f*f;break;
	    case 23: d_out[idx] = f*f;break;
	    case 24: d_out[idx] = f*f;break;
	    case 25: d_out[idx] = f*f;break;
	    case 26: d_out[idx] = f*f;break;
	    case 27: d_out[idx] = f*f;break;
	    case 28: d_out[idx] = f*f;break;
	    case 29: d_out[idx] = f*f;break;
	    case 30: d_out[idx] = f*f;break;
	    case 31: d_out[idx] = f*f;break;
	}
}

int main(int argc, char ** argv) {
	const int ARRAY_SIZE = 64;
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
	
	

	for(int i=1;i<100;i++){
		
		struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);

		
		for(long long int j=0;j<10000000;j++)
			square<<<i, ARRAY_SIZE>>>(d_out, d_in,32);
		
		gettimeofday(&tv2, NULL);
		printf ("%d\t%f\n",i,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
	}

	
	
	

	// copy back the result array to the CPU
	cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

	cudaFree(d_in);
	cudaFree(d_out);

	return 0;
}
