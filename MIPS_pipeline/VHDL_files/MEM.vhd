----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 05:29:20 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           ALUResIN : in STD_LOGIC_VECTOR (31 downto 0);
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           memData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOUT : out STD_LOGIC_VECTOR (31 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal mem: ram_type := (
0=>"00000000000000000000000000000110", -- X"00000006"  6, N
1=>"00000000000000000000000000001000", -- X"00000008"  8=2*4, A
2=>"00000000000000000000000000000011", -- X"00000003"  3, S(0)
3=>"00000000000000000000000000000100", -- X"00000004"  4, S(1)
4=>"00000000000000000000000000001001", -- X"00000009"  9, S(2)
5=>"00000000000000000000000000000010", -- X"00000002"  2, S(3)
6=>"00000000000000000000000000000001", -- X"00000001"  1, S(4)
7=>"00000000000000000000000000001110", -- X"0000000E"  14, S(5)
--8=>"00000000000000000000000000100001", -- X"00000021"  33, rez
--9=>"00000000000000000000000010000100", -- X"00000084"  132, rez*4
others => X"00000000"); --3 7 10 12 13 21  84

begin
process(clk)
begin
if rising_edge(clk) then
    if memWrite = '1' and en='1' then
        mem(conv_integer(ALUResIN(7 downto 2)))<=rd2;
    end if;
end if;
end process;

ALUResOUT<=ALUResIN;
memData<=mem(conv_integer(ALUResIN(7 downto 2)));

end Behavioral;
