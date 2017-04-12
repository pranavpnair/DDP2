
#include <stdio.h>
#include <assert.h>
#include<sys/time.h>

//reference code taken from CUDA website.


inline
cudaError_t checkCuda(cudaError_t result)
{
#if defined(DEBUG) || defined(_DEBUG)
  if (result != cudaSuccess) {
    fprintf(stderr, "CUDA Runtime Error: %s\n", cudaGetErrorString(result));
    assert(result == cudaSuccess);
  }
#endif
  return result;
}

template <typename T>
__global__ void offset(T* a, int s)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x + s;
  a[i] = a[i] + 1;
}

template <typename T>
__global__ void stride(T* a, int s)
{
  int i = (blockDim.x * blockIdx.x + threadIdx.x) * s;
  a[i] = a[i] + 1;
}

template <typename T>
void runTest(int deviceId, int nMB)
{
  int blockSize = 256;
  float ms;

  T *d_a;
  cudaEvent_t startEvent, stopEvent;
    
  int n = nMB*1024*1024/sizeof(T);

  // NB:  d_a(33*nMB) for stride case
  checkCuda( cudaMalloc(&d_a, n * 33 * sizeof(T)) );

  checkCuda( cudaEventCreate(&startEvent) );
  checkCuda( cudaEventCreate(&stopEvent) );

	struct timeval  tv1, tv2;
	gettimeofday(&tv1, NULL);
  printf("Offset:\n");
  for(int i=0;i<1000000;i++){
  offset<<<n/blockSize, blockSize>>>(d_a, 0); // warm up
}
	gettimeofday(&tv2, NULL);

		printf ("%f\n",
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
   

  for (int i = 0; i <= 32; i++) {
    checkCuda( cudaMemset(d_a, 0, n * sizeof(T)) );

    checkCuda( cudaEventRecord(startEvent,0) );
    offset<<<n/blockSize, blockSize>>>(d_a, i);
    checkCuda( cudaEventRecord(stopEvent,0) );
    checkCuda( cudaEventSynchronize(stopEvent) );

    checkCuda( cudaEventElapsedTime(&ms, startEvent, stopEvent) );
   // printf("%d\n", i);
  }
  
 // printf("\n");
  printf("Stride:\n");

	gettimeofday(&tv1, NULL);

	for(int i=0;i<1000000;i++){
  stride<<<n/blockSize, blockSize>>>(d_a, 1); // warm up
  }
  gettimeofday(&tv2, NULL);

		printf ("%f\n",
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
   
  for (int i = 1; i <= 32; i++) {
    checkCuda( cudaMemset(d_a, 0, n * sizeof(T)) );

    checkCuda( cudaEventRecord(startEvent,0) );
    stride<<<n/blockSize, blockSize>>>(d_a, i);
    checkCuda( cudaEventRecord(stopEvent,0) );
    checkCuda( cudaEventSynchronize(stopEvent) );

    checkCuda( cudaEventElapsedTime(&ms, startEvent, stopEvent) );
 //   printf("%d\n", i);
  }
  
  

  checkCuda( cudaEventDestroy(startEvent) );
  checkCuda( cudaEventDestroy(stopEvent) );
  cudaFree(d_a);
}

int main(int argc, char **argv)
{
  int nMB = 4;
  int deviceId = 0;
  bool bFp64 = false;

  for (int i = 1; i < argc; i++) {    
    if (!strncmp(argv[i], "dev=", 4))
      deviceId = atoi((char*)(&argv[i][4]));
    else if (!strcmp(argv[i], "fp64"))
      bFp64 = true;
  }
  
  cudaDeviceProp prop;
  
  checkCuda( cudaSetDevice(deviceId) )
  ;
  checkCuda( cudaGetDeviceProperties(&prop, deviceId) );
//  printf("Device: %s\n", prop.name);
//  printf("Transfer size (MB): %d\n", nMB);
  
//  printf("%s Precision\n", bFp64 ? "Double" : "Single");
  
  if (bFp64) runTest<double>(deviceId, nMB);
  else       runTest<float>(deviceId, nMB);
}
