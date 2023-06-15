
INC	:= -I$(CUDA_HOME)/include -I.
LIB	:= -L$(CUDA_HOME)/lib64 -lcudart -lcublas -lcufft -lcurand

NVCCFLAGS	:= -lineinfo -arch=sm_35 --ptxas-options=-v --use_fast_math

all:		simpleCUBLAS simpleCUFFT simpleCUFFT_interesting cuRAND

cuRAND: 	cuRAND.cu Makefile
		nvcc cuRAND.cu -o cuRAND $(INC) $(NVCCFLAGS) $(LIB)

simpleCUBLAS:	simpleCUBLAS.cpp Makefile
		g++ simpleCUBLAS.cpp -o simpleCUBLAS $(INC) $(LIB)

simpleCUFFT:	simpleCUFFT.cu Makefile
		nvcc simpleCUFFT.cu -o simpleCUFFT $(INC) $(NVCCFLAGS) $(LIB)

simpleCUFFT_interesting:    simpleCUFFT_interesting.cu Makefile
		nvcc simpleCUFFT_interesting.cu -o simpleCUFFT_interesting $(INC) $(NVCCFLAGS) $(LIB)

clean:
		rm -f simpleCUBLAS simpleCUFFT simpleCUFFT_interesting
