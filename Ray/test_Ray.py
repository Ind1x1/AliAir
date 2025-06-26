import ray
import torch
import torch.distributed as dist
import os
import time

MASTER_ADDR = "10.246.176.25"  # Head 节点 IP
MASTER_PORT = "29500"
WORLD_SIZE = 8

ray.init(address="auto")

@ray.remote(num_gpus=1)
class Worker:
    def __init__(self, rank):
        self.rank = rank
        self.device = f"cuda:{torch.cuda.current_device()}"
        os.environ["RANK"] = str(self.rank)
        os.environ["WORLD_SIZE"] = str(WORLD_SIZE)
        os.environ["MASTER_ADDR"] = MASTER_ADDR
        os.environ["MASTER_PORT"] = MASTER_PORT
        print(f"[Rank {self.rank}] using {self.device}")
        dist.init_process_group(
            backend="nccl",
            rank=self.rank,
            world_size=WORLD_SIZE,
            init_method=f"tcp://{MASTER_ADDR}:{MASTER_PORT}"
        )
    
    def allreduce(self, step):
        tensor = torch.ones(1, device=self.device) * (self.rank + step)
        dist.all_reduce(tensor)
        result = tensor.item()
        print(f"[Rank {self.rank}] step {step}, allreduce result: {result}")
        return result

    def shutdown(self):
        if dist.is_initialized():
            dist.destroy_process_group()
        print(f"[Rank {self.rank}] shutdown.")

# 启动 8 个 worker actor
workers = [Worker.remote(rank=i) for i in range(WORLD_SIZE)]

# 执行 AllReduce
for step in range(5):
    print(f"\n=== AllReduce Step {step} ===")
    results = ray.get([w.allreduce.remote(step) for w in workers])
    print("Results:", results)

# 关闭
ray.get([w.shutdown.remote() for w in workers])
ray.shutdown()
