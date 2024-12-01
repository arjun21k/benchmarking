make clean && make
echo ""

./doca_dma_copy_host -d desc.txt -b buf.txt -p 01:00.0
