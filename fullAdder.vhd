----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2018 12:39:34
-- Design Name: 
-- Module Name: fullAdder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fullAdder is
    port (
        i_bit1  : in std_logic;
        i_bit2  : in std_logic;
        i_carry : in std_logic;
        o_sum   : out std_logic;
        o_carry : out std_logic
    );
end fullAdder;

architecture Behavioral of fullAdder is
    signal fa_i_bit1 : std_logic;
    signal fa_i_bit2 : std_logic;
    signal fa_i_carry : std_logic;
    
    signal fa_o_sum : std_logic;
    signal fa_o_carry : std_logic;

    
    signal ha0_o_sum : std_logic;
    signal ha0_o_carry : std_logic;
    signal ha1_o_carry : std_logic;
begin
    fa_i_bit1 <= i_bit1;
    fa_i_bit2 <= i_bit2;
    fa_i_carry <= i_carry;
    o_sum <= fa_o_sum;
    o_carry <= fa_o_carry;
    
    ha0 : entity work.halfAdder port map(
        i_bit1 => fa_i_bit1,
        i_bit2 => fa_i_bit2,
        o_sum => ha0_o_sum,
        o_carry => ha0_o_carry
    );
    
     ha1 : entity work.halfAdder port map(
        i_bit1 => ha0_o_sum,
        i_bit2 => fa_i_carry,
        o_sum => fa_o_sum,
        o_carry => ha1_o_carry
    );
    fa_o_carry <= ha0_o_carry or ha1_o_carry;
end Behavioral;
