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
        RST  : in STD_LOGIC;
        
        coinID : in STD_LOGIC_VECTOR (2 downto 0);
        sensor : in STD_LOGIC;
        
        toSub        : in STD_LOGIC_VECTOR (15 downto 0);
        subItemValue : in STD_LOGIC;
        giveChange   : in STD_LOGIC;
        
        credit     : out STD_LOGIC_VECTOR (15 downto 0);
        change     : out STD_LOGIC_VECTOR (15 downto 0);
        changeDone : out STD_LOGIC
    );
    end component;
    
    constant clk_period   : time := 10ns;
    signal s_GCLK         : STD_LOGIC;
    signal s_reset        : STD_LOGIC := '0';
    
    signal s_coin         : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal s_sensor       : STD_LOGIC := '0';
    
    signal s_toSub        : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal s_subItemValue : STD_LOGIC := '0';
    signal s_giveChange   : STD_LOGIC := '0';
    
    signal s_creditStored : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal s_change       : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal s_changeDone   : STD_LOGIC;       
    
    signal s_count : integer := 0;
begin
    utt: creditController port map(
        GCLK => s_GCLK,
        RST => s_reset,
        
        coinID => s_coin,
        sensor => s_sensor,
        
        toSub => s_toSub,
        subItemValue => s_subItemValue,
        giveChange => s_giveChange,
        
        credit => s_creditStored,
        change => s_change,
        changeDone => s_changeDone
    );
    
    clkProc : process
    begin
        s_GCLK <= '0';
        wait for clk_period/2;
        s_GCLK <= '1';
        wait for clk_period/2;
    end process;
    
    ItemValueSubTest: process(s_GCLK)
    begin
    if rising_edge(s_GCLK) then
        -- 1 Time insert �20 note
        if s_count = 1 then
            s_coin <= "111";
            s_sensor <= '1';
        elsif s_count = 2 then
            s_coin <= "000";
            s_sensor <= '0';
        elsif s_count = 3 then
            s_toSub <= x"0078";
            s_subItemValue <= '1';
        elsif s_count = 4 then
            s_toSub <= (others => '0');
            s_subItemValue <= '0';
        elsif s_count = 5 then
            s_giveChange <= '1';
        elsif s_count = 6 then
            s_giveChange <= '0';    
        end if;
        -- Increment count to control tb
        s_count <= s_count + 1;
    end if;
    end process;

end Behavioral;











