#include <stdio.h>

#define MAX 500


__global__ void dkernel(int *res,int n,int *res_size) {
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


int main(int nn, char *str[]) {
    int N = atoi(str[1]);
    int *res, *hres;
    int res_size=1;
    
    
    cudaMalloc(&res, MAX * sizeof(int));
    hres = (int*)malloc(MAX*sizeof(int));
//    soln(hres,N,&res_size);
    dkernel<<<1,1>>>(res,N,&res_size);
    cudaMemcpy(hres, res, MAX * sizeof(int), cudaMemcpyDeviceToHost);
    //    cout << "Factorial of given number is \n";
    int i;
    for (i=res_size-1; i>=0; i--)
        printf("%d",hres[i]);
    printf("\n");
    return 0;
}
