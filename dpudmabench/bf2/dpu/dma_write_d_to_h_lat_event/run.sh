scp arjun@padsys01:/opt/mellanox/doca/samples/doca_dma_test_2/host_dma_write_d_to_h_lat_event/buf.txt .
scp arjun@padsys01:/opt/mellanox/doca/samples/doca_dma_test_2/host_dma_write_d_to_h_lat_event/desc.txt .
echo ""

./doca_dma_copy_dpu -p 03:00.0 -d desc.txt -b buf.txt
