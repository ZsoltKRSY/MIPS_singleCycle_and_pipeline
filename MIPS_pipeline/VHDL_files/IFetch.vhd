----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 04:23:46 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    Port ( clk : in STD_LOGIC;
           jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           jump_address : in STD_LOGIC_VECTOR (31 downto 0);
           branch_address : in STD_LOGIC_VECTOR (31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0);
           PC_plus_4 : out STD_LOGIC_VECTOR (31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal PC: std_logic_vector (31 downto 0):=(others=>'0');
signal PC_aux: std_logic_vector (31 downto 0):=(others=>'0');

type ROM is array(0 to 31) of std_logic_vector(31 downto 0);
--The program calculates the sum of N (given in the memory at address 0) elements, starting from address A (in memory at address 4). The result is written
--in the data memory after the array, then it is read and multiplied with 4, and the resulting value is written in the memory after the sum of the elements.
--Then we divide the original sum of elements with 2 (in the register only).
signal I_MEM: ROM :=(
0=>B"000010_00000_00001_0000000000000000",-- X"08010000", 00. lw $1, 0($0) - $1 <- MEM(0)=N, initializes R1 with the number of elements
1=>B"000010_00000_00010_0000000000000100",-- X"08020004", 01. lw $2, 4($0) - $2 <- MEM(4)=A, initializes R2 with the starting address of the elements
2=>B"000101_00000_00011_0000000000000000",-- X"14030000", 02. ori $3, $0, 0 - $3 <- 0, initializes the index that goes from 0 to N-1
3=>B"000101_00000_00100_0000000000000000",-- X"14040000", 03. ori $4, $0, 0 - $4 <- 0, initializes R4 with 0 in which we calculate the final sum
4=>B"000010_00010_00101_0000000000000000",-- X"08450000", 04. lw $5, 0($2), $5 <- MEM($2), puts the current elements in R5
5=>B"000001_00011_00011_0000000000000001",-- X"04630001", 05. addi $3, $3, 1 - $3 <- $3 + 1, increments register R3 (index) with 1
6=>B"000001_00010_00010_0000000000000100",-- X"04420004", 06. addi $2, $2, 4 - $2 <- $2 + 4, increments register R2 (address) with 4
7=>B"000000_00100_00101_00100_00000_000000",-- X"00852000", 07. add $4, $4, $5 - $4 <- $4 + $5, adds the current element to the sum
8=>B"000110_00001_00011_1111111111111011",-- X"1861FFF8", 08. bne $1, $3, -9 - if $3 != $1 (i != N) PC <- PC - 6*4 else PC <- PC + 4, if index<N
9=>B"00000000000000000000000000000000", --X"00000000", 09. add $0, $0, $0, noop
10=>B"00000000000000000000000000000000", --X"00000000", 10. add $0, $0, $0, noop
11=>B"00000000000000000000000000000000", --X"00000000", 11. add $0, $0, $0, noop
12=>B"000011_00010_00100_0000000000000000",-- X"0C440000", 12. sw $4, 0($2) - MEM($2) <- $4, writes the resulting sum in the memory after the elements of the original array
13=>B"000010_00010_00110_0000000000000000",-- X"08460000", 13. lw $6, 0($2) - $6 <- MEM($2)=the resulting sum, we load it in register R6
14=>B"00000000000000000000000000000000", --X"00000000", 14. add $0, $0, $0, noop
15=>B"00000000000000000000000000000000", --X"00000000", 15. add $0, $0, $0, noop
16=>B"000000_00000_00110_00110_00010_000010", -- X"00063082", 16. sll $6, $6, 2 - $6 <- $6 << 2, we multiply the value in R6 with 4
17=>B"00000000000000000000000000000000", --X"00000000", 17. add $0, $0, $0, noop
18=>B"000111_00000000000000000000010101", --X"1C000015", 18. j 21, we jump to the address PC=X_54(instr. 21.)
19=>B"000011_00010_00110_0000000000000100", -- X"0C460004", 19. sw $6, 0($2) - MEM($2 + 4) <- $6, we write the resulted value in the memory after the sum of the elements
20=>B"000001_00011_00011_0000000000000001",-- X"04630001", 20. addi $3, $3, 1 - $3 <- $3 + 1, we increment register R3 (index) with 1
21=>B"000000_00000_00100_00100_00001_000011", -- X"00042043", 21. srl $4, $4, 1 - $4 <- $4 >> 2, we divide the value in R4 with 2
others=>X"00000000"
);

begin
PC_plus_4<=PC+4;
instruction<=I_MEM(conv_integer(PC(6 downto 2)));

process(clk, reset)
begin
if reset='1' then
    PC<=(others=>'0');
elsif rising_edge(clk) then
    if en='1' then
        PC<=PC_aux;
    end if;
end if;
end process;

process(jump, PCSrc, jump_address, branch_address, PC)
begin
if jump='1' then
    PC_aux<=jump_address;
elsif PCSrc='1' then
    PC_aux<=branch_address;
else
    PC_aux<=PC+4;
end if;
end process;

end Behavioral;
