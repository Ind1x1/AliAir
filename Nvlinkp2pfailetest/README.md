# Nvlinktest

NVSHMEM GPU EP test for the bandwidth and access between GPUs

## Complie

Use CMakeLists or 

<code>
nvcc -ccbin=g++ -rdc=true \
  -I/usr/include/nvshmem \
  -I/usr/local/cuda-12.4/include \
  nvlinktest.cu -o nvlinktest.out \
  -L/usr/lib/x86_64-linux-gnu/nvshmem/12 \
  -lnvshmem_host -lnvshmem_device \
  -gencode=arch=compute_80,code=sm_80
</code>

## Run

```mpirun -n 4 -ppn 2 -hosts hostname1,hostname2 /path/to/nvshmem/app/binary```
```mpirun -n 2 /path/to/nvshmem/app/binary```

## Tip

RDMA/Infiniband is required

GPU p2p link is required (Using ```nvidia-smi topo``` -m to test)