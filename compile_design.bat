set QUARTUS_PROJECT_NAME=hil_dma

@echo off
echo ####################
echo ## Compiling FPGA ##
echo ####################
quartus_sh --flow compile %QUARTUS_PROJECT_NAME%
