library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity halfAdder is
    port (
        i_bit1 : in std_logic;
        i_bit2 : in std_logic;
        o_sum : out std_logic;
        o_carry : out std_logic
    );
end halfAdder;

architecture Behavioral of halfAdder is
begin
    o_sum <= i_bit1 xor i_bit2;
    o_carry <= i_bit1 and i_bit2;
end Behavioral;
