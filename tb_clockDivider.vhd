library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clockDivider is
--  Port ( );
end tb_clockDivider;

architecture Behavioral of tb_clockDivider is
    component ClockDivider is Port ( 
        GCLK : in STD_LOGIC;
        vmClk : out STD_LOGIC
    );
    end component;
    signal s_GCLK : STD_LOGIC := '0';
    signal s_vmCLK : STD_LOGIC;
    constant clkP : time := 10ps;
       
begin
    clkProc: process
    begin
        s_GCLK <= not(s_GCLK);
        wait for clkP / 2;
    end process;
    
    uut: ClockDivider Port map(
        GCLK => s_GCLK,
        vmClk => s_vmClk
    );
end Behavioral;
