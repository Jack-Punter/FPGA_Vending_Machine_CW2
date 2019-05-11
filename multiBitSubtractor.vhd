----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2019 15:25:05
-- Design Name: 
-- Module Name: multiBitSubtractor - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity multiBitSubtractor is
    Port (
        input1 : in STD_LOGIC_VECTOR (15 downto 0);
        input2 : in STD_LOGIC_VECTOR (15 downto 0);
        output : out STD_LOGIC_VECTOR (15 downto 0);
        carryOut : out STD_LOGIC
    );
end multiBitSubtractor;

architecture Behavioral of multiBitSubtractor is
    signal s_input2 : STD_LOGIC_VECTOR (15 downto 0);
begin
    s_input2 <= not(input2);
    adder: entity work.multiBitAdder port map(
        input1pin => input1,
        input2pin => s_input2,
        output => output,
        carryIn => '1',
        carryOut => carryOut
    );

end Behavioral;
