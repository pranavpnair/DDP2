#include<stdio.h>
#include<cuda.h>
#include <sys/time.h>


// Device code
__device__ void kernel(int* d_A, int pitch,int height,int width)
{
    for (int c = 0; c < height; ++c) {
        for (int r = 0; r < width; ++r) {
             int* row = (int*)((char*)d_A + r * pitch);
             row[c] = row[c]*row[c];
        }
    }
}



__global__ void three(int * d_out, int pitch,int height, int width,int val1,int val2){
	
	int idx = threadIdx.x;
	
	switch(idx%val1){
	    case 0: kernel(d_out,pitch,height,val2);break;
	    case 1: kernel(d_out,pitch,height,val2);break;
	    case 2: kernel(d_out,pitch,height,val2);break;
	    case 3: kernel(d_out,pitch,height,val2);break;
	    case 4: kernel(d_out,pitch,height,val2);break;
	    case 5: kernel(d_out,pitch,height,val2);break;
	    case 6: kernel(d_out,pitch,height,val2);break;
	    case 7: kernel(d_out,pitch,height,val2);break;
	    case 8: kernel(d_out,pitch,height,val2);break;
	    case 9: kernel(d_out,pitch,height,val2);break;
	    case 10: kernel(d_out,pitch,height,val2);break;
	    case 11: kernel(d_out,pitch,height,val2);break;
	    case 12: kernel(d_out,pitch,height,val2);break;
	    case 13: kernel(d_out,pitch,height,val2);break;
	    case 14: kernel(d_out,pitch,height,val2);break;
	    case 15: kernel(d_out,pitch,height,val2);break;
	    case 16: kernel(d_out,pitch,height,val2);break;
	    case 17: kernel(d_out,pitch,height,val2);break;
	    case 18: kernel(d_out,pitch,height,val2);break;
	    case 19: kernel(d_out,pitch,height,val2);break;
	    case 20: kernel(d_out,pitch,height,val2);break;
	    case 21: kernel(d_out,pitch,height,val2);break;
	    case 22: kernel(d_out,pitch,height,val2);break;
	    case 23: kernel(d_out,pitch,height,val2);break;
	    case 24: kernel(d_out,pitch,height,val2);break;
	    case 25: kernel(d_out,pitch,height,val2);break;
	    case 26: kernel(d_out,pitch,height,val2);break;
	    case 27: kernel(d_out,pitch,height,val2);break;
	    case 28: kernel(d_out,pitch,height,val2);break;
	    case 29: kernel(d_out,pitch,height,val2);break;
	    case 30: kernel(d_out,pitch,height,val2);break;
	    case 31: kernel(d_out,pitch,height,val2);break;
	}
	__syncthreads();
}


//Host Code
int main()
{
    int* d_A;
    size_t pitch;
    int *A;
    int height,width;

    height = width = 32;
    int rows = height;
    int cols = width;
    A = (int *)malloc(rows*cols*sizeof(int));
    for (int i = 0; i < rows*cols; i++) A[i] = i;
    cudaMallocPitch((void**)&d_A, &pitch, width * sizeof(int), height);
    cudaMemcpy2D(d_A, pitch, A, sizeof(int)*cols, sizeof(int)*cols, rows, cudaMemcpyHostToDevice);
	for(int v1=32;v1>=1;v1-=2){
	for(int v2=32;v2>=1;v2-=2){
    	struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
		for(int j=0;j<1000000;j++)
    		three<<<1, 1024>>>(d_A, pitch,height,width,v1,v2);
    	gettimeofday(&tv2, NULL);

		printf ("%d %d %f\n",v1,v2,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    	
    cudaDeviceSynchronize();
	}}
   // for(int i=0;i<rows*cols;i++)
   //     printf("%d %d\n",A[i],d_A[i]);
    return 0;
}
