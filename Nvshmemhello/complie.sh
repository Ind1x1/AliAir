nvcc -ccbin=g++ -rdc=true \
  -I/usr/include/nvshmem \
  -I/usr/local/cuda-12.4/include \
  simple_shift.cu -o simple_shift.out \
  -L/usr/lib/x86_64-linux-gnu/nvshmem/12 \
  -lnvshmem_host -lnvshmem_device \
  -gencode=arch=compute_80,code=sm_80
