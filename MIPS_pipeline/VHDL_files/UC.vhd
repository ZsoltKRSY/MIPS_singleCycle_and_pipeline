----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 05:19:28 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port ( opcode : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           regDst : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           extOp : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           branchE : out STD_LOGIC;
           branchNE : out STD_LOGIC;
           jump : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

begin
process(opcode)
begin
ALUOp<="00"; regDst<='0'; regWrite<='0'; ALUSrc<='0'; extOp<='0';
memWrite<='0'; memToReg<='0'; branchE<='0'; branchNE<='0'; jump<='0';

case opcode is
when "000000"=> regDst<='1'; regWrite<='1'; --type R
when "000001"=> ALUOp<="01"; regWrite<='1'; ALUSrc<='1'; ExtOp<='1'; --addi
when "000010"=> ALUOp<="01"; regWrite<='1'; ALUSrc<='1'; ExtOp<='1'; MemToReg<='1'; --lw
when "000011"=> ALUOp<="01"; ALUSrc<='1'; ExtOp<='1'; MemWrite<='1'; --sw
when "000100"=> ALUOp<="10"; ExtOp<='1'; BranchE<='1'; --beq
when "000101"=> ALUOp<="11"; regWrite<='1'; ALUSrc<='1'; --ori
when "000110"=> ALUOp<="10"; ExtOp<='1'; BranchNE<='1'; --bne
when others=> jump<='1'; --jump
end case;

end process;

end Behavioral;
