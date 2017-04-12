#include <stdio.h>
#include<sys/time.h>



__device__ void coal(float * d_out, float * d_in,int val2){
	float f;
	for(int i=0;i<1024;i+=val2)
	{
		f= d_in[i];
		d_out[i]=f*f;
	}
}

__global__ void three(float * d_out, float * d_in,int val1,int val2){
	
	int idx = threadIdx.x;
	
	switch(idx%val1){
	    case 0: coal(d_out,d_in,val2);break;
	    case 1: coal(d_out,d_in,val2);break;
	    case 2: coal(d_out,d_in,val2);break;
	    case 3: coal(d_out,d_in,val2);break;
	    case 4: coal(d_out,d_in,val2);break;
	    case 5: coal(d_out,d_in,val2);break;
	    case 6: coal(d_out,d_in,val2);break;
	    case 7: coal(d_out,d_in,val2);break;
	    case 8: coal(d_out,d_in,val2);break;
	    case 9: coal(d_out,d_in,val2);break;
	    case 10: coal(d_out,d_in,val2);break;
	    case 11: coal(d_out,d_in,val2);break;
	    case 12: coal(d_out,d_in,val2);break;
	    case 13: coal(d_out,d_in,val2);break;
	    case 14: coal(d_out,d_in,val2);break;
	    case 15: coal(d_out,d_in,val2);break;
	    case 16: coal(d_out,d_in,val2);break;
	    case 17: coal(d_out,d_in,val2);break;
	    case 18: coal(d_out,d_in,val2);break;
	    case 19: coal(d_out,d_in,val2);break;
	    case 20: coal(d_out,d_in,val2);break;
	    case 21: coal(d_out,d_in,val2);break;
	    case 22: coal(d_out,d_in,val2);break;
	    case 23: coal(d_out,d_in,val2);break;
	    case 24: coal(d_out,d_in,val2);break;
	    case 25: coal(d_out,d_in,val2);break;
	    case 26: coal(d_out,d_in,val2);break;
	    case 27: coal(d_out,d_in,val2);break;
	    case 28: coal(d_out,d_in,val2);break;
	    case 29: coal(d_out,d_in,val2);break;
	    case 30: coal(d_out,d_in,val2);break;
	    case 31: coal(d_out,d_in,val2);break;
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
		for(int v2=32;v2>=1;v2--){
		
			struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);
		//	cudaEventRecord(start);
			for(long long int j=0;j<1000000;j++){
				three<<<100, ARRAY_SIZE>>>(d_out, d_in,v1,v2);
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
		
