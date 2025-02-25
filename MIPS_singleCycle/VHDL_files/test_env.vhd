----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 04:43:03 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
--IFetch
signal en: std_logic:='0';
signal reset: std_logic:='0';
signal PCSrc: std_logic:='0';
signal jump_addr: std_logic_Vector(31 downto 0):=(others=>'0');
signal branch_addr: std_logic_Vector(31 downto 0):=(others=>'0');
signal instr: std_logic_vector(31 downto 0):=(others=>'0');
signal PC_plus_4: std_logic_vector(31 downto 0):=(others=>'0');

--ID
signal regWrite: std_logic:='0';
signal regDst: std_logic:='0';
signal extOp: std_logic:='0';
signal read_data1: std_logic_vector(31 downto 0):=(others=>'0');
signal read_data2: std_logic_vector(31 downto 0):=(others=>'0');
signal write_data: std_logic_vector(31 downto 0):=(others=>'0');
signal ext_imm: std_logic_vector(31 downto 0):=(others=>'0');
signal func: std_logic_vector(5 downto 0):=(others=>'0');
signal sa: std_logic_vector(4 downto 0):=(others=>'0');

--UC
signal ALUOp: std_logic_vector(1 downto 0):="00";
signal ALUSrc: std_logic:='0';
signal memWrite: std_logic:='0';
signal memToReg: std_logic:='0';
signal branchE: std_logic:='0';
signal branchNE: std_logic:='0';
signal jump: std_logic:='0';

--ALU
signal zero: std_logic:='0';
signal ALURes: std_logic_vector(31 downto 0):=(others=>'0');

--MEM
signal memData: std_logic_vector(31 downto 0):=(others=>'0');
signal ALUResOUT: std_logic_vector(31 downto 0):=(others=>'0');

signal ssd_data: std_logic_Vector(31 downto 0):=(others=>'0');

component MPG is
port(
signal clk, btn: in std_logic;
signal en: out std_logic);
end component;

component SSD is
port(
signal clk: in std_logic;
signal data: in std_logic_vector(31 downto 0);
signal cat: out std_logic_vector(6 downto 0);
signal an: out std_logic_vector(7 downto 0));
end component;

component IFetch is
port(
clk: in std_logic;
jump: in std_logic;
PCSrc: in std_logic;
en: in std_logic;
reset: in std_logic;
jump_address: in std_logic_vector (31 downto 0);
branch_address: in std_logic_vector (31 downto 0);
instruction: out std_logic_vector (31 downto 0);
PC_plus_4: out std_logic_vector (31 downto 0));
end component;

component ID is
port(
clk: in std_logic;
regWrite: in std_logic;
regDst: in std_logic;
extOp: in std_logic;
en: in std_logic;
instr: in std_logic_vector (31 downto 0);
wd: in std_logic_vector (31 downto 0);
rd1: out std_logic_vector (31 downto 0);
rd2: out std_logic_vector (31 downto 0);
ext_imm: out std_logic_vector (31 downto 0);
func: out std_logic_vector (5 downto 0);
sa: out std_logic_vector (4 downto 0));
end component;

component UC is
port(
opcode: in std_logic_vector (5 downto 0);
regDst: out std_logic;
regWrite: out std_logic;
ALUSrc: out std_logic;
extOp: out std_logic;
memWrite: out std_logic;
memToReg: out std_logic;
branchE: out std_logic;
branchNE: out std_logic;
jump: out std_logic;
ALUOp: out std_logic_vector (1 downto 0));
end component;

component ALU is
port(
ALUSrc: in std_logic;
ALUOp: in std_logic_vector (1 downto 0);
func: in std_logic_vector (5 downto 0);
sa: in std_logic_vector (4 downto 0);
rd1: in std_logic_vector (31 downto 0);
rd2: in std_logic_vector (31 downto 0);
ext_imm: in std_logic_vector (31 downto 0);
PC_plus_4: in std_logic_vector (31 downto 0);
zero: out std_logic;
ALURes: out std_logic_vector (31 downto 0);
branch_addr: out std_logic_vector (31 downto 0));
end component;

component MEM is
port(
clk: in std_logic;
en: in std_logic;
memWrite: in std_logic;
ALUResIN : in std_logic_vector (31 downto 0);
rd2: in std_logic_vector (31 downto 0);
memData: out std_logic_vector (31 downto 0);
ALUResOUT: out std_logic_vector (31 downto 0));
end component;

begin
test_env_MPG: MPG port map(
clk=>clk,
btn=>btn(4),
en=>en
);

test_env_SSD: SSD port map(
clk=>clk,
data=>ssd_data,
cat=>cat,
an=>an
);

test_env_IFetch: IFetch port map(
clk=>clk,
jump=>jump,
PCSrc=>PCSrc,
en=>en,
reset=>reset,
jump_address=>jump_addr,
branch_address=>branch_addr,
instruction=>instr,
PC_plus_4=>PC_plus_4
);

test_env_ID: ID port map(
clk=>clk,
regWrite=>regWrite,
regDst=>regDst,
extOp=>extOp,
en=>en,
instr=>instr,
wd=>write_data,
rd1=>read_data1,
rd2=>read_data2,
ext_imm=>ext_imm,
func=>func,
sa=>sa
);

test_env_UC: UC port map(
opcode=>instr(31 downto 26),
regDst=>regDst,
regWrite=>regWrite,
ALUSrc=>ALUSrc,
extOp=>extOp,
memWrite=>memWrite,
memToReg=>memToReg,
branchE=>branchE,
branchNE=>branchNE,
jump=>jump,
ALUOp=>ALUOp
);

test_env_ALU: ALU port map(
ALUSrc=>ALUSrc,
ALUOp=>ALUOp,
func=>func,
sa=>sa,
rd1=>read_data1,
rd2=>read_data2,
ext_imm=>ext_imm,
PC_plus_4=>PC_plus_4,
zero=>zero,
ALURes=>ALURes,
branch_addr=>branch_addr
);

test_env_MEM: MEM port map(
clk=>clk,
en=>en,
memWrite=>memWrite,
ALUResIN=>ALURes,
rd2=>read_data2,
memData=>memData,
ALUResOUT=>ALUResOUT
);

jump_addr<=PC_plus_4(31 downto 28) & instr(25 downto 0) & "00";
write_data<=memData when memToReg='1' else ALUResOUT;
PCSrc<=(branchE and zero) or (branchNE and not(zero));

reset<=btn(3);
led(0)<=ALUOp(1);
led(1)<=ALUOp(0);
led(2)<=regDst;
led(3)<=regWrite;
led(4)<=ALUSrc;
led(5)<=extOp;
led(6)<=memWrite;
led(7)<=memToReg;
led(8)<=branchE;
led(9)<=branchNE;
led(10)<=jump;
led(11)<=zero;
led(12)<=PCSrc;

process(sw(7 downto 5))
begin
case sw(7 downto 5) is
when "000"=> ssd_data<=instr;
when "001"=> ssd_data<=PC_plus_4;
when "010"=> ssd_data<=read_data1;
when "011"=> ssd_data<=read_data2;
when "100"=> ssd_data<=ext_imm;
when "101"=> ssd_data<=ALURes;
when "110"=> ssd_data<=memData;
when others=> ssd_data<=write_data;
end case;
end process;

end Behavioral;
