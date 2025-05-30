/*Copy right
*   Leyi Ye 2025 (alpha) poject
*   This project is used to test the nvlink p2p bandwidth and latenc
*/
#include <stdio.h>
#include <cuda.h>
#include <nvshmem.h>
#include <nvshmemx.h>


#undef CUDA_CHECK
#define CUDA_CHECK(stmt)                                                          \
    do {                                                                          \
        cudaError_t result = (stmt);                                              \
        if (cudaSuccess != result) {                                              \
            fprintf(stderr, "[%s:%d] cuda failed with %s \n", __FILE__, __LINE__, \
                    cudaGetErrorString(result));                                  \
            exit(-1);                                                             \
        }                                                                         \
    } while (0)


#define cudaCheckError()                                                                     \
    {                                                                                        \
        cudaError_t e = cudaGetLastError();                                                  \
        if (e != cudaSuccess) {                                                              \
            printf("Cuda failure %s:%d: '%s'\n", __FILE__, __LINE__, cudaGetErrorString(e)); \
            exit(EXIT_FAILURE);                                                              \
        }                                                                                    \
    }



__global__ void Ring_Shift_test(int *destination) {
    int mype = nvshmem_my_pe();
    int npes = nvshmem_n_pes();
    int peer = (mype + 1) % npes;

    nvshmem_int_p(destination, mype, peer);
}

void performRing_Shift_test(int *destination, int repeat)
{
    int blockSize = 0;
    int numBlocks = 0;

    cudaOccupancyMaxPotentialBlockSize(&numBlocks, &blockSize, Ring_Shift_test);

    for(int r = 0; r < repeat; r++){
        Ring_Shift_test<<<numBlocks, blockSize>>>(destination);
    }
}

void outputNVSHMEMBandwidthRingMatrix(int numElems, int repeat)
{
    int mype_node;
    cudaEvent_t start, stop;
    cudaStream_t stream;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    nvshmem_init();
    mype_node = nvshmem_team_my_pe(NVSHMEMX_TEAM_NODE);
    cudaSetDevice(mype_node);
    cudaStreamCreate(&stream);
    int npes = nvshmem_n_pes();

    int *destination = (int *) nvshmem_malloc(sizeof(int) * numElems);
    cudaCheckError();

    cudaEventRecord(start, stream);
    cudaCheckError();
    
    performRing_Shift_test(destination, repeat);
    nvshmemx_barrier_all_on_stream(stream);

    cudaEventRecord(stop, stream);
    cudaCheckError();

    float time_ms;
    cudaEventElapsedTime(&time_ms, start, stop);
    double time_s = time_ms / 1e3;

    double gb = numElems * sizeof(int) * repeat / (double)1e9;
    double bandwidth = gb / time_s;


    printf("GPU NVSHMEM Bandwidth Ring Matrix\n");
    printf("----------------------------------\n");
    printf("%6.02f", bandwidth);
    

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaStreamDestroy(stream);

    nvshmem_free(destination);
    nvshmem_finalize();
    cudaCheckError();
}

int main()
{
    int numGPUs,numElems = 4000000;
    cudaGetDeviceCount(&numGPUs);
    cudaCheckError();

    outputNVSHMEMBandwidthRingMatrix(numElems, 5);
}