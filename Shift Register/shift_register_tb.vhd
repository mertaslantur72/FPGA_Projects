library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_tb is
end shift_register_tb;

architecture Behavioral of shift_register_tb is
constant N   : integer := 8;
signal clk   : std_logic := '0';
signal reset : std_logic := '1';
signal giris : std_logic_vector(N-1 downto 0) := "11111111";
signal cikis : std_logic_vector(N-1 downto 0);
signal ctrl  : std_logic;

constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
uut: entity work.shift_register
    generic map(N => N)
    Port map (
        clk   => clk,
        reset => reset,
        giris => giris,
        cikis => cikis,
        ctrl  => ctrl
    );

-- Clock process definitions
clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
    reset <= '1';
    wait for clk_period;
    reset <= '0';
    ctrl <= '0';
    giris <= "11111111";
    wait for clk_period * N; -- 8 saat döngüsü boyunca çýkýþý gözlemle
    
    reset <= '1';
    wait for clk_period;
    reset <= '0';
    ctrl <= '1';
    giris <= "11111111";
    wait for clk_period * N;
    
        -- End the simulation
    wait;
end process;
end Behavioral;
