
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY IEEE;
USE IEEE.std_logic_textio.ALL;
LIBRARY STD;
USE STD.textio.ALL;
LIBRARY work;
USE work.goertzel_filter_fixpt_pkg.ALL;

PACKAGE goertzel_filter_fixpt_tb_pkg IS
  -- Functions
  FUNCTION to_hex(x : IN std_logic) RETURN string;
  FUNCTION to_hex(x : IN std_logic_vector) RETURN string;
  FUNCTION to_hex(x : IN signed) RETURN string;
  FUNCTION to_hex(x : IN unsigned) RETURN string;
  FUNCTION to_hex(x : IN real) RETURN string;
  FUNCTION to_hex(x : IN vector_of_signed16) RETURN string;
END goertzel_filter_fixpt_tb_pkg;


PACKAGE BODY goertzel_filter_fixpt_tb_pkg IS
  FUNCTION to_hex(x : IN std_logic_vector) RETURN string IS
    VARIABLE result : STRING(1 TO 256);
    VARIABLE i      : INTEGER;
    VARIABLE imod   : INTEGER;
    VARIABLE j      : INTEGER;
    VARIABLE jinc   : INTEGER;
    VARIABLE newx   : std_logic_vector(1023 DOWNTO 0);
  BEGIN
    newx := (OTHERS => '0');
    IF x'LEFT > x'RIGHT THEN
      j := x'LENGTH - 1;
      jinc := -1;
    ELSE
      j := 0;
      jinc := 1;
    END IF;
    FOR i IN x'RANGE LOOP
      newx(j) := x(i);
      j := j + jinc;
    END LOOP;
    i := x'LENGTH - 1;
    imod := x'LENGTH MOD 4;
    IF    imod = 1 THEN i := i + 3;
    ELSIF imod = 2 THEN i := i + 2;
    ELSIF imod = 3 THEN i := i + 1;
    END IF;
    j := 1;
    WHILE i >= 3 LOOP
      IF    newx(i DOWNTO (i-3)) = "0000" THEN result(j) := '0';
      ELSIF newx(i DOWNTO (i-3)) = "0001" THEN result(j) := '1';
      ELSIF newx(i DOWNTO (i-3)) = "0010" THEN result(j) := '2';
      ELSIF newx(i DOWNTO (i-3)) = "0011" THEN result(j) := '3';
      ELSIF newx(i DOWNTO (i-3)) = "0100" THEN result(j) := '4';
      ELSIF newx(i DOWNTO (i-3)) = "0101" THEN result(j) := '5';
      ELSIF newx(i DOWNTO (i-3)) = "0110" THEN result(j) := '6';
      ELSIF newx(i DOWNTO (i-3)) = "0111" THEN result(j) := '7';
      ELSIF newx(i DOWNTO (i-3)) = "1000" THEN result(j) := '8';
      ELSIF newx(i DOWNTO (i-3)) = "1001" THEN result(j) := '9';
      ELSIF newx(i DOWNTO (i-3)) = "1010" THEN result(j) := 'A';
      ELSIF newx(i DOWNTO (i-3)) = "1011" THEN result(j) := 'B';
      ELSIF newx(i DOWNTO (i-3)) = "1100" THEN result(j) := 'C';
      ELSIF newx(i DOWNTO (i-3)) = "1101" THEN result(j) := 'D';
      ELSIF newx(i DOWNTO (i-3)) = "1110" THEN result(j) := 'E';
      ELSIF newx(i DOWNTO (i-3)) = "1111" THEN result(j) := 'F';
      ELSE result(j) := 'X';
      END IF;
      i := i - 4;
      j := j + 1;
    END LOOP;
    RETURN result(1 TO j - 1);
  END;

  FUNCTION to_hex(x : IN std_logic) RETURN string IS
  BEGIN
    RETURN std_logic'image(x);
  END;

  FUNCTION to_hex(x : IN signed) RETURN string IS
  BEGIN
    RETURN to_hex(std_logic_vector(x));
  END;

  FUNCTION to_hex(x : IN unsigned) RETURN string IS
  BEGIN
    RETURN to_hex(std_logic_vector(x));
  END;

  FUNCTION to_hex(x : IN real) RETURN string IS
  BEGIN
    RETURN real'image(x);
  END;

  FUNCTION to_hex(x : IN vector_of_signed16) RETURN string IS
    VARIABLE result : STRING(1 TO 675);
    VARIABLE i      : INTEGER;
    VARIABLE j      : INTEGER;
    VARIABLE k      : INTEGER;
    VARIABLE m      : INTEGER;
    VARIABLE newx   : STRING(1 to 128);
  BEGIN
    i := x'LENGTH - 1;
    m := to_hex(x(0))'LENGTH;
    newx(1 to m) := to_hex(x(0));
    k := m;
    result(1 to m) := newx(1 to m);
    for j in 1 to i loop
      m := to_hex(x(j))'LENGTH;
      k := k + 1;
      result(k) := ' ';
      newx(1 to m) := to_hex(x(j));
      result(k + 1 to k + m) := newx(1 to m);
      k := k + m;
    end loop;
    RETURN result(1 TO k);
  END;

END goertzel_filter_fixpt_tb_pkg;

