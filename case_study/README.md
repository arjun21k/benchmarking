#### Experiment for Figure 8 (Off-path HERD KVS study)

1.	Configure DPUs on both the machines to link type as IB and off-path mode. Run the following from hosts-
sudo mlxconfig -d /dev/mst/mt41686_pciconf0 s INTERNAL_CPU_MODEL=0  
sudo mlxconfig -d /dev/mst/mt41686_pciconf0 s LINK_TYPE_P1=1
Power cycle the host.

2.	Download HERD and the required packages and ensure hugepages can be enabled (https://github.com/efficient/rdma_bench?tab=readme-ov-file#required-hardware-and-software) on both the hosts and DPUs.
git clone https://github.com/efficient/rdma_bench.git
cd herd
3.	Modify NUM_WORKERS in <herd_repo>/herd/main.h based on number of server threads used in Figure 8.
4.	Modify NUM_CLIENTS in <herd_repo>/herd/main.h and num_threads in <herd_repo>/herd/run-machine.sh based on whether the client is running on host or DPU. 3/6/9/12/16 for host, 4/8/12/16/20 for BF-1, and 1/2/4/8/12 for BF-2/3.
5.	Set the postlist in <herd_repo>/herd/run_server.sh to the number of client threads set in (#3).
6.	To measure latency we added the code on the client.c. The modifications to client.c are shown as diff in benchmarking/case_study/herd_client_diff file.
7.	Install HERD
make
8.	Then perform the required setting for HERD
  sudo echo 6192 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
  sudo bash -c "echo kernel.shmmax = 9223372036854775807 >> /etc/sysctl.conf"
  sudo bash -c "echo kernel.shmall = 1152921504606846720 >> /etc/sysctl.conf"
  sudo sysctl -p /etc/sysctl.conf
9.	To generate 100% GET, 95% GET, and 50% GET workloads, modify ‘update-percentage’ in <herd_repo>/herd/run-machine.sh to 0, 5, and 50, respectively.
10.	To run CD-SH (12) configuration, start HERD server on host. Here number in parentheses denotes the number of HERD server threads-
./run-server.sh
And start HERD client on DPU
./run-machine.sh 0

For CDH-SH (12) configuration, start HERD server on one host. Start HERD client on both another host and its DPU. The NUM_CLIENTS in <herd_repo>/herd/main.h on HERD server should be set to total number of clients on host and DPU for CDH-SH case.
Server
host1> ./run-server.sh

Clients
dpu> ./run-machine 0
host2> ./run-machine 1
Vary the client threads by modifying based on #3 to measure latency vs. throughput.

#### Experiment for Figure 9 (Off-path MICA KVS study)

1.	Configure DPUs on both the machines to link type as Ethernet and off-path mode. Run the following from hosts-
sudo mlxconfig -d /dev/mst/mt41686_pciconf0 s INTERNAL_CPU_MODEL=0  
sudo mlxconfig -d /dev/mst/mt41686_pciconf0 s LINK_TYPE_P1=2
Power cycle the host
2.	Etcd installation
On host
wget https://github.com/etcd-io/etcd/releases/download/v2.3.0/etcd-v2.3.0-linux-amd64.tar.gz
tar -xvzf etcd-v2.3.0-linux-amd64.tar.gz

    On DPU
wget https://github.com/etcd-io/etcd/releases/download/v3.2.1/etcd-v3.2.1-linux-arm64.tar.gz 
tar -xvzf etcd-v3.2.1-linux-arm64.tar.gz
3.	Start etcd.
On server. <ip_addr> refers to the IPv4 address of the host interface visible to the client machine.
cd etcd-v2.3.0-linux-amd64/
./etcd --initial-advertise-peer-urls http://<ip_addr>:2380 --listen-peer-urls http://<ip_addr>:2380 --listen-client-urls http://<ip_addr>:2379,http://127.0.0.1:2379 --advertise-client-urls http:// <ip_addr>:2379

    On DPU (needed for DPU-only). <ip_addr> refers to the IPv4 address of the out-of-band interface of DPU visible to the client machine.
    cd etcd-v3.2.1-linux-arm64/
    ETCD_UNSUPPORTED_ARCH=arm64 ./etcd --initial-advertise-peer-urls http://<ip_addr>:2380 --listen-peer-urls http://<ip_addr>:2380 --listen-client-urls http://<ip_addr>:2379,http://127.0.0.1:2379 --advertise-client-urls http://<ip_addr>:2379
4.	Download and build mica from https://github.com/efficient/mica2 and setup hugepages on server, client and DPUs:
sudo mica2/script/setup.sh 6392

5.	Modify config files for server, client and DPU.
When KVS server on host 
Edit "mac_addr" and "ipv4_addr" in server.json to the mac and IP address of the ethernet interface (enp1s0f0np0)
Edit "etcd_addr" to the IP address of where etcd is running.

    When KVS server on DPU
    Edit "mac_addr" and "ipv4_addr" in server.json to the mac and IP address of the ethernet interface (p0).
    Edit "etcd_addr" to the IP address of where etcd is running.
    
    When KVS client on host/DPU
    Edit "etcd_addr", "mac_addr", and "ipv4_addr" in netbench.json to point to the IPv4 address of the etcd running on either the server or the DPU, the mac and IP address of the ethernet interface (enp1s0f0np0) of the client machine, respectively.

6.	To run CH-SH (12) configuration, start MICA server on host. The sample config file used for MICA server and MICA client can be found under benchmarking/ study/mica_server.json and benchmarking/case_study/mica_netbench.json, respectively. The mica_server.json and mica_netbench.json configure MICA server and MICA client to run on 12 threads. These files can be modified to change the number of cores used by MICA KVS.

    To start MICA server on one host-
    sudo  mica2/build/server
    
    And start MICA client on another host-
    sudo mica2/build/netbench 0.00
    
    For CDH-SH (12) configuration, start MICA server on one host. Start MICA client on both another host and its DPU.
    Server
    host1> sudo  mica2/build/server
    
    Clients
    dpu> sudo mica2/build/netbench 0.00
    host2> sudo mica2/build/netbench 0.00

7.	To generate 100% GET, 95% GET, and 50% GET workloads, modify ‘get_ratio’ in mica_netbench.json to 1.00, 0.95, and 0.5, respectively.
Vary the client/server threads by modifying ‘lcores’ in netbench.json/server.json to measure latency vs. throughput.

#### Experiment for Table III (Hash performance on host and DPU)
1.	Download and install smhasher on host and DPU-
git clone https://github.com/rurban/smhasher
cd smhasher/src
mkdir build && cd build
cmake ..
make
2.	For example, to run Murmur3 of 128-bit width, run the following on host/DPU-
./SMHasher Murmur3C

The speed test reports the hash bandwidth for 256KB input and cycles/hash for 16-byte input. We convert cycles/hash to latency based on the time period of a single clock cycle on the respective core (host, BF-1, BF-2 or BF-3). The time period (1/frequency) for host, BF-1, BF-2 and BF-3 on our testbed is 0.3ns, 1.25ns, 0.4ns and 0.33ns, respectively.

The mapping between different hash functions and their widths to hash name can be found under smhasher/main.cpp. Hence, the performance of different hash functions can be tested via smhasher.

#### Experiment for Figure 10 (On-path KVS study)
1.	Follow steps 1-8 from off-path MICA KVS study to install and setup MICA KVS on both hosts.
2.	Configure DPU’s on-path submode<N> where N=1,2,3,4,5 by running the following on the DPU. For example, to configure DPU in on-path submode3, run the following on one the host-
sudo benchmarking/scripts/on-path/bf3/configure_on_path_submode3.sh
3.	Configure DPU in off-path mode in another host-
sudo mlxconfig -d /dev/mst/mt41686_pciconf0 s INTERNAL_CPU_MODEL=0
Power cycle the host.
4.	Run MICA server on the host where DPU is in on-path submode and MICA client on the other host where DPU is in off-path mode.
5.	To generate 100% GET, 95% GET, and 50% GET workloads, modify ‘get_ratio’ in mica_netbench.json to 1.00, 0.95, and 0.5, respectively.

Vary the client/server threads by modifying ‘lcores’ in netbench.json/server.json and DPU’s on-path submodes 1-5 to measure latency vs. throughput for different submodes.
