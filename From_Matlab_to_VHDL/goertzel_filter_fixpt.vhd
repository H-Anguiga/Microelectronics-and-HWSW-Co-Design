
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.goertzel_filter_fixpt_pkg.ALL;

ENTITY goertzel_filter_fixpt IS
  PORT( input_signal                      :   IN    vector_of_std_logic_vector16(0 TO 134);  -- sfix16 [135]
        N                                 :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8
        target_freq                       :   IN    std_logic_vector(17 DOWNTO 0);  -- ufix18
        sample_freq                       :   IN    std_logic_vector(21 DOWNTO 0);  -- ufix22
        output                            :   OUT   std_logic_vector(13 DOWNTO 0)  -- ufix14_E5
        );
END goertzel_filter_fixpt;


ARCHITECTURE rtl OF goertzel_filter_fixpt IS

  -- Constants
  CONSTANT nc                             : vector_of_signed16(0 TO 255) := 
    (to_signed(16#0000#, 16), to_signed(16#0324#, 16), to_signed(16#0648#, 16), to_signed(16#096B#, 16),
     to_signed(16#0C8C#, 16), to_signed(16#0FAB#, 16), to_signed(16#12C8#, 16), to_signed(16#15E2#, 16),
     to_signed(16#18F9#, 16), to_signed(16#1C0C#, 16), to_signed(16#1F1A#, 16), to_signed(16#2224#, 16),
     to_signed(16#2528#, 16), to_signed(16#2827#, 16), to_signed(16#2B1F#, 16), to_signed(16#2E11#, 16),
     to_signed(16#30FC#, 16), to_signed(16#33DF#, 16), to_signed(16#36BA#, 16), to_signed(16#398D#, 16),
     to_signed(16#3C57#, 16), to_signed(16#3F17#, 16), to_signed(16#41CE#, 16), to_signed(16#447B#, 16),
     to_signed(16#471D#, 16), to_signed(16#49B4#, 16), to_signed(16#4C40#, 16), to_signed(16#4EC0#, 16),
     to_signed(16#5134#, 16), to_signed(16#539B#, 16), to_signed(16#55F6#, 16), to_signed(16#5843#, 16),
     to_signed(16#5A82#, 16), to_signed(16#5CB4#, 16), to_signed(16#5ED7#, 16), to_signed(16#60EC#, 16),
     to_signed(16#62F2#, 16), to_signed(16#64E9#, 16), to_signed(16#66D0#, 16), to_signed(16#68A7#, 16),
     to_signed(16#6A6E#, 16), to_signed(16#6C24#, 16), to_signed(16#6DCA#, 16), to_signed(16#6F5F#, 16),
     to_signed(16#70E3#, 16), to_signed(16#7255#, 16), to_signed(16#73B6#, 16), to_signed(16#7505#, 16),
     to_signed(16#7642#, 16), to_signed(16#776C#, 16), to_signed(16#7885#, 16), to_signed(16#798A#, 16),
     to_signed(16#7A7D#, 16), to_signed(16#7B5D#, 16), to_signed(16#7C2A#, 16), to_signed(16#7CE4#, 16),
     to_signed(16#7D8A#, 16), to_signed(16#7E1E#, 16), to_signed(16#7E9D#, 16), to_signed(16#7F0A#, 16),
     to_signed(16#7F62#, 16), to_signed(16#7FA7#, 16), to_signed(16#7FD9#, 16), to_signed(16#7FF6#, 16),
     to_signed(16#7FFF#, 16), to_signed(16#7FF6#, 16), to_signed(16#7FD9#, 16), to_signed(16#7FA7#, 16),
     to_signed(16#7F62#, 16), to_signed(16#7F0A#, 16), to_signed(16#7E9D#, 16), to_signed(16#7E1E#, 16),
     to_signed(16#7D8A#, 16), to_signed(16#7CE4#, 16), to_signed(16#7C2A#, 16), to_signed(16#7B5D#, 16),
     to_signed(16#7A7D#, 16), to_signed(16#798A#, 16), to_signed(16#7885#, 16), to_signed(16#776C#, 16),
     to_signed(16#7642#, 16), to_signed(16#7505#, 16), to_signed(16#73B6#, 16), to_signed(16#7255#, 16),
     to_signed(16#70E3#, 16), to_signed(16#6F5F#, 16), to_signed(16#6DCA#, 16), to_signed(16#6C24#, 16),
     to_signed(16#6A6E#, 16), to_signed(16#68A7#, 16), to_signed(16#66D0#, 16), to_signed(16#64E9#, 16),
     to_signed(16#62F2#, 16), to_signed(16#60EC#, 16), to_signed(16#5ED7#, 16), to_signed(16#5CB4#, 16),
     to_signed(16#5A82#, 16), to_signed(16#5843#, 16), to_signed(16#55F6#, 16), to_signed(16#539B#, 16),
     to_signed(16#5134#, 16), to_signed(16#4EC0#, 16), to_signed(16#4C40#, 16), to_signed(16#49B4#, 16),
     to_signed(16#471D#, 16), to_signed(16#447B#, 16), to_signed(16#41CE#, 16), to_signed(16#3F17#, 16),
     to_signed(16#3C57#, 16), to_signed(16#398D#, 16), to_signed(16#36BA#, 16), to_signed(16#33DF#, 16),
     to_signed(16#30FC#, 16), to_signed(16#2E11#, 16), to_signed(16#2B1F#, 16), to_signed(16#2827#, 16),
     to_signed(16#2528#, 16), to_signed(16#2224#, 16), to_signed(16#1F1A#, 16), to_signed(16#1C0C#, 16),
     to_signed(16#18F9#, 16), to_signed(16#15E2#, 16), to_signed(16#12C8#, 16), to_signed(16#0FAB#, 16),
     to_signed(16#0C8C#, 16), to_signed(16#096B#, 16), to_signed(16#0648#, 16), to_signed(16#0324#, 16),
     to_signed(16#0000#, 16), to_signed(-16#0324#, 16), to_signed(-16#0648#, 16), to_signed(-16#096B#, 16),
     to_signed(-16#0C8C#, 16), to_signed(-16#0FAB#, 16), to_signed(-16#12C8#, 16), to_signed(-16#15E2#, 16),
     to_signed(-16#18F9#, 16), to_signed(-16#1C0C#, 16), to_signed(-16#1F1A#, 16), to_signed(-16#2224#, 16),
     to_signed(-16#2528#, 16), to_signed(-16#2827#, 16), to_signed(-16#2B1F#, 16), to_signed(-16#2E11#, 16),
     to_signed(-16#30FC#, 16), to_signed(-16#33DF#, 16), to_signed(-16#36BA#, 16), to_signed(-16#398D#, 16),
     to_signed(-16#3C57#, 16), to_signed(-16#3F17#, 16), to_signed(-16#41CE#, 16), to_signed(-16#447B#, 16),
     to_signed(-16#471D#, 16), to_signed(-16#49B4#, 16), to_signed(-16#4C40#, 16), to_signed(-16#4EC0#, 16),
     to_signed(-16#5134#, 16), to_signed(-16#539B#, 16), to_signed(-16#55F6#, 16), to_signed(-16#5843#, 16),
     to_signed(-16#5A82#, 16), to_signed(-16#5CB4#, 16), to_signed(-16#5ED7#, 16), to_signed(-16#60EC#, 16),
     to_signed(-16#62F2#, 16), to_signed(-16#64E9#, 16), to_signed(-16#66D0#, 16), to_signed(-16#68A7#, 16),
     to_signed(-16#6A6E#, 16), to_signed(-16#6C24#, 16), to_signed(-16#6DCA#, 16), to_signed(-16#6F5F#, 16),
     to_signed(-16#70E3#, 16), to_signed(-16#7255#, 16), to_signed(-16#73B6#, 16), to_signed(-16#7505#, 16),
     to_signed(-16#7642#, 16), to_signed(-16#776C#, 16), to_signed(-16#7885#, 16), to_signed(-16#798A#, 16),
     to_signed(-16#7A7D#, 16), to_signed(-16#7B5D#, 16), to_signed(-16#7C2A#, 16), to_signed(-16#7CE4#, 16),
     to_signed(-16#7D8A#, 16), to_signed(-16#7E1E#, 16), to_signed(-16#7E9D#, 16), to_signed(-16#7F0A#, 16),
     to_signed(-16#7F62#, 16), to_signed(-16#7FA7#, 16), to_signed(-16#7FD9#, 16), to_signed(-16#7FF6#, 16),
     to_signed(-16#7FFF#, 16), to_signed(-16#7FF6#, 16), to_signed(-16#7FD9#, 16), to_signed(-16#7FA7#, 16),
     to_signed(-16#7F62#, 16), to_signed(-16#7F0A#, 16), to_signed(-16#7E9D#, 16), to_signed(-16#7E1E#, 16),
     to_signed(-16#7D8A#, 16), to_signed(-16#7CE4#, 16), to_signed(-16#7C2A#, 16), to_signed(-16#7B5D#, 16),
     to_signed(-16#7A7D#, 16), to_signed(-16#798A#, 16), to_signed(-16#7885#, 16), to_signed(-16#776C#, 16),
     to_signed(-16#7642#, 16), to_signed(-16#7505#, 16), to_signed(-16#73B6#, 16), to_signed(-16#7255#, 16),
     to_signed(-16#70E3#, 16), to_signed(-16#6F5F#, 16), to_signed(-16#6DCA#, 16), to_signed(-16#6C24#, 16),
     to_signed(-16#6A6E#, 16), to_signed(-16#68A7#, 16), to_signed(-16#66D0#, 16), to_signed(-16#64E9#, 16),
     to_signed(-16#62F2#, 16), to_signed(-16#60EC#, 16), to_signed(-16#5ED7#, 16), to_signed(-16#5CB4#, 16),
     to_signed(-16#5A82#, 16), to_signed(-16#5843#, 16), to_signed(-16#55F6#, 16), to_signed(-16#539B#, 16),
     to_signed(-16#5134#, 16), to_signed(-16#4EC0#, 16), to_signed(-16#4C40#, 16), to_signed(-16#49B4#, 16),
     to_signed(-16#471D#, 16), to_signed(-16#447B#, 16), to_signed(-16#41CE#, 16), to_signed(-16#3F17#, 16),
     to_signed(-16#3C57#, 16), to_signed(-16#398D#, 16), to_signed(-16#36BA#, 16), to_signed(-16#33DF#, 16),
     to_signed(-16#30FC#, 16), to_signed(-16#2E11#, 16), to_signed(-16#2B1F#, 16), to_signed(-16#2827#, 16),
     to_signed(-16#2528#, 16), to_signed(-16#2224#, 16), to_signed(-16#1F1A#, 16), to_signed(-16#1C0C#, 16),
     to_signed(-16#18F9#, 16), to_signed(-16#15E2#, 16), to_signed(-16#12C8#, 16), to_signed(-16#0FAB#, 16),
     to_signed(-16#0C8C#, 16), to_signed(-16#096B#, 16), to_signed(-16#0648#, 16), to_signed(-16#0324#, 16));  -- sfix16 [256]
  CONSTANT nc_0                           : vector_of_signed16(0 TO 255) := 
    (to_signed(16#7FFF#, 16), to_signed(16#7FF6#, 16), to_signed(16#7FD9#, 16), to_signed(16#7FA7#, 16),
     to_signed(16#7F62#, 16), to_signed(16#7F0A#, 16), to_signed(16#7E9D#, 16), to_signed(16#7E1E#, 16),
     to_signed(16#7D8A#, 16), to_signed(16#7CE4#, 16), to_signed(16#7C2A#, 16), to_signed(16#7B5D#, 16),
     to_signed(16#7A7D#, 16), to_signed(16#798A#, 16), to_signed(16#7885#, 16), to_signed(16#776C#, 16),
     to_signed(16#7642#, 16), to_signed(16#7505#, 16), to_signed(16#73B6#, 16), to_signed(16#7255#, 16),
     to_signed(16#70E3#, 16), to_signed(16#6F5F#, 16), to_signed(16#6DCA#, 16), to_signed(16#6C24#, 16),
     to_signed(16#6A6E#, 16), to_signed(16#68A7#, 16), to_signed(16#66D0#, 16), to_signed(16#64E9#, 16),
     to_signed(16#62F2#, 16), to_signed(16#60EC#, 16), to_signed(16#5ED7#, 16), to_signed(16#5CB4#, 16),
     to_signed(16#5A82#, 16), to_signed(16#5843#, 16), to_signed(16#55F6#, 16), to_signed(16#539B#, 16),
     to_signed(16#5134#, 16), to_signed(16#4EC0#, 16), to_signed(16#4C40#, 16), to_signed(16#49B4#, 16),
     to_signed(16#471D#, 16), to_signed(16#447B#, 16), to_signed(16#41CE#, 16), to_signed(16#3F17#, 16),
     to_signed(16#3C57#, 16), to_signed(16#398D#, 16), to_signed(16#36BA#, 16), to_signed(16#33DF#, 16),
     to_signed(16#30FC#, 16), to_signed(16#2E11#, 16), to_signed(16#2B1F#, 16), to_signed(16#2827#, 16),
     to_signed(16#2528#, 16), to_signed(16#2224#, 16), to_signed(16#1F1A#, 16), to_signed(16#1C0C#, 16),
     to_signed(16#18F9#, 16), to_signed(16#15E2#, 16), to_signed(16#12C8#, 16), to_signed(16#0FAB#, 16),
     to_signed(16#0C8C#, 16), to_signed(16#096B#, 16), to_signed(16#0648#, 16), to_signed(16#0324#, 16),
     to_signed(16#0000#, 16), to_signed(-16#0324#, 16), to_signed(-16#0648#, 16), to_signed(-16#096B#, 16),
     to_signed(-16#0C8C#, 16), to_signed(-16#0FAB#, 16), to_signed(-16#12C8#, 16), to_signed(-16#15E2#, 16),
     to_signed(-16#18F9#, 16), to_signed(-16#1C0C#, 16), to_signed(-16#1F1A#, 16), to_signed(-16#2224#, 16),
     to_signed(-16#2528#, 16), to_signed(-16#2827#, 16), to_signed(-16#2B1F#, 16), to_signed(-16#2E11#, 16),
     to_signed(-16#30FC#, 16), to_signed(-16#33DF#, 16), to_signed(-16#36BA#, 16), to_signed(-16#398D#, 16),
     to_signed(-16#3C57#, 16), to_signed(-16#3F17#, 16), to_signed(-16#41CE#, 16), to_signed(-16#447B#, 16),
     to_signed(-16#471D#, 16), to_signed(-16#49B4#, 16), to_signed(-16#4C40#, 16), to_signed(-16#4EC0#, 16),
     to_signed(-16#5134#, 16), to_signed(-16#539B#, 16), to_signed(-16#55F6#, 16), to_signed(-16#5843#, 16),
     to_signed(-16#5A82#, 16), to_signed(-16#5CB4#, 16), to_signed(-16#5ED7#, 16), to_signed(-16#60EC#, 16),
     to_signed(-16#62F2#, 16), to_signed(-16#64E9#, 16), to_signed(-16#66D0#, 16), to_signed(-16#68A7#, 16),
     to_signed(-16#6A6E#, 16), to_signed(-16#6C24#, 16), to_signed(-16#6DCA#, 16), to_signed(-16#6F5F#, 16),
     to_signed(-16#70E3#, 16), to_signed(-16#7255#, 16), to_signed(-16#73B6#, 16), to_signed(-16#7505#, 16),
     to_signed(-16#7642#, 16), to_signed(-16#776C#, 16), to_signed(-16#7885#, 16), to_signed(-16#798A#, 16),
     to_signed(-16#7A7D#, 16), to_signed(-16#7B5D#, 16), to_signed(-16#7C2A#, 16), to_signed(-16#7CE4#, 16),
     to_signed(-16#7D8A#, 16), to_signed(-16#7E1E#, 16), to_signed(-16#7E9D#, 16), to_signed(-16#7F0A#, 16),
     to_signed(-16#7F62#, 16), to_signed(-16#7FA7#, 16), to_signed(-16#7FD9#, 16), to_signed(-16#7FF6#, 16),
     to_signed(-16#7FFF#, 16), to_signed(-16#7FF6#, 16), to_signed(-16#7FD9#, 16), to_signed(-16#7FA7#, 16),
     to_signed(-16#7F62#, 16), to_signed(-16#7F0A#, 16), to_signed(-16#7E9D#, 16), to_signed(-16#7E1E#, 16),
     to_signed(-16#7D8A#, 16), to_signed(-16#7CE4#, 16), to_signed(-16#7C2A#, 16), to_signed(-16#7B5D#, 16),
     to_signed(-16#7A7D#, 16), to_signed(-16#798A#, 16), to_signed(-16#7885#, 16), to_signed(-16#776C#, 16),
     to_signed(-16#7642#, 16), to_signed(-16#7505#, 16), to_signed(-16#73B6#, 16), to_signed(-16#7255#, 16),
     to_signed(-16#70E3#, 16), to_signed(-16#6F5F#, 16), to_signed(-16#6DCA#, 16), to_signed(-16#6C24#, 16),
     to_signed(-16#6A6E#, 16), to_signed(-16#68A7#, 16), to_signed(-16#66D0#, 16), to_signed(-16#64E9#, 16),
     to_signed(-16#62F2#, 16), to_signed(-16#60EC#, 16), to_signed(-16#5ED7#, 16), to_signed(-16#5CB4#, 16),
     to_signed(-16#5A82#, 16), to_signed(-16#5843#, 16), to_signed(-16#55F6#, 16), to_signed(-16#539B#, 16),
     to_signed(-16#5134#, 16), to_signed(-16#4EC0#, 16), to_signed(-16#4C40#, 16), to_signed(-16#49B4#, 16),
     to_signed(-16#471D#, 16), to_signed(-16#447B#, 16), to_signed(-16#41CE#, 16), to_signed(-16#3F17#, 16),
     to_signed(-16#3C57#, 16), to_signed(-16#398D#, 16), to_signed(-16#36BA#, 16), to_signed(-16#33DF#, 16),
     to_signed(-16#30FC#, 16), to_signed(-16#2E11#, 16), to_signed(-16#2B1F#, 16), to_signed(-16#2827#, 16),
     to_signed(-16#2528#, 16), to_signed(-16#2224#, 16), to_signed(-16#1F1A#, 16), to_signed(-16#1C0C#, 16),
     to_signed(-16#18F9#, 16), to_signed(-16#15E2#, 16), to_signed(-16#12C8#, 16), to_signed(-16#0FAB#, 16),
     to_signed(-16#0C8C#, 16), to_signed(-16#096B#, 16), to_signed(-16#0648#, 16), to_signed(-16#0324#, 16),
     to_signed(16#0000#, 16), to_signed(16#0324#, 16), to_signed(16#0648#, 16), to_signed(16#096B#, 16),
     to_signed(16#0C8C#, 16), to_signed(16#0FAB#, 16), to_signed(16#12C8#, 16), to_signed(16#15E2#, 16),
     to_signed(16#18F9#, 16), to_signed(16#1C0C#, 16), to_signed(16#1F1A#, 16), to_signed(16#2224#, 16),
     to_signed(16#2528#, 16), to_signed(16#2827#, 16), to_signed(16#2B1F#, 16), to_signed(16#2E11#, 16),
     to_signed(16#30FC#, 16), to_signed(16#33DF#, 16), to_signed(16#36BA#, 16), to_signed(16#398D#, 16),
     to_signed(16#3C57#, 16), to_signed(16#3F17#, 16), to_signed(16#41CE#, 16), to_signed(16#447B#, 16),
     to_signed(16#471D#, 16), to_signed(16#49B4#, 16), to_signed(16#4C40#, 16), to_signed(16#4EC0#, 16),
     to_signed(16#5134#, 16), to_signed(16#539B#, 16), to_signed(16#55F6#, 16), to_signed(16#5843#, 16),
     to_signed(16#5A82#, 16), to_signed(16#5CB4#, 16), to_signed(16#5ED7#, 16), to_signed(16#60EC#, 16),
     to_signed(16#62F2#, 16), to_signed(16#64E9#, 16), to_signed(16#66D0#, 16), to_signed(16#68A7#, 16),
     to_signed(16#6A6E#, 16), to_signed(16#6C24#, 16), to_signed(16#6DCA#, 16), to_signed(16#6F5F#, 16),
     to_signed(16#70E3#, 16), to_signed(16#7255#, 16), to_signed(16#73B6#, 16), to_signed(16#7505#, 16),
     to_signed(16#7642#, 16), to_signed(16#776C#, 16), to_signed(16#7885#, 16), to_signed(16#798A#, 16),
     to_signed(16#7A7D#, 16), to_signed(16#7B5D#, 16), to_signed(16#7C2A#, 16), to_signed(16#7CE4#, 16),
     to_signed(16#7D8A#, 16), to_signed(16#7E1E#, 16), to_signed(16#7E9D#, 16), to_signed(16#7F0A#, 16),
     to_signed(16#7F62#, 16), to_signed(16#7FA7#, 16), to_signed(16#7FD9#, 16), to_signed(16#7FF6#, 16));  -- sfix16 [256]
  CONSTANT C_divbyzero_p                  : unsigned(44 DOWNTO 0) := 
    unsigned'("111111111111111111111111111111111111111111111");  -- ufix45

  -- Signals
  SIGNAL input_signal_signed              : vector_of_signed16(0 TO 134);  -- sfix16 [135]
  SIGNAL N_unsigned                       : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL target_freq_unsigned             : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL sample_freq_unsigned             : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL output_tmp                       : unsigned(13 DOWNTO 0);  -- ufix14_E5

BEGIN
  outputgen: FOR k IN 0 TO 134 GENERATE
    input_signal_signed(k) <= signed(input_signal(k));
  END GENERATE;

  N_unsigned <= unsigned(N);

  target_freq_unsigned <= unsigned(target_freq);

  sample_freq_unsigned <= unsigned(sample_freq);

  goertzel_filter_fixpt_1_output : PROCESS (N_unsigned, input_signal_signed, sample_freq_unsigned, target_freq_unsigned)
    VARIABLE FI_SIN_COS_LUT : vector_of_signed16(0 TO 255);
    VARIABLE fi_sin_cos_lut_0 : vector_of_signed16(0 TO 255);
    VARIABLE a1 : unsigned(31 DOWNTO 0);
    VARIABLE tmp : unsigned(53 DOWNTO 0);
    VARIABLE omega : unsigned(13 DOWNTO 0);
    VARIABLE fullScaleIndex : unsigned(15 DOWNTO 0);
    VARIABLE idxLUTLoZero : unsigned(7 DOWNTO 0);
    VARIABLE coeff : unsigned(13 DOWNTO 0);
    VARIABLE s_prev2 : signed(13 DOWNTO 0);
    VARIABLE s_prev : signed(13 DOWNTO 0);
    VARIABLE fullscaleindex_0 : unsigned(15 DOWNTO 0);
    VARIABLE idxlutlozero_0 : unsigned(7 DOWNTO 0);
    VARIABLE real_part : signed(13 DOWNTO 0);
    VARIABLE fullscaleindex_1 : unsigned(15 DOWNTO 0);
    VARIABLE idxlutlozero_1 : unsigned(7 DOWNTO 0);
    VARIABLE imag_part : signed(13 DOWNTO 0);
    VARIABLE tmp_0 : signed(13 DOWNTO 0);
    VARIABLE s_prev_0 : signed(13 DOWNTO 0);
    VARIABLE tmp_1 : signed(13 DOWNTO 0);
    VARIABLE s_prev2_0 : signed(13 DOWNTO 0);
    VARIABLE div_temp : unsigned(44 DOWNTO 0);
    VARIABLE cast : unsigned(44 DOWNTO 0);
    VARIABLE cast_0 : unsigned(15 DOWNTO 0);
    VARIABLE mul_temp : unsigned(47 DOWNTO 0);
    VARIABLE cast_1 : unsigned(31 DOWNTO 0);
    VARIABLE add_cast : signed(31 DOWNTO 0);
    VARIABLE cast_2 : signed(8 DOWNTO 0);
    VARIABLE add_temp : unsigned(7 DOWNTO 0);
    VARIABLE add_cast_0 : signed(15 DOWNTO 0);
    VARIABLE sub_cast : signed(31 DOWNTO 0);
    VARIABLE sub_cast_0 : signed(31 DOWNTO 0);
    VARIABLE sub_temp : signed(31 DOWNTO 0);
    VARIABLE mul_temp_0 : signed(40 DOWNTO 0);
    VARIABLE add_cast_1 : signed(31 DOWNTO 0);
    VARIABLE add_cast_2 : signed(15 DOWNTO 0);
    VARIABLE add_cast_3 : signed(31 DOWNTO 0);
    VARIABLE add_temp_0 : signed(31 DOWNTO 0);
    VARIABLE cast_3 : signed(15 DOWNTO 0);
    VARIABLE mul_temp_1 : signed(18 DOWNTO 0);
    VARIABLE cast_4 : signed(17 DOWNTO 0);
    VARIABLE cast_5 : unsigned(15 DOWNTO 0);
    VARIABLE mul_temp_2 : unsigned(47 DOWNTO 0);
    VARIABLE cast_6 : unsigned(31 DOWNTO 0);
    VARIABLE cast_7 : vector_of_signed32(0 TO 254);
    VARIABLE add_temp_1 : vector_of_signed32(0 TO 254);
    VARIABLE sub_cast_1 : vector_of_unsigned8(0 TO 254);
    VARIABLE sub_cast_2 : vector_of_signed32(0 TO 254);
    VARIABLE add_cast_4 : vector_of_signed29(0 TO 254);
    VARIABLE cast_8 : vector_of_signed15(0 TO 254);
    VARIABLE mul_temp_3 : vector_of_signed29(0 TO 254);
    VARIABLE add_cast_5 : vector_of_signed28(0 TO 254);
    VARIABLE add_cast_6 : vector_of_signed29(0 TO 254);
    VARIABLE add_temp_2 : vector_of_signed29(0 TO 254);
    VARIABLE sub_cast_3 : vector_of_signed30(0 TO 254);
    VARIABLE sub_cast_4 : vector_of_signed30(0 TO 254);
    VARIABLE sub_temp_0 : vector_of_signed30(0 TO 254);
    VARIABLE sub_cast_5 : signed(30 DOWNTO 0);
    VARIABLE add_cast_7 : signed(31 DOWNTO 0);
    VARIABLE cast_9 : signed(8 DOWNTO 0);
    VARIABLE add_temp_3 : unsigned(7 DOWNTO 0);
    VARIABLE add_cast_8 : signed(15 DOWNTO 0);
    VARIABLE sub_cast_6 : signed(31 DOWNTO 0);
    VARIABLE sub_cast_7 : signed(31 DOWNTO 0);
    VARIABLE sub_temp_1 : signed(31 DOWNTO 0);
    VARIABLE mul_temp_4 : signed(40 DOWNTO 0);
    VARIABLE add_cast_9 : signed(31 DOWNTO 0);
    VARIABLE add_cast_10 : signed(15 DOWNTO 0);
    VARIABLE add_cast_11 : signed(31 DOWNTO 0);
    VARIABLE add_temp_4 : signed(31 DOWNTO 0);
    VARIABLE cast_10 : signed(15 DOWNTO 0);
    VARIABLE mul_temp_5 : signed(29 DOWNTO 0);
    VARIABLE sub_cast_8 : signed(30 DOWNTO 0);
    VARIABLE sub_temp_2 : signed(30 DOWNTO 0);
    VARIABLE cast_11 : unsigned(15 DOWNTO 0);
    VARIABLE mul_temp_6 : unsigned(47 DOWNTO 0);
    VARIABLE cast_12 : unsigned(31 DOWNTO 0);
    VARIABLE cast_13 : vector_of_signed32(0 TO 254);
    VARIABLE add_temp_5 : vector_of_signed32(0 TO 254);
    VARIABLE sub_cast_9 : vector_of_unsigned8(0 TO 254);
    VARIABLE sub_cast_10 : vector_of_signed32(0 TO 254);
    VARIABLE add_cast_12 : vector_of_signed29(0 TO 254);
    VARIABLE cast_14 : vector_of_signed15(0 TO 254);
    VARIABLE mul_temp_7 : vector_of_signed29(0 TO 254);
    VARIABLE add_cast_13 : vector_of_signed28(0 TO 254);
    VARIABLE add_cast_14 : vector_of_signed29(0 TO 254);
    VARIABLE add_temp_6 : vector_of_signed29(0 TO 254);
    VARIABLE sub_cast_11 : vector_of_signed30(0 TO 254);
    VARIABLE sub_cast_12 : vector_of_signed30(0 TO 254);
    VARIABLE sub_temp_3 : vector_of_signed30(0 TO 254);
    VARIABLE add_cast_15 : signed(31 DOWNTO 0);
    VARIABLE cast_15 : signed(8 DOWNTO 0);
    VARIABLE add_temp_7 : unsigned(7 DOWNTO 0);
    VARIABLE add_cast_16 : signed(15 DOWNTO 0);
    VARIABLE sub_cast_13 : signed(31 DOWNTO 0);
    VARIABLE sub_cast_14 : signed(31 DOWNTO 0);
    VARIABLE sub_temp_4 : signed(31 DOWNTO 0);
    VARIABLE mul_temp_8 : signed(40 DOWNTO 0);
    VARIABLE add_cast_17 : signed(31 DOWNTO 0);
    VARIABLE add_cast_18 : signed(15 DOWNTO 0);
    VARIABLE add_cast_19 : signed(31 DOWNTO 0);
    VARIABLE add_temp_8 : signed(31 DOWNTO 0);
    VARIABLE cast_16 : signed(15 DOWNTO 0);
    VARIABLE mul_temp_9 : signed(29 DOWNTO 0);
    VARIABLE mul_temp_10 : signed(27 DOWNTO 0);
    VARIABLE add_cast_20 : signed(28 DOWNTO 0);
    VARIABLE mul_temp_11 : signed(27 DOWNTO 0);
    VARIABLE add_cast_21 : signed(28 DOWNTO 0);
    VARIABLE add_temp_9 : signed(28 DOWNTO 0);
    VARIABLE cast_17 : unsigned(13 DOWNTO 0);
    VARIABLE cast_18 : unsigned(53 DOWNTO 0);
    VARIABLE cast_19 : unsigned(53 DOWNTO 0);
    VARIABLE cast_20 : unsigned(13 DOWNTO 0);
    VARIABLE mul_temp_12 : unsigned(29 DOWNTO 0);
  BEGIN
    tmp_1 := to_signed(16#0000#, 14);
    tmp_0 := to_signed(16#0000#, 14);
    div_temp := to_unsigned(0, 45);
    cast := to_unsigned(0, 45);
    --HDL code generation from MATLAB function: goertzel_filter_fixpt
    FI_SIN_COS_LUT := nc;
    fi_sin_cos_lut_0 := nc_0;
    
    a1 := to_unsigned(16#3243#, 14) * target_freq_unsigned;
    tmp := unsigned'("111111111111111111111111111111111111111111111111111111");
    IF  NOT (sample_freq_unsigned = to_unsigned(16#000000#, 22)) THEN 
      cast := a1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';
      IF sample_freq_unsigned = 0 THEN 
        div_temp := C_divbyzero_p;
      ELSE 
        div_temp := cast / sample_freq_unsigned;
      END IF;
      tmp := resize(div_temp, 54);
    END IF;
    omega := tmp(21 DOWNTO 8);
    cast_0 := resize(omega(13 DOWNTO 3), 16);
    mul_temp := unsigned'(X"A2F96524") * cast_0;
    cast_1 := mul_temp(46 DOWNTO 15);
    fullScaleIndex := cast_1(31 DOWNTO 16);
    idxLUTLoZero := fullScaleIndex(15 DOWNTO 8);
    add_cast := resize(fi_sin_cos_lut_0(to_integer(idxLUTLoZero)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    cast_2 := signed(resize(fullScaleIndex(7 DOWNTO 0), 9));
    add_temp := idxLUTLoZero + to_unsigned(16#01#, 8);
    add_cast_0 := signed(resize(add_temp, 16));
    sub_cast := resize(fi_sin_cos_lut_0(to_integer(resize(add_cast_0 + to_signed(16#0001#, 16), 32) - 1)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_cast_0 := resize(fi_sin_cos_lut_0(to_integer(idxLUTLoZero)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_temp := sub_cast - sub_cast_0;
    mul_temp_0 := cast_2 * sub_temp;
    add_cast_1 := mul_temp_0(39 DOWNTO 8);
    add_cast_2 := add_cast_1(30 DOWNTO 15);
    add_cast_3 := resize(add_cast_2 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    add_temp_0 := add_cast + add_cast_3;
    cast_3 := add_temp_0(30 DOWNTO 15);
    -- CSD Encoding (2) : 10; Cost (Adders) = 0
    mul_temp_1 := resize(cast_3 & '0', 19);
    cast_4 := mul_temp_1(17 DOWNTO 0);
    coeff := unsigned(cast_4(15 DOWNTO 2));
    s_prev2_0 := to_signed(16#0000#, 14);
    s_prev := to_signed(16#0000#, 14);
    s_prev_0 := to_signed(16#0000#, 14);
    s_prev2 := to_signed(16#0000#, 14);

    FOR n1 IN 0 TO 254 LOOP
      cast_7(n1) := signed(resize(N_unsigned, 32));
      IF to_signed(n1 + 1, 32) <= cast_7(n1) THEN 
        add_temp_1(n1) := to_signed(n1 + 1, 32);
        sub_cast_1(n1) := unsigned(add_temp_1(n1)(7 DOWNTO 0));
        sub_cast_2(n1) := signed(resize(sub_cast_1(n1), 32));
        add_cast_4(n1) := resize(input_signal_signed(to_integer(sub_cast_2(n1) - 1)) & '0' & '0', 29);
        cast_8(n1) := signed(resize(coeff, 15));
        mul_temp_3(n1) := cast_8(n1) * s_prev;
        add_cast_5(n1) := mul_temp_3(n1)(27 DOWNTO 0);
        add_cast_6(n1) := resize(add_cast_5(n1), 29);
        add_temp_2(n1) := add_cast_4(n1) + add_cast_6(n1);
        sub_cast_3(n1) := resize(add_temp_2(n1), 30);
        sub_cast_4(n1) := resize(s_prev2_0 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 30);
        sub_temp_0(n1) := sub_cast_3(n1) - sub_cast_4(n1);
        tmp_1 := sub_temp_0(n1)(26 DOWNTO 13);
        s_prev2_0 := s_prev;
      ELSE 
        tmp_1 := s_prev;
      END IF;
      s_prev := tmp_1;
      cast_13(n1) := signed(resize(N_unsigned, 32));
      IF to_signed(n1 + 1, 32) <= cast_13(n1) THEN 
        add_temp_5(n1) := to_signed(n1 + 1, 32);
        sub_cast_9(n1) := unsigned(add_temp_5(n1)(7 DOWNTO 0));
        sub_cast_10(n1) := signed(resize(sub_cast_9(n1), 32));
        add_cast_12(n1) := resize(input_signal_signed(to_integer(sub_cast_10(n1) - 1)) & '0' & '0', 29);
        cast_14(n1) := signed(resize(coeff, 15));
        mul_temp_7(n1) := cast_14(n1) * s_prev_0;
        add_cast_13(n1) := mul_temp_7(n1)(27 DOWNTO 0);
        add_cast_14(n1) := resize(add_cast_13(n1), 29);
        add_temp_6(n1) := add_cast_12(n1) + add_cast_14(n1);
        sub_cast_11(n1) := resize(add_temp_6(n1), 30);
        sub_cast_12(n1) := resize(s_prev2 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 30);
        sub_temp_3(n1) := sub_cast_11(n1) - sub_cast_12(n1);
        tmp_0 := sub_temp_3(n1)(26 DOWNTO 13);
        s_prev2 := s_prev_0;
      ELSE 
        tmp_0 := s_prev_0;
      END IF;
      s_prev_0 := tmp_0;
    END LOOP;

    cast_5 := resize(omega(13 DOWNTO 3), 16);
    mul_temp_2 := unsigned'(X"A2F96524") * cast_5;
    cast_6 := mul_temp_2(46 DOWNTO 15);
    fullscaleindex_0 := cast_6(31 DOWNTO 16);
    idxlutlozero_0 := fullscaleindex_0(15 DOWNTO 8);
    sub_cast_5 := resize(s_prev & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 31);
    add_cast_7 := resize(fi_sin_cos_lut_0(to_integer(idxlutlozero_0)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    cast_9 := signed(resize(fullscaleindex_0(7 DOWNTO 0), 9));
    add_temp_3 := idxlutlozero_0 + to_unsigned(16#01#, 8);
    add_cast_8 := signed(resize(add_temp_3, 16));
    sub_cast_6 := resize(fi_sin_cos_lut_0(to_integer(resize(add_cast_8 + to_signed(16#0001#, 16), 32) - 1)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_cast_7 := resize(fi_sin_cos_lut_0(to_integer(idxlutlozero_0)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_temp_1 := sub_cast_6 - sub_cast_7;
    mul_temp_4 := cast_9 * sub_temp_1;
    add_cast_9 := mul_temp_4(39 DOWNTO 8);
    add_cast_10 := add_cast_9(30 DOWNTO 15);
    add_cast_11 := resize(add_cast_10 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    add_temp_4 := add_cast_7 + add_cast_11;
    cast_10 := add_temp_4(30 DOWNTO 15);
    mul_temp_5 := s_prev2 * cast_10;
    sub_cast_8 := resize(mul_temp_5, 31);
    sub_temp_2 := sub_cast_5 - sub_cast_8;
    real_part := sub_temp_2(26 DOWNTO 13);
    cast_11 := resize(omega(13 DOWNTO 3), 16);
    mul_temp_6 := unsigned'(X"A2F96524") * cast_11;
    cast_12 := mul_temp_6(46 DOWNTO 15);
    fullscaleindex_1 := cast_12(31 DOWNTO 16);
    idxlutlozero_1 := fullscaleindex_1(15 DOWNTO 8);
    add_cast_15 := resize(FI_SIN_COS_LUT(to_integer(idxlutlozero_1)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    cast_15 := signed(resize(fullscaleindex_1(7 DOWNTO 0), 9));
    add_temp_7 := idxlutlozero_1 + to_unsigned(16#01#, 8);
    add_cast_16 := signed(resize(add_temp_7, 16));
    sub_cast_13 := resize(FI_SIN_COS_LUT(to_integer(resize(add_cast_16 + to_signed(16#0001#, 16), 32) - 1)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_cast_14 := resize(FI_SIN_COS_LUT(to_integer(idxlutlozero_1)) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    sub_temp_4 := sub_cast_13 - sub_cast_14;
    mul_temp_8 := cast_15 * sub_temp_4;
    add_cast_17 := mul_temp_8(39 DOWNTO 8);
    add_cast_18 := add_cast_17(30 DOWNTO 15);
    add_cast_19 := resize(add_cast_18 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
    add_temp_8 := add_cast_15 + add_cast_19;
    cast_16 := add_temp_8(30 DOWNTO 15);
    mul_temp_9 := s_prev2 * cast_16;
    imag_part := mul_temp_9(26 DOWNTO 13);
    -- Scale the power to match the expected results format
    -- Assuming 16-bit unsigned expected results
    -- Adjust scaling factor as needed
    -- Scale to 16-bit range
    mul_temp_10 := real_part * real_part;
    add_cast_20 := resize(mul_temp_10, 29);
    mul_temp_11 := imag_part * imag_part;
    add_cast_21 := resize(mul_temp_11, 29);
    add_temp_9 := add_cast_20 + add_cast_21;
    cast_17 := unsigned(add_temp_9(24 DOWNTO 11));
    cast_18 := cast_17 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';
    cast_19 := SHIFT_RIGHT(cast_18, 40);
    cast_20 := cast_19(29 DOWNTO 16);
    mul_temp_12 := cast_20 * to_unsigned(16#FFFF#, 16);
    output_tmp <= mul_temp_12(13 DOWNTO 0);
  END PROCESS goertzel_filter_fixpt_1_output;


  output <= std_logic_vector(output_tmp);

END rtl;

