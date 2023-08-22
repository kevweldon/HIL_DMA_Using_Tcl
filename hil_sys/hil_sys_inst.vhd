	component hil_sys is
		port (
			clk_clk                : in  std_logic := 'X'; -- clk
			reset_reset            : in  std_logic := 'X'; -- reset
			sink_dma_csr_irq_irq   : out std_logic;        -- irq
			source_dma_csr_irq_irq : out std_logic         -- irq
		);
	end component hil_sys;

	u0 : component hil_sys
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --                clk.clk
			reset_reset            => CONNECTED_TO_reset_reset,            --              reset.reset
			sink_dma_csr_irq_irq   => CONNECTED_TO_sink_dma_csr_irq_irq,   --   sink_dma_csr_irq.irq
			source_dma_csr_irq_irq => CONNECTED_TO_source_dma_csr_irq_irq  -- source_dma_csr_irq.irq
		);

