#include<stdio.h>
#include<cuda.h>
#include <sys/time.h>


// Device code
__global__ void kernel(int* d_A, int pitch,int height,int width)
{
    for (int c = 0; c < height; ++c) {
        for (int r = 0; r < width; ++r) {
             int* row = (int*)((char*)d_A + r * pitch);
             row[c] = row[c]*row[c];
        }
    }
}

//Host Code
int main()
{
    int* d_A;
    size_t pitch;
    int *A;
    int height,width;
    for(int q=100;q<1000;q+=10){
    height = width = q;
    int rows = height;
    int cols = width;
    A = (int *)malloc(rows*cols*sizeof(int));
    for (int i = 0; i < rows*cols; i++) A[i] = i;
    cudaMallocPitch((void**)&d_A, &pitch, width * sizeof(int), height);
    cudaMemcpy2D(d_A, pitch, A, sizeof(int)*cols, sizeof(int)*cols, rows, cudaMemcpyHostToDevice);

    	struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
		for(int j=0;j<1000000;j++)
    		kernel<<<100, 32>>>(d_A, pitch,height,width);
    	gettimeofday(&tv2, NULL);

		printf ("%d\t%f\n",q,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    	
    cudaDeviceSynchronize();
	}
   // for(int i=0;i<rows*cols;i++)
   //     printf("%d %d\n",A[i],d_A[i]);
    return 0;
}



