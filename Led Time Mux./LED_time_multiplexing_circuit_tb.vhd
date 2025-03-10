library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity LED_time_multiplexing_circuit_tb is
   port(
      clk  : in  std_logic;
      btn  : in  std_logic_vector(3 downto 0);
      sw   : in  std_logic_vector(7 downto 0);
      an   : out std_logic_vector(3 downto 0);
      sseg : out std_logic_vector(7 downto 0)
   );
end LED_time_multiplexing_circuit_tb;

architecture arch of LED_time_multiplexing_circuit_tb is
   signal d3_reg, d2_reg : std_logic_vector(7 downto 0);
   signal d1_reg, d0_reg : std_logic_vector(7 downto 0);
begin
   disp_unit : entity work.LED_time_multiplexing_circuit
      port map(
         clk => clk, reset => '0',
         in3 => d3_reg, in2 => d2_reg, in1 => d1_reg,
         in0 => d0_reg, an => an, sseg => sseg);
   -- registers for 4 led patterns
   process(clk)
   begin
      if (clk'event and clk = '1') then
         if (btn(3) = '1') then
            d3_reg <= sw;
         end if;
         if (btn(2) = '1') then
            d2_reg <= sw;
         end if;
         if (btn(1) = '1') then
            d1_reg <= sw;
         end if;
         if (btn(0) = '1') then
            d0_reg <= sw;
         end if;
      end if;
   end process;
end arch;