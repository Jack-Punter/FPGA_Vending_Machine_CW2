library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ItemDecoder is
    Port(
        clk : in STD_LOGIC;
        item : in STD_LOGIC_VECTOR (2 downto 0);
        value : out STD_LOGIC_VECTOR (15 downto 0);
        read : out STD_LOGIC
    );
end ItemDecoder;

architecture Behavioral of ItemDecoder is
    signal itemCode : STD_LOGIC_VECTOR(2 downto 0);
begin
itemCode <= item;

    stimProc: process(clk)
    begin
        if rising_edge(clk) then
            read <= '0';
            case itemCode is
                --  Item ID               Item Value
                when "000" => value <= "0000000000000000";
                when "001" => value <= "0000000001111000";
                when "010" => value <= "0000000001111000";
                when "011" => value <= "0000000001111000";
                when "100" => value <= "0000000000111100";
                when "101" => value <= "0000000000111100";
                when "110" => value <= "0000000001010000";
                when "111" => value <= "0000000001100100";
                when others => null;
            end case;
            if (itemCode /= "000") then
                read <= '1';
            end if;
        end if;
    end process;
end Behavioral;
