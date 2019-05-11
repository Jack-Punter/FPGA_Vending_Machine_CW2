----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 01.11.2018 10:57:06
-- Design Name:
-- Module Name: multiBitAdder - Behavioral
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

entity multiBitAdder is
    Port(
        --2byte 1 in;
        input1pin : in std_logic_vector(15 downto 0);
        --2byte 2 in;
        input2pin : in std_logic_vector(15 downto 0);
        --Outputs
		output : out std_logic_vector(15 downto 0);
		--Carrys
		carryIn : in std_logic;
		carryOut : out std_logic
    );
end multiBitAdder;

architecture Behavioral of multiBitAdder is
    signal input1 : std_logic_vector(15 downto 0);
    signal input2 : std_logic_vector(15 downto 0);

    signal carryOuts : std_logic_vector(15 downto 0);
    signal sumOuts : std_logic_vector(15 downto 0);
begin
    input1 <= input1pin;
    input2 <= input2pin;
    output <= sumOuts;
    --carryOut is MSB of carries.
    carryOut <= carryOuts(15);
    
    Gen:
    for I in 0 to 15 generate
        firstBit : if I = 0 generate
            ADDERS : entity work.fullAdder port map(
                i_bit1  => input1(I),
                i_bit2  => input2(I),
                i_carry => carryIn,
                o_sum   => sumOuts(I),
                o_carry => carryOuts(I)
            );
        end generate firstBit;
        otherBits : if I > 0 generate 
            ADDERS : entity work.fullAdder port map(
                i_bit1  => input1(I),
                i_bit2  => input2(I),
                i_carry => carryOuts(I-1),
                o_sum   => sumOuts(I),
                o_carry => carryOuts(I)
            );
        end generate otherBits;
         
    end generate Gen;

end Behavioral;
