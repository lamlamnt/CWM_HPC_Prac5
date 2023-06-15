#include <cuda.h>
#include <curand.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

float calculate_mean(float *input,int n){
	float sum = 0;
	for(int i = 0; i < n; i++){
		sum +=input[i];
	}
	return float(sum/float(n));
}

float calculate_std(float *input, float mean, int n){
	float sum_squared = 0;
	for(int i = 0; i<n; i++){
		sum_squared += (input[i] - mean)*(input[i] - mean);
	}	
	return float(sqrt(sum_squared/float(n)));
}

//Output histogram to a file
//Histogram divided into less than -1, between -1 and -0.5, between -0.5 and 0, between 0 and 0.5, between 0.5 and 1, and greater
//than 1
void generate_histogram(float *input, int n){
	/*
	int count_1; int count_2; int count_3, int count_4, int count_5, int count_6;
	for(int i = 0; i < n; i++){
		if(input[i] < -1) count_1 +=1;
		else if(input[i] > -1 && input[i] < -0.5) {count_2 +=1};
		else if(input[i] > -0.5 && input[i] < 0) {count_3 +=1};
		else if(input[i] > 0 && input[i] < 0.5) {count_4 +=1};
		else if(input[i] > 0.5 && input[i] < 1) {count_5 +=1};
		else{count_6 +=1;}
	}
	*/
	//Writes the input values to a file
	FILE *fp;
	fp = fopen("data.dat","w");
	for(int i = 0; i < n; i++){
		fprintf(fp,"%f\n",input[i]);
	}
	fclose(fp);
}

int main(void){
	//Allocate pointers for host and device memory
	float *h_output;
	float *d_output;
	int n = 10;
	int mem_size = n*sizeof(float);

	h_output = (float*)malloc(mem_size);

	cudaMalloc((void**)&d_output,mem_size);

	//Declare variable
	curandGenerator_t gen;

	//Create random number generator
	curandCreateGenerator(&gen,CURAND_RNG_PSEUDO_DEFAULT);

	//Set the generator options
	curandSetPseudoRandomGeneratorSeed(gen,1234ULL);

	//Generate the randoms
	curandGenerateNormal(gen, d_output,n, 0.0f, 1.0f);

	//Copy result from device to host
	cudaMemcpy(h_output,d_output,mem_size,cudaMemcpyDeviceToHost);

	float mean = calculate_mean(h_output,n);
	printf("The mean is %f \n",mean);
		
	float std = calculate_std(h_output,mean,n);
	printf("The standard deviation is %f \n",std);
	
	//Output histogram to a png
	generate_histogram(h_output,n);
	//cleanup memory
	free(h_output);
	cudaFree(d_output);
	return(0);
}
