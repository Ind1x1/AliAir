cmake_minimum_required(VERSION 3.18)
project(NVSHMEMExample CUDA CXX)

set(CMAKE_CUDA_STANDARD 14)

set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

set(CMAKE_CUDA_ARCHITECTURES 80)

set(NVSHMEM_INCLUDE_DIR /usr/include/nvshmem)
set(NVSHMEM_LIB_DIR /usr/lib/x86_64-linux-gnu/nvshmem/12)

add_executable(simple_shift simple_shift.cu)

target_include_directories(simple_shift PRIVATE
    ${NVSHMEM_INCLUDE_DIR}
    /usr/local/cuda-12.4/include
)

link_directories(${NVSHMEM_LIB_DIR})

target_link_libraries(simple_shift
    PRIVATE
    nvshmem_host
    nvshmem_device
)

target_compile_options(simple_shift PRIVATE
    $<$<COMPILE_LANGUAGE:CUDA>:
        -gencode=arch=compute_80,code=sm_80
    >
)