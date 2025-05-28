# AliAir
Private Repository for Alibaba project

# p2pBandwidthLatencyTest

##  CUDA API used

---

**cudaSetDevice**  
设置当前线程要使用的 GPU 设备。

**cudaEventDestroy**  
销毁一个 CUDA 事件对象，释放相关资源。

**cudaOccupancyMaxPotentialBlockSize**  
计算给定内核函数的最大潜在线程块大小和网格大小，以实现最佳硬件占用率。

**cudaCheckError**  
不是官方 CUDA API，通常是自定义的错误检查宏或函数，用于检查 CUDA 调用是否出错。

**cudaFreeHost**  
释放通过 `cudaHostAlloc` 分配的主机端（CPU）内存。

**cudaGetDeviceCount**  
获取系统中可用的 CUDA 设备（GPU）数量。

**cudaDeviceCanAccessPeer**  
查询一个设备是否可以直接访问另一个设备的内存（P2P 访问能力）。

**cudaStreamCreateWithFlags**  
创建一个带有特定标志的 CUDA 流（stream），用于异步操作。

**cudaStreamDestroy**  
销毁一个 CUDA 流，释放相关资源。

**cudaGetLastError**  
返回上一次 CUDA 运行时 API 调用的错误代码，并清除错误状态。

**cudaMemset**  
将设备内存（GPU 内存）设置为指定的值，类似于 C 语言的 `memset`。

**cudaStreamWaitEvent**  
让一个流等待某个事件完成后再继续执行。

**cudaEventElapsedTime**  
计算两个事件之间经过的时间（以毫秒为单位），常用于性能分析。

**cudaEventCreate**  
创建一个 CUDA 事件对象，用于测量时间或同步。

**cudaHostAlloc**  
在主机端分配可被设备直接访问的内存（页锁定内存）。

**cudaFree**  
释放通过 `cudaMalloc` 分配的设备内存。

**cudaGetErrorString**  
将 CUDA 错误代码转换为可读的字符串，便于调试。

**cudaMemcpyPeerAsync**  
在不同设备（GPU）之间异步拷贝内存。

**cudaDeviceDisablePeerAccess**  
禁用当前设备对另一个设备的 P2P 访问。

**cudaEventRecord**  
在指定流中记录一个事件，用于后续同步或计时。

**cudaStreamSynchronize**  
阻塞主机线程，直到指定流中的所有操作完成。

**cudaDeviceEnablePeerAccess**  
启用当前设备对另一个设备的 P2P 访问。

**cudaMalloc**  
在设备（GPU）上分配内存。

**cudaGetDeviceProperties**  
获取指定设备的属性信息（如显存大小、计算能力等）。

---

## Code

copyp2p<<<numBlocks, blockSize, 0, streamToRun>>>((int4 *)dest, (int4 *)src, num_elems / 4);

numBlock:线程块

blockSize:线程数

0:共享内存

StreamToRun:CUDA流

cudaHostAlloc((void **)&flag, sizeof(*flag), cudaHostAllocPortable);



