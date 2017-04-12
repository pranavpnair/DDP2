
#include <stdio.h>
#include <sys/time.h>


__global__ void square( int * d_in,int n){
    int totalSum;
	if (threadIdx.x == 0) totalSum = 0;
    __syncthreads();

    int localVal = d_in[threadIdx.x];
    for(int i=0;i<n;i++)
    	atomicAdd(&totalSum, 1);
    __syncthreads();
}

int main(int argc, char ** argv) {
	const int ARRAY_SIZE = 64;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

	// generate the input array on the host
	int h_in[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in[i] = i;
	}
	int * d_in;
	cudaMalloc((void**) &d_in, ARRAY_BYTES);
//	cudaMalloc((void*) &totalSum, sizeof(float));
	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
	
	
	for(int i=100;i<1000;i+=10){
		struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
		for(int j=0;j<1000000;j++)
			square<<<1, 64>>>(d_in,i);
		gettimeofday(&tv2, NULL);

		printf ("%d\t%f\n",i,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
	}
//	cudaMemcpy(ans, totalSum, sizeof(float), cudaMemcpyDeviceToHost);
//    printf("%f\n",ans);
	cudaFree(d_in);

	return 0;
}
