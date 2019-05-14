----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2019 17:12:32
-- Design Name: 
-- Module Name: tb_clockDivider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
