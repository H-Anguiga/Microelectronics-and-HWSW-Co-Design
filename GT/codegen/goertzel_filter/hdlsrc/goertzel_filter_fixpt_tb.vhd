-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\anguiga\Desktop\GT\codegen\goertzel_filter\hdlsrc\goertzel_filter_fixpt_tb.vhd
-- Created: 2024-06-20 21:19:41
-- 
-- Generated by MATLAB 9.13, MATLAB Coder 5.5 and HDL Coder 4.0
-- 
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1
-- Target subsystem base rate: 1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: goertzel_filter_fixpt_tb
-- Source Path: 
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_textio.ALL;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY STD;
USE STD.textio.ALL;
LIBRARY work;
USE work.goertzel_filter_fixpt_pkg.ALL;
USE work.goertzel_filter_fixpt_tb_pkg.ALL;

ENTITY goertzel_filter_fixpt_tb IS
END goertzel_filter_fixpt_tb;


ARCHITECTURE rtl OF goertzel_filter_fixpt_tb IS

  -- Component Declarations
  COMPONENT goertzel_filter_fixpt
    PORT( input_signal                    :   IN    vector_of_std_logic_vector16(0 TO 134);  -- int16 [135]
          N                               :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          target_freq                     :   IN    std_logic_vector(17 DOWNTO 0);  -- ufix18
          sample_freq                     :   IN    std_logic_vector(21 DOWNTO 0);  -- ufix22
          output                          :   OUT   std_logic_vector(13 DOWNTO 0)  -- ufix14_E5
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : goertzel_filter_fixpt
    USE ENTITY work.goertzel_filter_fixpt(rtl);

  -- Signals
  SIGNAL clk                              : std_logic;
  SIGNAL reset                            : std_logic;
  SIGNAL enb                              : std_logic;
  SIGNAL output_done                      : std_logic;  -- ufix1
  SIGNAL rdEnb                            : std_logic;
  SIGNAL output_done_enb                  : std_logic;  -- ufix1
  SIGNAL output_addr                      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL output_active                    : std_logic;  -- ufix1
  SIGNAL check1_done                      : std_logic;  -- ufix1
  SIGNAL snkDonen                         : std_logic;
  SIGNAL resetn                           : std_logic;
  SIGNAL tb_enb                           : std_logic;
  SIGNAL ce_out                           : std_logic;
  SIGNAL output_enb                       : std_logic;  -- ufix1
  SIGNAL output_lastAddr                  : std_logic;  -- ufix1
  SIGNAL input_signal_addr                : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL input_signal_active              : std_logic;  -- ufix1
  SIGNAL input_signal_enb                 : std_logic;  -- ufix1
  SIGNAL input_signal_addr_delay_1        : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL rawData_input_signal             : vector_of_signed16(0 TO 134);  -- int16 [135]
  SIGNAL holdData_input_signal            : vector_of_signed16(0 TO 134);  -- int16 [135]
  SIGNAL rawData_N                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL holdData_N                       : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL rawData_target_freq              : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL holdData_target_freq             : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL rawData_sample_freq              : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL holdData_sample_freq             : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL input_signal_offset              : vector_of_signed16(0 TO 134);  -- int16 [135]
  SIGNAL input_signal_1                   : vector_of_signed16(0 TO 134);  -- int16 [135]
  SIGNAL input_signal_2                   : vector_of_std_logic_vector16(0 TO 134);  -- ufix16 [135]
  SIGNAL N_offset                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL N_1                              : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL N_2                              : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL target_freq_offset               : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL target_freq_1                    : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL target_freq_2                    : std_logic_vector(17 DOWNTO 0);  -- ufix18
  SIGNAL sample_freq_offset               : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL sample_freq_1                    : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL sample_freq_2                    : std_logic_vector(21 DOWNTO 0);  -- ufix22
  SIGNAL output_1                         : std_logic_vector(13 DOWNTO 0);  -- ufix14
  SIGNAL output_unsigned                  : unsigned(13 DOWNTO 0);  -- ufix14_E5
  SIGNAL output_expected_1                : unsigned(13 DOWNTO 0);  -- ufix14_E5
  SIGNAL output_ref                       : unsigned(13 DOWNTO 0);  -- ufix14_E5
  SIGNAL output_testFailure               : std_logic;  -- ufix1

BEGIN
  u_goertzel_filter_fixpt : goertzel_filter_fixpt
    PORT MAP( input_signal => input_signal_2,  -- int16 [135]
              N => N_2,  -- uint8
              target_freq => target_freq_2,  -- ufix18
              sample_freq => sample_freq_2,  -- ufix22
              output => output_1  -- ufix14_E5
              );

  output_done_enb <= output_done AND rdEnb;

  
  output_active <= '1' WHEN output_addr /= to_unsigned(16#2C#, 6) ELSE
      '0';

  enb <= rdEnb AFTER 2 ns;

  snkDonen <=  NOT check1_done;

  clk_gen: PROCESS 
  BEGIN
    clk <= '1';
    WAIT FOR 5 ns;
    clk <= '0';
    WAIT FOR 5 ns;
    IF check1_done = '1' THEN
      clk <= '1';
      WAIT FOR 5 ns;
      clk <= '0';
      WAIT FOR 5 ns;
      WAIT;
    END IF;
  END PROCESS clk_gen;

  reset_gen: PROCESS 
  BEGIN
    reset <= '1';
    WAIT FOR 20 ns;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT FOR 2 ns;
    reset <= '0';
    WAIT;
  END PROCESS reset_gen;

  resetn <=  NOT reset;

  tb_enb <= resetn AND snkDonen;

  
  rdEnb <= tb_enb WHEN check1_done = '0' ELSE
      '0';

  ce_out <= enb AND (rdEnb AND tb_enb);

  output_enb <= ce_out AND output_active;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 44
  output_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      output_addr <= to_unsigned(16#00#, 6);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF output_enb = '1' THEN
        IF output_addr >= to_unsigned(16#2C#, 6) THEN 
          output_addr <= to_unsigned(16#00#, 6);
        ELSE 
          output_addr <= output_addr + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS output_process;


  
  output_lastAddr <= '1' WHEN output_addr >= to_unsigned(16#2C#, 6) ELSE
      '0';

  output_done <= output_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_1_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check1_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF output_done_enb = '1' THEN
        check1_done <= output_done;
      END IF;
    END IF;
  END PROCESS checkDone_1_process;

  
  input_signal_active <= '1' WHEN input_signal_addr /= to_unsigned(16#2C#, 6) ELSE
      '0';

  input_signal_enb <= input_signal_active AND (rdEnb AND tb_enb);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 44
  input_signal_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      input_signal_addr <= to_unsigned(16#00#, 6);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF input_signal_enb = '1' THEN
        IF input_signal_addr >= to_unsigned(16#2C#, 6) THEN 
          input_signal_addr <= to_unsigned(16#00#, 6);
        ELSE 
          input_signal_addr <= input_signal_addr + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS input_signal_process;


  input_signal_addr_delay_1 <= input_signal_addr AFTER 1 ns;

  -- Data source for input_signal
  input_signal_fileread: PROCESS (input_signal_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "input_signal.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: vector_of_std_logic_vector16(0 TO 134);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data(0));
      HREAD(l, read_data(1));
      HREAD(l, read_data(2));
      HREAD(l, read_data(3));
      HREAD(l, read_data(4));
      HREAD(l, read_data(5));
      HREAD(l, read_data(6));
      HREAD(l, read_data(7));
      HREAD(l, read_data(8));
      HREAD(l, read_data(9));
      HREAD(l, read_data(10));
      HREAD(l, read_data(11));
      HREAD(l, read_data(12));
      HREAD(l, read_data(13));
      HREAD(l, read_data(14));
      HREAD(l, read_data(15));
      HREAD(l, read_data(16));
      HREAD(l, read_data(17));
      HREAD(l, read_data(18));
      HREAD(l, read_data(19));
      HREAD(l, read_data(20));
      HREAD(l, read_data(21));
      HREAD(l, read_data(22));
      HREAD(l, read_data(23));
      HREAD(l, read_data(24));
      HREAD(l, read_data(25));
      HREAD(l, read_data(26));
      HREAD(l, read_data(27));
      HREAD(l, read_data(28));
      HREAD(l, read_data(29));
      HREAD(l, read_data(30));
      HREAD(l, read_data(31));
      HREAD(l, read_data(32));
      HREAD(l, read_data(33));
      HREAD(l, read_data(34));
      HREAD(l, read_data(35));
      HREAD(l, read_data(36));
      HREAD(l, read_data(37));
      HREAD(l, read_data(38));
      HREAD(l, read_data(39));
      HREAD(l, read_data(40));
      HREAD(l, read_data(41));
      HREAD(l, read_data(42));
      HREAD(l, read_data(43));
      HREAD(l, read_data(44));
      HREAD(l, read_data(45));
      HREAD(l, read_data(46));
      HREAD(l, read_data(47));
      HREAD(l, read_data(48));
      HREAD(l, read_data(49));
      HREAD(l, read_data(50));
      HREAD(l, read_data(51));
      HREAD(l, read_data(52));
      HREAD(l, read_data(53));
      HREAD(l, read_data(54));
      HREAD(l, read_data(55));
      HREAD(l, read_data(56));
      HREAD(l, read_data(57));
      HREAD(l, read_data(58));
      HREAD(l, read_data(59));
      HREAD(l, read_data(60));
      HREAD(l, read_data(61));
      HREAD(l, read_data(62));
      HREAD(l, read_data(63));
      HREAD(l, read_data(64));
      HREAD(l, read_data(65));
      HREAD(l, read_data(66));
      HREAD(l, read_data(67));
      HREAD(l, read_data(68));
      HREAD(l, read_data(69));
      HREAD(l, read_data(70));
      HREAD(l, read_data(71));
      HREAD(l, read_data(72));
      HREAD(l, read_data(73));
      HREAD(l, read_data(74));
      HREAD(l, read_data(75));
      HREAD(l, read_data(76));
      HREAD(l, read_data(77));
      HREAD(l, read_data(78));
      HREAD(l, read_data(79));
      HREAD(l, read_data(80));
      HREAD(l, read_data(81));
      HREAD(l, read_data(82));
      HREAD(l, read_data(83));
      HREAD(l, read_data(84));
      HREAD(l, read_data(85));
      HREAD(l, read_data(86));
      HREAD(l, read_data(87));
      HREAD(l, read_data(88));
      HREAD(l, read_data(89));
      HREAD(l, read_data(90));
      HREAD(l, read_data(91));
      HREAD(l, read_data(92));
      HREAD(l, read_data(93));
      HREAD(l, read_data(94));
      HREAD(l, read_data(95));
      HREAD(l, read_data(96));
      HREAD(l, read_data(97));
      HREAD(l, read_data(98));
      HREAD(l, read_data(99));
      HREAD(l, read_data(100));
      HREAD(l, read_data(101));
      HREAD(l, read_data(102));
      HREAD(l, read_data(103));
      HREAD(l, read_data(104));
      HREAD(l, read_data(105));
      HREAD(l, read_data(106));
      HREAD(l, read_data(107));
      HREAD(l, read_data(108));
      HREAD(l, read_data(109));
      HREAD(l, read_data(110));
      HREAD(l, read_data(111));
      HREAD(l, read_data(112));
      HREAD(l, read_data(113));
      HREAD(l, read_data(114));
      HREAD(l, read_data(115));
      HREAD(l, read_data(116));
      HREAD(l, read_data(117));
      HREAD(l, read_data(118));
      HREAD(l, read_data(119));
      HREAD(l, read_data(120));
      HREAD(l, read_data(121));
      HREAD(l, read_data(122));
      HREAD(l, read_data(123));
      HREAD(l, read_data(124));
      HREAD(l, read_data(125));
      HREAD(l, read_data(126));
      HREAD(l, read_data(127));
      HREAD(l, read_data(128));
      HREAD(l, read_data(129));
      HREAD(l, read_data(130));
      HREAD(l, read_data(131));
      HREAD(l, read_data(132));
      HREAD(l, read_data(133));
      HREAD(l, read_data(134));
    END IF;
    rawData_input_signal <= (signed(read_data(0)(15 DOWNTO 0)), signed(read_data(1)(15 DOWNTO 0)), signed(read_data(2)(15 DOWNTO 0)), signed(read_data(3)(15 DOWNTO 0)), signed(read_data(4)(15 DOWNTO 0)), signed(read_data(5)(15 DOWNTO 0)), signed(read_data(6)(15 DOWNTO 0)), signed(read_data(7)(15 DOWNTO 0)), signed(read_data(8)(15 DOWNTO 0)), signed(read_data(9)(15 DOWNTO 0)), signed(read_data(10)(15 DOWNTO 0)), signed(read_data(11)(15 DOWNTO 0)), signed(read_data(12)(15 DOWNTO 0)), signed(read_data(13)(15 DOWNTO 0)), signed(read_data(14)(15 DOWNTO 0)), signed(read_data(15)(15 DOWNTO 0)), signed(read_data(16)(15 DOWNTO 0)), signed(read_data(17)(15 DOWNTO 0)), signed(read_data(18)(15 DOWNTO 0)), signed(read_data(19)(15 DOWNTO 0)), signed(read_data(20)(15 DOWNTO 0)), signed(read_data(21)(15 DOWNTO 0)), signed(read_data(22)(15 DOWNTO 0)), signed(read_data(23)(15 DOWNTO 0)), signed(read_data(24)(15 DOWNTO 0)), signed(read_data(25)(15 DOWNTO 0)), signed(read_data(26)(15 DOWNTO 0)), signed(read_data(27)(15 DOWNTO 0)), signed(read_data(28)(15 DOWNTO 0)), signed(read_data(29)(15 DOWNTO 0)), signed(read_data(30)(15 DOWNTO 0)), signed(read_data(31)(15 DOWNTO 0)), signed(read_data(32)(15 DOWNTO 0)), signed(read_data(33)(15 DOWNTO 0)), signed(read_data(34)(15 DOWNTO 0)), signed(read_data(35)(15 DOWNTO 0)), signed(read_data(36)(15 DOWNTO 0)), signed(read_data(37)(15 DOWNTO 0)), signed(read_data(38)(15 DOWNTO 0)), signed(read_data(39)(15 DOWNTO 0)), signed(read_data(40)(15 DOWNTO 0)), signed(read_data(41)(15 DOWNTO 0)), signed(read_data(42)(15 DOWNTO 0)), signed(read_data(43)(15 DOWNTO 0)), signed(read_data(44)(15 DOWNTO 0)), signed(read_data(45)(15 DOWNTO 0)), signed(read_data(46)(15 DOWNTO 0)), signed(read_data(47)(15 DOWNTO 0)), signed(read_data(48)(15 DOWNTO 0)), signed(read_data(49)(15 DOWNTO 0)), signed(read_data(50)(15 DOWNTO 0)), signed(read_data(51)(15 DOWNTO 0)), signed(read_data(52)(15 DOWNTO 0)), signed(read_data(53)(15 DOWNTO 0)), signed(read_data(54)(15 DOWNTO 0)), signed(read_data(55)(15 DOWNTO 0)), signed(read_data(56)(15 DOWNTO 0)), signed(read_data(57)(15 DOWNTO 0)), signed(read_data(58)(15 DOWNTO 0)), signed(read_data(59)(15 DOWNTO 0)), signed(read_data(60)(15 DOWNTO 0)), signed(read_data(61)(15 DOWNTO 0)), signed(read_data(62)(15 DOWNTO 0)), signed(read_data(63)(15 DOWNTO 0)), signed(read_data(64)(15 DOWNTO 0)), signed(read_data(65)(15 DOWNTO 0)), signed(read_data(66)(15 DOWNTO 0)), signed(read_data(67)(15 DOWNTO 0)), signed(read_data(68)(15 DOWNTO 0)), signed(read_data(69)(15 DOWNTO 0)), signed(read_data(70)(15 DOWNTO 0)), signed(read_data(71)(15 DOWNTO 0)), signed(read_data(72)(15 DOWNTO 0)), signed(read_data(73)(15 DOWNTO 0)), signed(read_data(74)(15 DOWNTO 0)), signed(read_data(75)(15 DOWNTO 0)), signed(read_data(76)(15 DOWNTO 0)), signed(read_data(77)(15 DOWNTO 0)), signed(read_data(78)(15 DOWNTO 0)), signed(read_data(79)(15 DOWNTO 0)), signed(read_data(80)(15 DOWNTO 0)), signed(read_data(81)(15 DOWNTO 0)), signed(read_data(82)(15 DOWNTO 0)), signed(read_data(83)(15 DOWNTO 0)), signed(read_data(84)(15 DOWNTO 0)), signed(read_data(85)(15 DOWNTO 0)), signed(read_data(86)(15 DOWNTO 0)), signed(read_data(87)(15 DOWNTO 0)), signed(read_data(88)(15 DOWNTO 0)), signed(read_data(89)(15 DOWNTO 0)), signed(read_data(90)(15 DOWNTO 0)), signed(read_data(91)(15 DOWNTO 0)), signed(read_data(92)(15 DOWNTO 0)), signed(read_data(93)(15 DOWNTO 0)), signed(read_data(94)(15 DOWNTO 0)), signed(read_data(95)(15 DOWNTO 0)), signed(read_data(96)(15 DOWNTO 0)), signed(read_data(97)(15 DOWNTO 0)), signed(read_data(98)(15 DOWNTO 0)), signed(read_data(99)(15 DOWNTO 0)), signed(read_data(100)(15 DOWNTO 0)), signed(read_data(101)(15 DOWNTO 0)), signed(read_data(102)(15 DOWNTO 0)), signed(read_data(103)(15 DOWNTO 0)), signed(read_data(104)(15 DOWNTO 0)), signed(read_data(105)(15 DOWNTO 0)), signed(read_data(106)(15 DOWNTO 0)), signed(read_data(107)(15 DOWNTO 0)), signed(read_data(108)(15 DOWNTO 0)), signed(read_data(109)(15 DOWNTO 0)), signed(read_data(110)(15 DOWNTO 0)), signed(read_data(111)(15 DOWNTO 0)), signed(read_data(112)(15 DOWNTO 0)), signed(read_data(113)(15 DOWNTO 0)), signed(read_data(114)(15 DOWNTO 0)), signed(read_data(115)(15 DOWNTO 0)), signed(read_data(116)(15 DOWNTO 0)), signed(read_data(117)(15 DOWNTO 0)), signed(read_data(118)(15 DOWNTO 0)), signed(read_data(119)(15 DOWNTO 0)), signed(read_data(120)(15 DOWNTO 0)), signed(read_data(121)(15 DOWNTO 0)), signed(read_data(122)(15 DOWNTO 0)), signed(read_data(123)(15 DOWNTO 0)), signed(read_data(124)(15 DOWNTO 0)), signed(read_data(125)(15 DOWNTO 0)), signed(read_data(126)(15 DOWNTO 0)), signed(read_data(127)(15 DOWNTO 0)), signed(read_data(128)(15 DOWNTO 0)), signed(read_data(129)(15 DOWNTO 0)), signed(read_data(130)(15 DOWNTO 0)), signed(read_data(131)(15 DOWNTO 0)), signed(read_data(132)(15 DOWNTO 0)), signed(read_data(133)(15 DOWNTO 0)), signed(read_data(134)(15 DOWNTO 0)));
  END PROCESS input_signal_fileread;

  -- holdData reg for input_signal
  stimuli_input_signal_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_input_signal <= (OTHERS => (OTHERS => 'X'));
    ELSIF clk'event AND clk = '1' THEN
      holdData_input_signal <= rawData_input_signal;
    END IF;
  END PROCESS stimuli_input_signal_process;

  -- Data source for N
  rawData_N <= to_unsigned(16#87#, 8);

  -- holdData reg for N
  stimuli_N_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_N <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_N <= rawData_N;
    END IF;
  END PROCESS stimuli_N_process;

  -- Data source for target_freq
  rawData_target_freq <= to_unsigned(16#249F0#, 18);

  -- holdData reg for target_freq
  stimuli_target_freq_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_target_freq <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_target_freq <= rawData_target_freq;
    END IF;
  END PROCESS stimuli_target_freq_process;

  -- Data source for sample_freq
  rawData_sample_freq <= to_unsigned(16#3D0900#, 22);

  -- holdData reg for sample_freq
  stimuli_sample_freq_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_sample_freq <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_sample_freq <= rawData_sample_freq;
    END IF;
  END PROCESS stimuli_sample_freq_process;

  stimuli_input_signal_1: PROCESS (rawData_input_signal, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      input_signal_offset <= holdData_input_signal;
    ELSE
      input_signal_offset <= rawData_input_signal;
    END IF;
  END PROCESS stimuli_input_signal_1;

  input_signal_1 <= input_signal_offset AFTER 2 ns;

  outputgen: FOR k IN 0 TO 134 GENERATE
    input_signal_2(k) <= std_logic_vector(input_signal_1(k));
  END GENERATE;

  stimuli_N_1: PROCESS (rawData_N, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      N_offset <= holdData_N;
    ELSE
      N_offset <= rawData_N;
    END IF;
  END PROCESS stimuli_N_1;

  N_1 <= N_offset AFTER 2 ns;

  N_2 <= std_logic_vector(N_1);

  stimuli_target_freq_1: PROCESS (rawData_target_freq, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      target_freq_offset <= holdData_target_freq;
    ELSE
      target_freq_offset <= rawData_target_freq;
    END IF;
  END PROCESS stimuli_target_freq_1;

  target_freq_1 <= target_freq_offset AFTER 2 ns;

  target_freq_2 <= std_logic_vector(target_freq_1);

  stimuli_sample_freq_1: PROCESS (rawData_sample_freq, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      sample_freq_offset <= holdData_sample_freq;
    ELSE
      sample_freq_offset <= rawData_sample_freq;
    END IF;
  END PROCESS stimuli_sample_freq_1;

  sample_freq_1 <= sample_freq_offset AFTER 2 ns;

  sample_freq_2 <= std_logic_vector(sample_freq_1);

  output_unsigned <= unsigned(output_1);

  -- Data source for output_expected
  output_expected_1 <= to_unsigned(16#0000#, 14);

  output_ref <= output_expected_1;

  output_unsigned_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      output_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND output_unsigned /= output_ref THEN
        output_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in output_unsigned: Expected " & to_hex(output_ref) & (" Actual " & to_hex(output_unsigned))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS output_unsigned_checker;

  completed_msg: PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF check1_done = '1' THEN
        IF output_testFailure = '0' THEN
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (PASSED)**************"
            SEVERITY NOTE;
        ELSE
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (FAILED)**************"
            SEVERITY NOTE;
        END IF;
      END IF;
    END IF;
  END PROCESS completed_msg;

END rtl;

