scp ubuntu@192.168.100.2:/opt/mellanox/doca/samples/doca_dma_test_2/dpu_dma_write_h_to_d_lat_event/desc.txt .
scp ubuntu@192.168.100.2:/opt/mellanox/doca/samples/doca_dma_test_2/dpu_dma_write_h_to_d_lat_event/buf.txt .
echo ""
./doca_dma_copy_host -d desc.txt -b buf.txt -p 01:00.0
