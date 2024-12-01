DPUDMABench is divided has two parts for measuring DMA performance on BF-2's and BF-3's DMA engine under bf2/ and bf3/ subfolders. Each subfolder is further divided into two components: host and dpu. As their name suggests, each component runs on either the host or the dpu. Both components (host and dpu) need to be run in order to measure DMA engine's performance. Each component contains code for different DMA reads/writes (event vs. polling and host vs. DPU initiated).

For throughput test, in polling mode, number of iterations (N) is 5000 for payload of 2 bytes - 131072 bytes, 1000 for 262144 bytes - 1048576 bytes, and 100 for 2097152 bytes - 8388608 bytes. For throughput test, in event_epoll mode, number of iterations (N) is 1000 for payload of 2 bytes - 1048576 bytes and 100 for 2097152 bytes - 8388608 bytes.

For latency tests, number of iterations (N) is always 5000.

#### Example

For instance, to measure latency of DMA write (H-to-D) using polling for DMA completions on BF-2, the host side component is dpudmabench/bf2/host/host_dma_write_h_to_d_lat_poll and the DPU component is dpudmabench/bf2/dpu/dpu_dma_write_h_to_d_lat_poll. We have added a Makefile and a run.sh script under each folder to generate the binary for the specific DMA operation and help launch the component. Note that DPUDMABench works on BF-2/BF-3 since BF-1 does not expose the DOCA DMA engine.

To measure DMA write (H-to-D)(poll), first launch DPU side component-
dpudmabench/bf2/dpu/dpu_dma_write_h_to_d_lat -p 03:00.0 -d desc.txt -b buf.txt <size>
where <size> can vary from 2B-8MB. The DPU side component generates desc.txt and buf.txt files. These files need to be transferred to the host (e.g., via scp) where the host-side component resides.
After that launch host side component-
dpudmabench/bf2/host/host_dma_write_h_to_d_lat -d desc.txt -b buf.txt -p 01:00.0
For latency, the DPUDMABench performs 5000 iterations for given buffer size for DMA and prints the latency on the host-side.

Any component with the suffix “event” indicates DMA operations where event-based DMA completions are used. For example, the host and DPU components for event-based DMA are host_dma_write_h_to_d_lat_event and dpu_dma_write_h_to_d_lat_event respectively. The performance of event-based DMA operation can be measured similarly to polling based ones as discussed above. 

Measuring DMA write (D-to-H) can be done by first running the host side component and then the DPU side component. Similarly, the copy the buf.txt and desc.txt files from host to the DPU (opposite to H-to-D case)
Host
dpudmabench/bf2/host/host_dma_write_d_to_h_lat -d desc.txt -b buf.txt -p 01:00.0 <size>
DPU
dpudmabench/bf2/dpu/dpu_dma_write_d_to_h_lat -p 03:00.0 -d desc.txt -b buf.txt
Similarly, throughput can be computed for various types of DMA operations. The suffix “thr” and “thr_event” represent throughput of polling and event-based DMA operations respectively.

For Figure 6a, the core utilization on host and DPU is measured by Linux perf utility.

For Figure 5(j)-5(q), the RDMA performance (throughput and latency) is measured by RDMA perftest tool between the DPU and its host. Specifically, performance of RDMA Read was measured by ib_read_lat and ib_read_bw while the performance of RDMA Write was measured by ib_write_lat and ib_write_bw. For example, measuring the latency of RDMA Write (D-to-H), i.e., DPU-initiated RDMA Read operation, run the following on host-
ib_read_lat -a -F
and the following on DPU-
ib_read_lat -a -F <host>
where <host> represents IP address of the host
Similarly, performance of RDMA operation can be measured and compared with polling-based DMA operations.

This experiment characterizes and compares the performance of different data exchange primitives between the host and the DPU—DMA and RDMA.
