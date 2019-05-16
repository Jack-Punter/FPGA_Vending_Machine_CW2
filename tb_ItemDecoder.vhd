library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ItemDecoder is
--  Port ( );
end tb_ItemDecoder;

architecture Behavioral of tb_ItemDecoder is
    component ItemDecoder is port(
        clk : in STD_LOGIC;
        item : in STD_LOGIC_VECTOR (2 downto 0);
        value : out STD_LOGIC_VECTOR (15 downto 0);
        read : out STD_LOGIC
    );
    end component;
    
    signal s_itemId : STD_LOGIC_VECTOR (2 downto 0);
    signal s_itemValue : STD_LOGIC_VECTOR (15 downto 0);
    signal s_read : STD_LOGIC;
    
    signal s_gclk : STD_LOGIC;
    constant clk_period: time := 10ns;
    
begin
    utt : ItemDecoder port map(
        clk => s_gclk,
        item => s_itemId,
        value => s_itemValue,
        read => s_read
    );
    
    clk_process: process
    begin
        s_gclk <= '1';
        wait for clk_period/2;
        s_gclk <= '0';
        wait for clk_period/2;
    end process;
    
    stim_proc: process
    begin
        for i in 0 to 7 loop
            s_itemId <= STD_LOGIC_VECTOR(to_unsigned(i, s_itemId'length));
            wait for clk_period;
            s_itemId <= "000";
            wait for clk_period;
        end loop;
        wait;
    end process;

end Behavioral;
