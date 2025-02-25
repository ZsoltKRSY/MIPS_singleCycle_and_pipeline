----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 04:30:40 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           regWrite : in STD_LOGIC;
           extOp : in STD_LOGIC;
           en : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (31 downto 0);
           wr_addr : in STD_LOGIC_VECTOR(4 downto 0);
           wr_data : in STD_LOGIC_VECTOR (31 downto 0);
           rd1 : out STD_LOGIC_VECTOR (31 downto 0);
           rd2 : out STD_LOGIC_VECTOR (31 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0);
           write_addr1 : out STD_LOGIC_VECTOR(4 downto 0);
           write_addr2 : out STD_LOGIC_VECTOR(4 downto 0));
end ID;

architecture Behavioral of ID is
signal read_addr1: std_logic_vector(4 downto 0);
signal read_addr2: std_logic_vector(4 downto 0);

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (others => X"00000000");

begin
read_addr1<=instr(25 downto 21);
read_addr2<=instr(20 downto 16);
ext_imm<=X"0000" & instr(15 downto 0) when extOp='0' else
    instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & 
    instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15) & instr(15 downto 0);
func<=instr(5 downto 0);
sa<=instr(10 downto 6);
write_addr1<=instr(20 downto 16);
write_addr2<=instr(15 downto 11);

process(clk)
begin
if falling_edge(clk) then
    if regWrite = '1' and en='1' then
        reg_file(conv_integer(wr_addr)) <= wr_data;
    end if;
end if;
end process;

rd1 <= reg_file(conv_integer(read_addr1));
rd2 <= reg_file(conv_integer(read_addr2));

end Behavioral;
