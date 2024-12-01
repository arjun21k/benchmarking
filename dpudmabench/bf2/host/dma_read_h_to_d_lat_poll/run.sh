scp ubuntu@192.168.100.2:/opt/mellanox/doca/samples/doca_dma_test_2/dma_write_dpu_lat/desc.txt .
scp ubuntu@192.168.100.2:/opt/mellanox/doca/samples/doca_dma_test_2/dma_write_dpu_lat/buf.txt .
echo ""
./doca_dma_copy_host -d desc.txt -b buf.txt -p 01:00.0
