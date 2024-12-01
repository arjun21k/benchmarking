make clean && make
echo ""

./doca_dma_copy_dpu -p 03:00.0 -d desc.txt -b buf.txt
