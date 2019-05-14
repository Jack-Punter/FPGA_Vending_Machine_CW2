----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2019 16:51:50
-- Design Name: 
-- Module Name: ClockDivider - Behavioral
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

entity ClockDivider is
    Port ( 
        GCLK : in STD_LOGIC;
        vmClk : out STD_LOGIC
    );
end ClockDivider;

architecture Behavioral of ClockDivider is
    constant clockCountInit : integer := 100000000;
    signal clockCount : integer := clockCountInit;
    signal s_vmClk : STD_LOGIC :=  '0';
    signal s_vmClkBits : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
begin
    vmClk <= s_vmClkBits(23);
    --Clock process (also divides)
    clockDivide: process(GCLK)
    begin
    if rising_edge(GCLK) then
        s_vmClkBits(0) <= not(s_vmClkBits(0));
        for i in 1 to 23 loop
            if s_vmClkBits(i-1) = '1' then
                s_vmClkBits(i) <= not(s_vmClkBits(i));
            end if;
        end loop;
    end if;
    end process;

end Behavioral;
