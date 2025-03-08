library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_adder_with_sign is
end tb_adder_with_sign;

architecture testbench of tb_adder_with_sign is
    -- Sinyaller (test için giriþ ve çýkýþ deðiþkenleri)
    signal a, b   : std_logic_vector(3 downto 0);
    signal sum    : std_logic_vector(3 downto 0);

begin
    -- Device Under Test (DUT) baðlantýsý
    uut: entity work.adder_with_sign
        port map (
            a => a,
            b => b,
            sum => sum
        );

    -- Stimulus process (test durumlarýný oluþtur)
    process
    begin
        -- Test 1: (2 + 3) -> 0010 + 0011 = 5 (0101)
        a <= "0010";  -- +2
        b <= "0011";  -- +3
        wait for 10 ns;

        -- Test 2: (-2 + -3) -> 1010 + 1011 = -5 (1101)
        a <= "1010";  -- -2
        b <= "1011";  -- -3
        wait for 10 ns;

        -- Test 3: (-3 + 2) -> 1011 + 0010 = -1 (1001)
        a <= "1011";  -- -3
        b <= "0010";  -- +2
        wait for 10 ns;

        -- Test 4: (+3 + -2) -> 0011 + 1010 = +1 (0001)
        a <= "0011";  -- +3
        b <= "1010";  -- -2
        wait for 10 ns;

        -- Test 5: (-4 + 4) -> 1100 + 0100 = 0000 (Toplam 0 olmalý)
        a <= "1100";  -- -4
        b <= "0100";  -- +4
        wait for 10 ns;

        -- Test 6: (0 + 0) -> 0000 + 0000 = 0000
        a <= "0000";  -- 0
        b <= "0000";  -- 0
        wait for 10 ns;

        -- Simülasyonu bitir
        wait;
    end process;

end testbench;
