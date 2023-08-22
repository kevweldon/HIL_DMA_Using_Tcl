# Kevin Weldon - 11/18/20
#
# Descriptor Format
#
# 0x00 RD_ADDR[31:0]
# 0x04 WR_ADDR[31:0]
# 0x08 LEN[31:0]
# 0x0c WR_BURST_CNT[7:0], RD_BURST_CNT[7:0], SEQ_NUM[15:0]
# 0x10 WR_STRIDE[15:0], RD_STRIDE[15:0]

# CSR Descriptor Map
#
# 0x00 STATUS[31:0] | bit[1]=Empty,bit[0]=Busy
# 0x04 CONTROL[31:0]
# 0x08 WR_FILL_LVL[15:0], RD_FILL_LVL[15:0]
# 0x0c reserved[15:0], RESP_FILL_LVL[15:0]
# 0x10 WR_SEQ_NUM[15:0], RD_SEQ_NUM[15:0]
# 0x14 COMP_CONFIG_1[31:0]
# 0x18 COMP_CONFIG_2[31:0]
# 0x1c reserved[15:0], COMP_TYPE[7:0], COMP_VER[7:0]

proc main {} {
    set SOURCE_DMA_DESC_ADDR 0x10000000
    set SOURCE_DMA_CSR_ADDR  0x11000000
    set SINK_DMA_DESC_ADDR   0x20000000
    set SINK_DMA_CSR_ADDR    0x21000000

    set SOURCE_DATA_ADDR     0x00000000
    set SINK_DATA_ADDR       0x00001000

    # Open the service path
    puts "Opening JTAG master service path..."
    set jm [ lindex [ get_service_paths master ] 0 ]
    open_service master $jm

    # Fill the read buffer
    puts "Initializing read DMA buffer..."
    master_write_32 $jm $SOURCE_DATA_ADDR [ list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 ]
    
    # Clear the write buffer
    puts "Clearing write DMA buffer..."
    master_write_32 $jm $SINK_DATA_ADDR [ list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]
    
    puts "DMA buffers initialized and cleared."
    puts "Reading source RAM data:"
    puts [ format [ master_read_32 $jm $SOURCE_DATA_ADDR 32 ] ]
    puts "Reading sink RAM data:"
    puts [ format [ master_read_32 $jm $SINK_DATA_ADDR 32 ] ]
    
    # Program write descriptor
    puts "Reading Sink DMA status..."
    puts [ format [ master_read_32 $jm [expr $SINK_DMA_CSR_ADDR] 1 ] ]
    puts "Program write DMA descriptor..."
    master_write_32 $jm [expr $SINK_DMA_DESC_ADDR + 0x4] $SINK_DATA_ADDR
    master_write_32 $jm [expr $SINK_DMA_DESC_ADDR + 0x8] 0x00000080
    master_write_32 $jm [expr $SINK_DMA_DESC_ADDR + 0xc] 0x80000000
    puts "Reading Sink DMA status..."
    puts [ format [ master_read_32 $jm [expr $SINK_DMA_CSR_ADDR] 1 ] ]

    # Program read descriptor
    puts "Program read DMA descriptor..."
    master_write_32 $jm [expr $SOURCE_DMA_DESC_ADDR]       $SOURCE_DATA_ADDR
    master_write_32 $jm [expr $SOURCE_DMA_DESC_ADDR + 0x8] 0x00000080
    master_write_32 $jm [expr $SOURCE_DMA_DESC_ADDR + 0xc] 0x80000000
    
    puts "Sending test data to Device Under Test"
    
    # Display updated buffers
    puts "DMA buffers:"
    puts "Reading source RAM data:"
    puts [ format [ master_read_32 $jm $SOURCE_DATA_ADDR 32 ] ]
    puts "Reading sink RAM data:"
    puts [ format [ master_read_32 $jm $SINK_DATA_ADDR 32 ] ]
    
    # Close connection to FPGA target
    puts "Close connection to FPGA target"
    close_service master $jm
}

proc read_desc_csr {BASE_ADDR JM} {
    for {set i 0} {$i < 8} {incr i} {
	puts [ format [ master_read_32 $JM [expr $BASE_ADDR + ($i*4)] 1 ] ]
    }
    return
}

main
