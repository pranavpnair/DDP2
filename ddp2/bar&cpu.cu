#include <stdio.h>

#include<sys/time.h>
#define MAX 500

__global__ void dkernel(int *res,int n,int *res_size,int v2) {
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
     int flag=0;  
     for(int g=1;g<=v2;g++){
    	if(g%2==0)
    		flag++;
    	else
    		flag--;
    	__syncthreads();//barrier here
 
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


int main(int nn, char *str[]) {
    int *res, *hres;
    int res_size=1;
    
    
    cudaMalloc(&res, MAX * sizeof(int));
    hres = (int*)malloc(MAX*sizeof(int));
//    soln(hres,N,&res_size);
	for(int N=50;N>=1;N-=2){
		for(int v2=10000;v2>=1;v2-=300){
		struct timeval  tv1, tv2;
		gettimeofday(&tv1, NULL);
		for(int i=0;i<100000;i++)
   	 		dkernel<<<1,1>>>(res,N,&res_size,v2);
    	cudaMemcpy(hres, res, MAX * sizeof(int), cudaMemcpyDeviceToHost);
    //    cout << "Factorial of given number is \n";
    
     	cudaDeviceSynchronize();
   		gettimeofday(&tv2, NULL);
			printf ("%d %d %f\n",N,v2,
			 (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
			 (double) (tv2.tv_sec - tv1.tv_sec));
    }}
 //   int i;
    //for (i=res_size-1; i>=0; i--)
    //    printf("%d",hres[i]);
   // printf("\n");
    return 0;
}
