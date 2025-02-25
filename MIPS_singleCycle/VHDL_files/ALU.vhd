----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 04:44:33 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (5 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           rd1 : in STD_LOGIC_VECTOR (31 downto 0);
           rd2 : in STD_LOGIC_VECTOR (31 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           PC_plus_4 : in STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           branch_addr : out STD_LOGIC_VECTOR (31 downto 0));
end ALU;

architecture Behavioral of ALU is
signal input2: std_logic_vector(31 downto 0):=(others=>'0');
signal res_interm: std_logic_vector(31 downto 0):=(others=>'0');
signal ALUCtrl: std_logic_vector(2 downto 0):=(others=>'0');

begin
input2<=rd2 when ALUSrc='0' else ext_imm;
ALURes<=res_interm;
branch_addr<=ext_imm(29 downto 0) & "00" + PC_plus_4;
zero<='1' when res_interm=X"00000000" else '0';

process(ALUOp, func)
begin
case ALUOp is
when "00"=>
    case func is
    when "000000"=> ALUCtrl<="000";
    when "000001"=> ALUCtrl<="001";
    when "000010"=> ALUCtrl<="010";
    when "000011"=> ALUCtrl<="011";
    when "000100"=> ALUCtrl<="100";
    when "000101"=> ALUCtrl<="101";
    when "000110"=> ALUCtrl<="110";
    when others=> ALUCtrl<="111";
    end case;
when "01"=> ALUCtrl<="000";
when "10"=> ALUCtrl<="001";
when others=> ALUCtrl<="101";
end case;
end process;

process(ALUCtrl)
begin
case ALUCtrl is
when "000"=> res_interm<=rd1 + input2;
when "001"=> res_interm<=rd1 - input2;
when "010"=> res_interm<=to_stdlogicvector(to_bitvector(input2) sll conv_integer(sa));
when "011"=> res_interm<=to_stdlogicvector(to_bitvector(input2) srl conv_integer(sa));
when "100"=> res_interm<=rd1 and input2;
when "101"=> res_interm<=rd1 or input2;
when "110"=> res_interm<=to_stdlogicvector(to_bitvector(input2) sra conv_integer(sa));
when others=> res_interm<=rd1 xor input2;
end case;
end process;

end Behavioral;
