
# ad9122 interface

create_bd_port -dir I dac_clk_in_p
create_bd_port -dir I dac_clk_in_n
create_bd_port -dir O dac_clk_out_p
create_bd_port -dir O dac_clk_out_n
create_bd_port -dir O dac_frame_out_p
create_bd_port -dir O dac_frame_out_n
create_bd_port -dir O -from 15 -to 0 dac_data_out_p
create_bd_port -dir O -from 15 -to 0 dac_data_out_n

# ad9684 interface

create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n
create_bd_port -dir I -from 13 -to 0 adc_data_in_p
create_bd_port -dir I -from 13 -to 0 adc_data_in_n

# daq1 irq

create_bd_port -dir I spi_int

# dac peripherals

ad_ip_instance axi_ad9122 axi_ad9122_core

ad_ip_instance axi_dmac axi_ad9122_dma
ad_ip_parameter axi_ad9122_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9122_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter axi_ad9122_dma CONFIG.ID 0
ad_ip_parameter axi_ad9122_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9122_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9122_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9122_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9122_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9122_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance util_upack util_upack_ad9122
ad_ip_parameter util_upack_ad9122 CONFIG.CHANNEL_DATA_WIDTH 64
ad_ip_parameter util_upack_ad9122 CONFIG.NUM_OF_CHANNELS 2

# adc peripherals

ad_ip_instance axi_ad9684 axi_ad9684_core
ad_ip_parameter axi_ad9684_core CONFIG.OR_STATUS 0

ad_ip_instance axi_dmac axi_ad9684_dma
ad_ip_parameter axi_ad9684_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9684_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9684_dma CONFIG.ID 1
ad_ip_parameter axi_ad9684_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9684_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9684_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9684_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9684_dma CONFIG.FIFO_SIZE 16
ad_ip_parameter axi_ad9684_dma CONFIG.CYCLIC 0

ad_ip_instance util_cpack util_cpack_ad9684
ad_ip_parameter util_cpack_ad9684 CONFIG.CHANNEL_DATA_WIDTH 32
ad_ip_parameter util_cpack_ad9684 CONFIG.NUM_OF_CHANNELS 2

# connections (dac)

ad_connect  dac_clk axi_ad9122_core/dac_div_clk
ad_connect  dac_clk axi_ad9122_dma/fifo_rd_clk
ad_connect  dac_clk util_upack_ad9122/dac_clk

ad_connect  dac_clk_in_p axi_ad9122_core/dac_clk_in_p
ad_connect  dac_clk_in_n axi_ad9122_core/dac_clk_in_n
ad_connect  dac_clk_out_p axi_ad9122_core/dac_clk_out_p
ad_connect  dac_clk_out_n axi_ad9122_core/dac_clk_out_n
ad_connect  dac_frame_out_p axi_ad9122_core/dac_frame_out_p
ad_connect  dac_frame_out_n axi_ad9122_core/dac_frame_out_n
ad_connect  dac_data_out_p axi_ad9122_core/dac_data_out_p
ad_connect  dac_data_out_n axi_ad9122_core/dac_data_out_n

ad_connect  axi_ad9122_core/dac_enable_0 util_upack_ad9122/dac_enable_0
ad_connect  axi_ad9122_core/dac_ddata_0 util_upack_ad9122/dac_data_0
ad_connect  axi_ad9122_core/dac_valid_0 util_upack_ad9122/dac_valid_0
ad_connect  axi_ad9122_core/dac_enable_1 util_upack_ad9122/dac_enable_1
ad_connect  axi_ad9122_core/dac_ddata_1 util_upack_ad9122/dac_data_1
ad_connect  axi_ad9122_core/dac_valid_1 util_upack_ad9122/dac_valid_1
ad_connect  axi_ad9122_core/dac_dunf axi_ad9122_dma/fifo_rd_underflow

ad_connect  util_upack_ad9122/dac_valid axi_ad9122_dma/fifo_rd_en
ad_connect  util_upack_ad9122/dac_data axi_ad9122_dma/fifo_rd_dout
ad_connect  util_upack_ad9122/dac_sync axi_ad9122_core/dac_sync_in

# connections (adc)

ad_connect  adc_clk axi_ad9684_core/adc_clk
ad_connect  sys_200m_clk axi_ad9684_core/delay_clk
ad_connect  sys_cpu_clk axi_ad9684_dma/s_axis_aclk
ad_connect  adc_clk util_cpack_ad9684/adc_clk

ad_connect  adc_clk_in_p axi_ad9684_core/adc_clk_in_p
ad_connect  adc_clk_in_n axi_ad9684_core/adc_clk_in_n
ad_connect  axi_ad9684_core/adc_data_or_p GND
ad_connect  axi_ad9684_core/adc_data_or_n GND
ad_connect  adc_data_in_p axi_ad9684_core/adc_data_in_p
ad_connect  adc_data_in_n axi_ad9684_core/adc_data_in_n

ad_connect  axi_ad9684_core/adc_rst util_cpack_ad9684/adc_rst
ad_connect  axi_ad9684_core/adc_enable_0 util_cpack_ad9684/adc_enable_0
ad_connect  axi_ad9684_core/adc_valid_0 util_cpack_ad9684/adc_valid_0
ad_connect  axi_ad9684_core/adc_data_0 util_cpack_ad9684/adc_data_0
ad_connect  axi_ad9684_core/adc_enable_1 util_cpack_ad9684/adc_enable_1
ad_connect  axi_ad9684_core/adc_valid_1 util_cpack_ad9684/adc_valid_1
ad_connect  axi_ad9684_core/adc_data_1 util_cpack_ad9684/adc_data_1
ad_connect  axi_ad9684_core/adc_dovf axi_ad9684_fifo/adc_wovf

ad_connect  adc_clk axi_ad9684_fifo/adc_clk
ad_connect  sys_cpu_clk axi_ad9684_fifo/dma_clk
ad_connect  axi_ad9684_core/adc_rst axi_ad9684_fifo/adc_rst
ad_connect  util_cpack_ad9684/adc_valid axi_ad9684_fifo/adc_wr
ad_connect  util_cpack_ad9684/adc_data axi_ad9684_fifo/adc_wdata
ad_connect  axi_ad9684_fifo/dma_wr axi_ad9684_dma/s_axis_valid
ad_connect  axi_ad9684_fifo/dma_wdata axi_ad9684_dma/s_axis_data
ad_connect  axi_ad9684_fifo/dma_wready axi_ad9684_dma/s_axis_ready
ad_connect  axi_ad9684_fifo/dma_xfer_req axi_ad9684_dma/s_axis_xfer_req


# memory interconnect

ad_cpu_interconnect 0x44A00000 axi_ad9122_core
ad_cpu_interconnect 0x44A20000 axi_ad9684_core
ad_cpu_interconnect 0x44A40000 axi_ad9122_dma
ad_cpu_interconnect 0x44A60000 axi_ad9684_dma
ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_200m_clk axi_ad9684_dma/m_dest_axi
ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9122_dma/m_src_axi

ad_connect  sys_cpu_resetn axi_ad9684_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9122_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-11 mb-11 spi_int
ad_cpu_interrupt ps-12 mb-12 axi_ad9122_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9684_dma/irq

