library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_CreditController is
--  Port ( );
end tb_CreditController;
architecture Behavioral of tb_creditController is
    component creditController is port(
        GCLK : in STD_LOGIC;
        coinID   : in STD_LOGIC_VECTOR (2 downto 0);
        sensor : in STD_LOGIC;
        toSub  : in STD_LOGIC_VECTOR (15 downto 0);
        sub    : in STD_LOGIC;
        RST : in STD_LOGIC;
        credit : out STD_LOGIC_VECTOR (15 downto 0) 
    );
    end component;
    signal s_GCLK         : STD_LOGIC;
    constant clk_period   : time := 10ns;
    signal s_coin         : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal s_sensor       : STD_LOGIC := '0';
    signal s_toSub        : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal s_sub          : STD_LOGIC := '0';
    signal s_creditStored : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal s_reset        : STD_LOGIC := '0';
    
    signal s_count : integer := 0;
    signal control : STD_LOGIC := '0';
begin
    utt: creditController port map(
        GCLK => s_GCLK,
        coinID => s_coin,
        sensor => s_sensor,
        toSub => s_toSub,
        sub => s_sub,
        RST => s_reset,
        credit => s_creditStored
    );
    
    clkProc : process
    begin
        s_GCLK <= '0';
        wait for clk_period/2;
        s_GCLK <= '1';
        wait for clk_period/2;
    end process;
    
    stimProc: process(s_GCLK)
    begin
        if rising_edge(s_GCLK) and s_count < 8 and s_reset = '0' then
            if control = '1' then
                s_coin <= STD_LOGIC_VECTOR(to_unsigned(s_count, s_coin'length));
                s_sensor <= '1';
            else
                s_sensor <= '0';
                s_count <= s_count + 1;
            end if;
            control <= not(control);
        end if;
    end process;
end Behavioral;











