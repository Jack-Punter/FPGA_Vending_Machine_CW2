library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
