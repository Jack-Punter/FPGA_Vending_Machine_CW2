----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2019 13:26:37
-- Design Name: 
-- Module Name: tb_multiBitAdder - Behavioral
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

entity tb_multiBitAdder is
end tb_multiBitAdder;

architecture Behavioral of tb_multiBitAdder is
    component multiBitAdder is Port(
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
    end component;  
    signal s_input1     : STD_LOGIC_VECTOR (15 downto 0);
    signal s_input2     : STD_LOGIC_VECTOR (15 downto 0);
    signal s_carryIn    : STD_LOGIC;
    signal s_output    : STD_LOGIC_VECTOR (15 downto 0);
    signal s_carryOut   : STD_LOGIC;
begin
    utt: multiBitAdder port map(
        input1pin => s_input1,
        input2pin => s_input2,
        output => s_output,
        carryIn => s_carryIn,
        carryOut => s_carryOut
    );
    
    stimProc: process
    begin
        s_carryIn <= '0';
        s_input1 <= x"003C";
        s_input2 <= x"0010";
        wait for 100ns;
        s_input1 <= x"003C";
        s_input2 <= x"0110";
        wait;
    end process;
        
end Behavioral;
