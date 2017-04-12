#include <stdio.h>
 
__global__ void kernel(int *d_A, size_t pitch, int rows, int cols){
  //compute the row
  int r = blockIdx.y*blockDim.y+threadIdx.y;
  //compute the column
  int c = blockIdx.x*blockDim.x+threadIdx.x;
 
  if((r < rows) && (c < cols)){
  //   // update the pointer to point to the beginning of the row
    int *Row = (int*)((char*)d_A + r*pitch);
    int elem = Row[c];
    printf("%d ", elem);
  }
}
 
int main(){
 
  int *d_A, *A;
  size_t pitch;
  int rows = 4;
  int cols = 4;
  A = (int *)malloc(rows*cols*sizeof(int));
  for (int i = 0; i < rows*cols; i++) A[i] = i;
  cudaMallocPitch((void**)&d_A, &pitch, sizeof(int)*cols, rows);
  cudaMemcpy2D(d_A, pitch, A, sizeof(int)*cols, sizeof(int)*cols, rows, cudaMemcpyHostToDevice);
  dim3 block(16,16);
  dim3 grid(1,1);
  kernel<<<grid,block>>>(d_A, pitch, rows, cols);
  cudaDeviceSynchronize();
  printf("\nDone!\n");
  return 0;
}
