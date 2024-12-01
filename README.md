DPU refers to BlueField-1/BlueField-2/BlueField-3 i.e., any steps mentioned for DPU are applicable for BlueField-1, BlueField-2 and BlueField, unless otherwise stated. Each folder represents experiments to test different aspects of DPU. Experiment specific instructions can be found in each folder's readme.

#### Pre-requisites on host (x86)
OS: AlmaLinux 8.5 (Linux 4.18.0)
gcc (tested with 8.5.0)
Linux InfiniBand drivers (OFED -5.5 for BF-1, OFED-5.8 for BF-2, OFED-23.1 for BF-3)
NVIDIA DOCA SDK (v1.5.0 for BF-2, v2.5.0 for BF-3)
iperf 3.5
DPDK v21.08 
DPDK pktgen-21.02.0
STREAM 5.10 
tinymembench v0.4
smhasher 
HERD 
MICA

#### Pre-requisites on DPU 
OS: Ubuntu 20.04.5 (Linux 5.4.0-1049-bluefield) for BF1/2
OS: Ubuntu 22.04 (Linux 5.15-bluefield) for BF3
gcc (tested with 9.4.0)
Linux InfiniBand drivers (OFED -5.5 for BF-1, OFED-5.8 for BF-2, OFED-23.1 for BF-3)
NVIDIA DOCA SDK (v1.5.0 for BF-2, v2.5.0 for BF-3)
DPDK v21.08 
STREAM 5.10
tinymembench v0.4
smhasher 
HERD
MICA

RDMA perftest tool installed automatically with InfiniBand drivers

#### DPDK installation on host/DPU
1.	Prerequisite libraries
a.	Python v3.6.8
b.	meson v0.61.5
c.	ninja 1.10.2.git.kitware.jobserver-1
d.	pyelftools v0.29
2.	Steps
a.	git clone https://github.com/DPDK/dpdk.git
b.	cd dpdk
c.	git checkout tags/v21.08
d.	mkdir x86_64-native-linux-gcc
e.	meson -Dexamples=all --prefix=/home/<user>/dpdk/x86_64-native-linux-gcc build
where <user> indicates the name of the user directory on the machine. For DPU, prefix could be '--prefix=/home/<user>/dpdk/arm64-bluefield-linux-gcc-build build'
f.	cd build
g.	ninja
h.	ninja install
i.	sudo ldconfig

For all experiments, disable firewall on hosts as follows:
sudo systemctl stop firewalld
Assign a static IP address when DPU’s link type is set to Ethernet-
On DPU’s ethernet port (enp1s0f0np0) on host and client machines
sudo ifconfig enp1s0f0np0 <some_static_ipv4_addr> netmask 255.255.255.0
Assign a static IP address to port (p0) on DPU
sudo ifconfig p0 <some_static_ipv4_addr> netmask 255.255.255.0
