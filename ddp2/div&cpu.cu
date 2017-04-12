#include <stdio.h>
#include<sys/time.h>
#define MAX 500


__device__ void dkernel(int *res,int n,int *res_size) {
    // Initialize result
    res[0] = 1;
//    int res_size = 1;
 
    for (int x=2; x<=n; x++){
        int carry = 0;  // Initialize carry
        for (int i=0; i<*res_size; i++)
        {
            int prod = res[i] * x + carry;
            res[i] = prod % 10; 
            carry  = prod/10;    
        }
     
        while (carry)
        {
            res[*res_size] = carry%10;
            carry = carry/10;
            (*res_size)++;
        }
    
    }
}


void soln(int *res,int n,int *res_size){
    // Initialize result
    res[0] = 1;
//    int res_size = 1;
 	int x;
    for (x=2; x<=n; x++){
        int carry = 0,i;  // Initialize carry
        for (i=0; i<*res_size; i++)
        {
            int prod = res[i] * x + carry;
            res[i] = prod % 10; 
            carry  = prod/10;    
        }
     
        while (carry)
        {
            res[*res_size] = carry%10;
            carry = carry/10;
            (*res_size)++;
        }
    
    }
}

__global__ void five(int * res, int val2,int *res_size,int val1){
	
	int idx = threadIdx.x;
	
	switch(idx%val1){
	    case 0:dkernel(res,val2,res_size);;break;
	    case 1:dkernel(res,val2,res_size);;break;
	    case 2:dkernel(res,val2,res_size);;break;
	    case 3:dkernel(res,val2,res_size);;break;
	    case 4:dkernel(res,val2,res_size);;break;
	    case 5:dkernel(res,val2,res_size);;break;
	    case 6:dkernel(res,val2,res_size);;break;
	    case 7:dkernel(res,val2,res_size);;break;
	    case 8:dkernel(res,val2,res_size);;break;
	    case 9:dkernel(res,val2,res_size);;break;
	    case 10:dkernel(res,val2,res_size);;break;
	    case 11:dkernel(res,val2,res_size);;break;
	    case 12:dkernel(res,val2,res_size);;break;
	    case 13:dkernel(res,val2,res_size);;break;
	    case 14:dkernel(res,val2,res_size);;break;
	    case 15:dkernel(res,val2,res_size);;break;
	    case 16:dkernel(res,val2,res_size);;break;
	    case 17:dkernel(res,val2,res_size);;break;
	    case 18:dkernel(res,val2,res_size);;break;
	    case 19:dkernel(res,val2,res_size);;break;
	    case 20:dkernel(res,val2,res_size);;break;
	    case 21:dkernel(res,val2,res_size);;break;
	    case 22:dkernel(res,val2,res_size);;break;
	    case 23:dkernel(res,val2,res_size);;break;
	    case 24:dkernel(res,val2,res_size);;break;
	    case 25:dkernel(res,val2,res_size);;break;
	    case 26:dkernel(res,val2,res_size);;break;
	    case 27:dkernel(res,val2,res_size);;break;
	    case 28:dkernel(res,val2,res_size);;break;
	    case 29:dkernel(res,val2,res_size);;break;
	    case 30:dkernel(res,val2,res_size);;break;
	    case 31:dkernel(res,val2,res_size);;break;
	}
	__syncthreads();
}




int main(int nn, char *str[]) {
    int *res, *hres;
    int res_size=1;
    
    
    cudaMalloc(&res, MAX * sizeof(int));
    hres = (int*)malloc(MAX*sizeof(int));
//    soln(hres,N,&res_size);
	for(int v1=32;v1>=1;v1--){
		for(int v2=32;v2>=1;v2--){
		struct timeval  tv1, tv2;
			gettimeofday(&tv1, NULL);
	for(int i=0;i<100000;i++)
    	five<<<1,32>>>(res,v2,&res_size,v1);
    cudaMemcpy(hres, res, MAX * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    gettimeofday(&tv2, NULL);
			printf ("%d %d %f\n",v1,v2,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    //    cout << "Factorial of given number is \n";
 //   for (i=res_size-1; i>=0; i--)
 //       printf("%d",hres[i]);
  //  printf("\n");
  
  
    }}
    return 0;
}
