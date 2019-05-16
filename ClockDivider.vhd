library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ClockDivider is
    Port ( 
        GCLK : in STD_LOGIC;
        vmClk : out STD_LOGIC
    );
end ClockDivider;

architecture Behavioral of ClockDivider is
    constant clockCountInit : integer := 100000000;
    constant vectorBitcount : integer := 25;
    signal clockCount : integer := clockCountInit;
    signal s_vmClk : STD_LOGIC :=  '0';
    signal s_vmClkBits : STD_LOGIC_VECTOR (vectorBitcount - 1 downto 0) := (others => '0');
begin
    vmClk <= s_vmClkBits(vectorBitcount - 1);

    --Clock process (also divides)
    clockDivide: process(GCLK)
    begin
    if rising_edge(GCLK) then
        s_vmClkBits <= STD_LOGIC_VECTOR(unsigned(s_vmClkBits) + 1);
    end if;
    end process;

end Behavioral;
