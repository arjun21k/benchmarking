len=$1
sed -i "/length =/c\  length = ${len};" dma_copy_host_main.c

make clean
make
echo ""

./doca_dma_copy_host -p 01:00.0
