------------------------------------------------------------------------------
--  Copyright (c) 2020 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler, Daniele Felici
------------------------------------------------------------------------------

------------------------------------------------------------
-- Testbench generated by TbGen.py
------------------------------------------------------------
-- see Library/Python/TbGenerator

------------------------------------------------------------
-- Libraries
------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.psi_common_math_pkg.all;
	use work.psi_common_logic_pkg.all;
	use work.psi_common_array_pkg.all;
	use work.psi_tb_compare_pkg.all;	

------------------------------------------------------------
-- Entity Declaration
------------------------------------------------------------
entity psi_common_tdm_par_cfg_tb is
end entity;

------------------------------------------------------------
-- Architecture
------------------------------------------------------------
architecture sim of psi_common_tdm_par_cfg_tb is
	-- *** Fixed Generics ***
	constant ChannelCount_g : natural := 3;
	constant ChannelWidth_g : natural := 8;
	
	-- *** Not Assigned Generics (default values) ***
	
	-- *** TB Control ***
	signal TbRunning : boolean := True;
	signal ProcessDone : std_logic_vector(0 to 1) := (others => '0');
	constant AllProcessesDone_c : std_logic_vector(0 to 1) := (others => '1');
	constant TbProcNr_inp_c : integer := 0;
	constant TbProcNr_outp_c : integer := 1;
	
	-- *** DUT Signals ***
	signal Clk : std_logic := '1';
	signal Rst : std_logic := '1';
	signal EnabledChannels : natural range 0 to ChannelCount_g := ChannelCount_g;
	signal Tdm : std_logic_vector(ChannelWidth_g-1 downto 0) := (others => '0');
	signal TdmVld : std_logic := '0';
	signal TdmLast : std_logic := '0';
	signal Parallel : std_logic_vector(ChannelCount_g*ChannelWidth_g-1 downto 0) := (others => '0');
	signal ParallelVld : std_logic := '0';
	
	
	-- handwritten
	signal TestCase	: integer := -1;
		
	procedure Expect3Channels(	Values : in t_ainteger(0 to 2)) is
	begin
		wait until rising_edge(Clk) and ParallelVld = '1';
		StdlvCompareInt (Values(0), Parallel(1*ChannelWidth_g-1 downto 0*ChannelWidth_g), "Wrong value Channel 0", false);	
		StdlvCompareInt (Values(1), Parallel(2*ChannelWidth_g-1 downto 1*ChannelWidth_g), "Wrong value Channel 1", false);	
		StdlvCompareInt (Values(2), Parallel(3*ChannelWidth_g-1 downto 2*ChannelWidth_g), "Wrong value Channel 2", false);	
	end procedure;
	
	procedure Expect2Channels( Values : in t_ainteger(0 to 1)) is
  begin
    wait until rising_edge(Clk) and ParallelVld = '1';
    StdlvCompareInt (Values(0), Parallel(1*ChannelWidth_g-1 downto 0*ChannelWidth_g), "Wrong value Channel 0", false);  
    StdlvCompareInt (Values(1), Parallel(2*ChannelWidth_g-1 downto 1*ChannelWidth_g), "Wrong value Channel 1", false);
  end procedure;	
  
  procedure Expect1Channel( Value : in integer) is
  begin
    wait until rising_edge(Clk) and ParallelVld = '1';
    StdlvCompareInt (Value, Parallel(1*ChannelWidth_g-1 downto 0*ChannelWidth_g), "Wrong value Channel 0", false);  
  end procedure;
	
begin
	------------------------------------------------------------
	-- DUT Instantiation
	------------------------------------------------------------
	i_dut : entity work.psi_common_tdm_par_cfg
		generic map (
			ChannelCount_g => ChannelCount_g,
			ChannelWidth_g => ChannelWidth_g
		)
		port map (
			Clk => Clk,
			Rst => Rst,
			EnabledChannels => EnabledChannels,
			Tdm => Tdm,
			TdmVld => TdmVld,
			TdmLast => TdmLast,
			Parallel => Parallel,
			ParallelVld => ParallelVld
		);
	
	------------------------------------------------------------
	-- Testbench Control !DO NOT EDIT!
	------------------------------------------------------------
	p_tb_control : process
	begin
		wait until Rst = '0';
		wait until ProcessDone = AllProcessesDone_c;
		TbRunning <= false;
		wait;
	end process;
	
	------------------------------------------------------------
	-- Clocks !DO NOT EDIT!
	------------------------------------------------------------
	p_clock_Clk : process
		constant Frequency_c : real := real(100e6);
	begin
		while TbRunning loop
			wait for 0.5*(1 sec)/Frequency_c;
			Clk <= not Clk;
		end loop;
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Resets
	------------------------------------------------------------
	p_rst_Rst : process
	begin
		wait for 1 us;
		-- Wait for two clk edges to ensure reset is active for at least one edge
		wait until rising_edge(Clk);
		wait until rising_edge(Clk);
		Rst <= '0';
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Processes
	------------------------------------------------------------
	-- *** inp ***
	p_inp : process
	begin
		-- start of process !DO NOT EDIT
		wait until Rst = '0';
		
		-- *** TdmLast not used ***
		-- *** max input length (EnabledChannels = ChannelCount_g) ***
		-- *** Samples with much space in between ***
		TestCase <= 0;
		EnabledChannels <= ChannelCount_g;
		wait until rising_edge(Clk);
		for sample in 0 to 3 loop
			for channel in 0 to 2 loop
				TdmVld <= '1';
				Tdm <= std_logic_vector(to_unsigned(channel*16#10#+sample, Tdm'length));
				wait until rising_edge(Clk);
				TdmVld <= '0';
				Tdm <= (others => '0');
				for del in 0 to 9 loop
					wait until rising_edge(Clk);
				end loop;
			end loop;
		end loop;
		
		-- *** Samples back to back ***
		TestCase <= 1;
		wait until rising_edge(Clk);	
		TdmVld <= '1';		
		for sample in 0 to 3 loop
			for channel in 0 to 2 loop				
				Tdm <= std_logic_vector(to_unsigned(16#50# + channel*16#10#+sample, Tdm'length));
				wait until rising_edge(Clk);
			end loop;
		end loop;	
		TdmVld <= '0';		
		
		wait for 100 ns ;
		-- *** Input length is 2 (EnabledChannels = ChannelCount_g - 1) ***
    -- *** Samples with much space in between ***
    TestCase <= 2;
    EnabledChannels <= ChannelCount_g - 1;
    wait until rising_edge(Clk);
    for sample in 0 to 3 loop
      for channel in 0 to 1 loop
        TdmVld <= '1';
        Tdm <= std_logic_vector(to_unsigned(channel*16#10#+sample, Tdm'length));
        wait until rising_edge(Clk);
        TdmVld <= '0';
        Tdm <= (others => '0');
        for del in 0 to 9 loop
          wait until rising_edge(Clk);
        end loop;
      end loop;
    end loop;
    
    -- *** Samples back to back ***
    TestCase <= 3;
    wait until rising_edge(Clk);  
    TdmVld <= '1';    
    for sample in 0 to 3 loop
      for channel in 0 to 1 loop        
        Tdm <= std_logic_vector(to_unsigned(16#50# + channel*16#10#+sample, Tdm'length));
        wait until rising_edge(Clk);
      end loop;
    end loop; 
    TdmVld <= '0';  
		
		wait for 100 ns ;
		-- *** Input length is 1 (EnabledChannels = ChannelCount_g - 2) ***
    -- *** Samples with much space in between ***
    TestCase <= 4;
    EnabledChannels <= ChannelCount_g - 2;
    wait until rising_edge(Clk);
    for sample in 0 to 3 loop
      TdmVld <= '1';
      Tdm <= std_logic_vector(to_unsigned(sample, Tdm'length));
      wait until rising_edge(Clk);
      TdmVld <= '0';
      Tdm <= (others => '0');
      for del in 0 to 9 loop
        wait until rising_edge(Clk);
      end loop;
    end loop;
    
    -- *** Samples back to back ***
    TestCase <= 5;
    wait until rising_edge(Clk);  
    TdmVld <= '1';    
    for sample in 0 to 3 loop       
      Tdm <= std_logic_vector(to_unsigned(16#50#+sample, Tdm'length));
      wait until rising_edge(Clk);
    end loop; 
    TdmVld <= '0'; 
		
		wait for 100 ns ;
		-- *** TdmLast test ***
    -- *** max input length (EnabledChannels = ChannelCount_g) ***
    -- *** Samples with much space in between ***
    TestCase <= 6;
    EnabledChannels <= ChannelCount_g;
    wait until rising_edge(Clk);
    for sample in 0 to 3 loop
      for channel in 0 to 2 loop
        TdmVld <= '1';
        Tdm <= std_logic_vector(to_unsigned(channel*16#10#+sample, Tdm'length));
        if channel = 2 then
          TdmLast <= '1';
        else
          TdmLast <= '0';
        end if;
        wait until rising_edge(Clk);
        TdmVld <= '0';
        Tdm <= (others => '0');
        TdmLast <= '0';
        for del in 0 to 9 loop
          wait until rising_edge(Clk);
        end loop;
      end loop;
    end loop;
    
    -- *** Samples back to back ***
    TestCase <= 7;
    wait until rising_edge(Clk);  
    TdmVld <= '1';    
    for sample in 0 to 3 loop
      for channel in 0 to 2 loop
        Tdm <= std_logic_vector(to_unsigned(16#50# + channel*16#10#+sample, Tdm'length));       
        if channel = 2 then 
          TdmLast <= '1';
        else
          TdmLast <= '0';
        end if;
        wait until rising_edge(Clk);
      end loop;
    end loop; 
    TdmLast <= '0';
    TdmVld <= '0';    
    
    wait for 100 ns ;
    -- *** Input length is 2 (EnabledChannels = ChannelCount_g - 1) ***
    -- *** Samples with much space in between ***
    TestCase <= 8;
    EnabledChannels <= ChannelCount_g - 1;
    wait until rising_edge(Clk);
    for sample in 0 to 3 loop
      for channel in 0 to 1 loop
        TdmVld <= '1';
        Tdm <= std_logic_vector(to_unsigned(channel*16#10#+sample, Tdm'length));
        if channel = 1 then
          TdmLast <= '1';
        else
          TdmLast <= '0';
        end if;
        wait until rising_edge(Clk);
        TdmVld <= '0';
        Tdm <= (others => '0');
        TdmLast <= '0';
        for del in 0 to 9 loop
          wait until rising_edge(Clk);
        end loop;
      end loop;
    end loop;
    
    -- *** Samples back to back ***
    TestCase <= 9;
    wait until rising_edge(Clk);  
    TdmVld <= '1';    
    for sample in 0 to 3 loop
      for channel in 0 to 1 loop
        Tdm <= std_logic_vector(to_unsigned(16#50# + channel*16#10#+sample, Tdm'length));
        if channel = 1 then 
          TdmLast <= '1';
        else
          TdmLast <= '0';
        end if;
        wait until rising_edge(Clk);
      end loop;
    end loop; 
    TdmLast <= '0';
    TdmVld <= '0';  
    
    wait for 100 ns ;
    -- *** Input length is 1 (EnabledChannels = ChannelCount_g - 2) ***
    -- *** Samples with much space in between ***
    TestCase <= 10;
    EnabledChannels <= ChannelCount_g - 2;
    wait until rising_edge(Clk);
    for sample in 0 to 3 loop
      TdmVld <= '1';
      Tdm <= std_logic_vector(to_unsigned(sample, Tdm'length));
      TdmLast <= '1';
      wait until rising_edge(Clk);
      TdmVld <= '0';
      Tdm <= (others => '0');
      TdmLast <= '0';
      for del in 0 to 9 loop
        wait until rising_edge(Clk);
      end loop;
    end loop;
    
    -- *** Samples back to back ***
    TestCase <= 11;
    wait until rising_edge(Clk);  
    TdmVld <= '1';   
    for sample in 0 to 3 loop       
      Tdm <= std_logic_vector(to_unsigned(16#50#+sample, Tdm'length)); 
      TdmLast <= '1';
      wait until rising_edge(Clk); 
    end loop;
    TdmLast <= '0'; 
    TdmVld <= '0';
		
		-- end of process !DO NOT EDIT!
		ProcessDone(TbProcNr_inp_c) <= '1';
		wait;
	end process;
	
	-- *** outp ***
	p_outp : process
	begin
		-- start of process !DO NOT EDIT
		wait until Rst = '0';
		
		-- *** Test without TdmLast used ***
		-- *** max input length (EnabledChannels = ChannelCount_g) ***
		-- *** Samples with much space in between ***
		wait until TestCase = 0;
		for sample in 0 to 3 loop
			Expect3Channels((16#00#+sample, 16#10#+sample, 16#20#+sample));
		end loop;
		
		-- *** Samples back to back ***
		wait until TestCase = 1;
		for sample in 0 to 3 loop
			Expect3Channels((16#50#+sample, 16#60#+sample, 16#70#+sample));
		end loop;		
		
		-- *** Input length is 2 (EnabledChannels = ChannelCount_g - 1) ***
		-- *** Samples with much space in between ***
    wait until TestCase = 2;
    for sample in 0 to 3 loop
      Expect2Channels((16#00#+sample, 16#10#+sample));
    end loop;
    
    -- *** Samples back to back ***
    wait until TestCase = 3;
    for sample in 0 to 3 loop
      Expect2Channels((16#50#+sample, 16#60#+sample));
    end loop; 
		
		-- *** Input length is 1 (EnabledChannels = ChannelCount_g - 2) ***
    -- *** Samples with much space in between ***
    wait until TestCase = 4;
    for sample in 0 to 3 loop
      Expect1Channel((16#00#+sample));
    end loop;
    
    -- *** Samples back to back ***
    wait until TestCase = 5;
    for sample in 0 to 3 loop
      Expect1Channel((16#50#+sample));
    end loop;
    
    -- *** Test using TdmLast ***
    -- *** max input length (EnabledChannels = ChannelCount_g) ***
    -- *** Samples with much space in between ***
    wait until TestCase = 6;
    for sample in 0 to 3 loop
      Expect3Channels((16#00#+sample, 16#10#+sample, 16#20#+sample));
    end loop;
    
    -- *** Samples back to back ***
    wait until TestCase = 7;
    for sample in 0 to 3 loop
      Expect3Channels((16#50#+sample, 16#60#+sample, 16#70#+sample));
    end loop;   
    
    -- *** Input length is 2 (EnabledChannels = ChannelCount_g - 1) ***
    -- *** Samples with much space in between ***
    wait until TestCase = 8;
    for sample in 0 to 3 loop
      Expect2Channels((16#00#+sample, 16#10#+sample));
    end loop;
    
    -- *** Samples back to back ***
    wait until TestCase = 9;
    for sample in 0 to 3 loop
      Expect2Channels((16#50#+sample, 16#60#+sample));
    end loop; 
    
    -- *** Input length is 1 (EnabledChannels = ChannelCount_g - 2) ***
    -- *** Samples with much space in between ***
    wait until TestCase = 10;
    for sample in 0 to 3 loop
      Expect1Channel((16#00#+sample));
    end loop;
    
    -- *** Samples back to back ***
    wait until TestCase = 11;
    for sample in 0 to 3 loop
      Expect1Channel((16#50#+sample));
    end loop; 
		
		-- end of process !DO NOT EDIT!
		ProcessDone(TbProcNr_outp_c) <= '1';
		wait;
	end process;
	
	
end;
