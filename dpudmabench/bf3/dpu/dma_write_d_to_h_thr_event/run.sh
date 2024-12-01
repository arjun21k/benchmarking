scp yukeli@169.236.178.159:/tmp/buffer_info.txt .
scp yukeli@169.236.178.159:/tmp/export_desc.txt .
echo ""

./doca_dma_copy_host -p 03:00.0 -d export_desc.txt -b buffer_info.txt