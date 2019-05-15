library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_VendingMachine is
--  Port ( );
end tb_VendingMachine;

architecture Behavioral of tb_VendingMachine is
    component VendingMachine is Port(
        -- Input Ports
        clk       : in STD_LOGIC;
        coinID : in STD_LOGIC_VECTOR (2 downto 0);
        sensor    : in STD_LOGIC;
        itemID    : in STD_LOGIC_VECTOR (2 downto 0);
        reset     : in STD_LOGIC;
        power     : in STD_LOGIC;
        
        -- Output Ports
        change     : out STD_LOGIC_VECTOR (15 downto 0);
        changeDone : out STD_LOGIC;
        itemDone   : out STD_LOGIC
    );
    end component;

    constant clk_period : TIME := 10ns;
    -- Input Signals
    signal s_clk       : STD_LOGIC := '0';
    signal s_coinID    : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal s_sensor    : STD_LOGIC := '0';
    signal s_itemID    : STD_LOGIC_VECTOR (2 downto 0)  := (others => '0');
    signal s_reset     : STD_LOGIC := '0';
    signal s_power     : STD_LOGIC := '1';

    -- Output Singals
    signal s_change     : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_changeDone : STD_LOGIC := '0';
    signal s_itemDone   : STD_LOGIC := '0';
    
    -- Misc controll signals
    signal s_count : integer := 0;
    --signal s_sensorControl : STD_LOGIC := '0';
begin
    utt: VendingMachine port map(
        -- Input Ports
        clk       => s_clk,
        coinID    => s_coinID,
        sensor    => s_sensor,
        itemID    => s_itemID,
        reset     => s_reset,
        power     => s_power,

        -- Output Ports
        change     => s_change,
        changeDone => s_changeDone,
        itemDone   => s_itemDone
    );


    clk_proc : process
    begin
        s_clk <= '1';
        wait for clk_period/2;
        s_clk <= '0';
        wait for clk_period/2;
    end process;

    stimProc: process(s_clk)
    begin
        if rising_edge(s_clk) then 
            if s_count <= 15 then
                if s_sensor = '0' then
                    s_coinID <= STD_LOGIC_VECTOR(to_unsigned(s_count/2, s_coinID'length));
                    s_sensor <= '1';
                else
                    s_sensor <= '0';
                end if;
            elsif s_count = 16 then
                s_reset <= '1';
            elsif s_count = 17 then
                s_reset <= '0';
            end if;
            s_count <= s_count + 1;
        end if;
end process;

end Behavioral;
