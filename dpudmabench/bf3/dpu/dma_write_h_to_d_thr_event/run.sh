len=$1
sed -i "/length =/c\  length = ${len};" dma_copy_dpu_main.c
make clean && make
echo ""

./doca_dma_copy_dpu -p 03:00.0
