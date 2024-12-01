scp yuke@169.236.178.168:/tmp/buffer_info.txt .
scp yuke@169.236.178.168:/tmp/export_desc.txt .
echo ""

./doca_dma_copy_host -p 01:00.0 -d export_desc.txt -b buffer_info.txt