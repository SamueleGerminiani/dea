--! @file PEA141D.vhd
--!
--! @author	Andrea Aletto <andrea.aletto8@gmail.com>
--! 
--! @copyright
--! Copyright 2017-2019	Andrea Aletto <andrea.aletto8@gmail.com>
--! 
--! This file is part of AxC-Adders_vhdl
--! 
--! AxC-Adders_vhdl is free software; you can redistribute it and/or modify it under
--! the terms of the GNU General Public License as published by the Free
--! Software Foundation; either version 3 of the License, or any later version.
--! 
--! AxC-Adders_vhdl is distributed in the hope that it will be useful, but WITHOUT
--! ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
--! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
--! more details.
--! 
--! You should have received a copy of the GNU General Public License along with
--! RMEncoder; if not, write to the Free Software Foundation, Inc., 51 Franklin
--! Street, Fifth Floor, Boston, MA 02110-1301, USA.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.InexactCellType.all;
use work.ImageBlockType.all;

entity PEA141D is
	generic (
		nab0		: natural 			:= 0;
		cell_type0	: Inexact_cell_type := cell_AMA1; 
		nab1		: natural 			:= 0;
		cell_type1	: Inexact_cell_type := cell_AMA1; 
		nab2		: natural 			:= 0;
		cell_type2	: Inexact_cell_type := cell_AMA1; 
		nab3		: natural 			:= 0;
		cell_type3	: Inexact_cell_type := cell_AMA1; 
		nab4		: natural 			:= 0;
		cell_type4	: Inexact_cell_type := cell_AMA1; 
		nab5		: natural 			:= 0;
		cell_type5	: Inexact_cell_type := cell_AMA1; 
		nab6		: natural 			:= 0;
		cell_type6	: Inexact_cell_type := cell_AMA1; 
		nab7		: natural 			:= 0;
		cell_type7	: Inexact_cell_type := cell_AMA1; 
		nab8		: natural 			:= 0;
		cell_type8	: Inexact_cell_type := cell_AMA1; 
		nab9		: natural 			:= 0;
		cell_type9	: Inexact_cell_type := cell_AMA1; 
		nab10		: natural 			:= 0;
		cell_type10	: Inexact_cell_type := cell_AMA1; 
		nab11		: natural 			:= 0;
		cell_type11	: Inexact_cell_type := cell_AMA1; 
		nab12		: natural 			:= 0;
		cell_type12	: Inexact_cell_type := cell_AMA1; 
		nab13		: natural 			:= 0;
		cell_type13	: Inexact_cell_type := cell_AMA1; 
		nab14		: natural 			:= 0;
		cell_type14	: Inexact_cell_type := cell_AMA1
 
	);
	
    port (
			clk				: in   	std_logic;

			en				: in   	std_logic;
			rst_n			: in 	std_logic;

			column_in 		: in 	dct_vector;
			column_out 		: out 	dct_vector

    );
end PEA141D;

architecture dataflow of PEA141D is

	component generic_adder_subtractor is
        generic (
                nbits		: natural := 16;
                nab			: natural := 0;
                cell_type	: Inexact_cell_type := cell_AMA1 
        );
        
        port (
                add_1 		: in   std_logic_vector (nbits-1 downto 0);
                add_2 		: in   std_logic_vector (nbits-1 downto 0);
                sub_add_n	: in   std_logic;
                sum 		: out  std_logic_vector (nbits-1 downto 0);
                carry_out	: out  std_logic;
                overflow 	: out  std_logic
        );
	end component;

	component GenericRegister is
		generic(
			N : natural := 16
		); 
		port (	
			clk  : in std_logic;
			rst  : in std_logic;
			data_in : in std_logic_vector (N-1 downto 0);
			en : in std_logic;
			data_out : out std_logic_vector (N-1 downto 0)
		);
	end component;
	
	signal x0a		: std_logic_vector (15 downto 0);
	signal x1a		: std_logic_vector (15 downto 0);
	signal x2a		: std_logic_vector (15 downto 0);
	signal x3a		: std_logic_vector (15 downto 0);
	signal x4a		: std_logic_vector (15 downto 0);
	signal x5a		: std_logic_vector (15 downto 0);
	signal x6a		: std_logic_vector (15 downto 0);
	signal x7a		: std_logic_vector (15 downto 0);

	signal x0b_in	: std_logic_vector (15 downto 0);
	signal x1b_in	: std_logic_vector (15 downto 0);
	signal x2b_in	: std_logic_vector (15 downto 0);
	signal x3b_in	: std_logic_vector (15 downto 0);
	signal x4b_in	: std_logic_vector (15 downto 0);
	signal x5b_in	: std_logic_vector (15 downto 0);
	signal x6b_in	: std_logic_vector (15 downto 0);
	signal x7b_in	: std_logic_vector (15 downto 0);

	signal x0b_out	: std_logic_vector (15 downto 0);
	signal x1b_out	: std_logic_vector (15 downto 0);
	signal x2b_out	: std_logic_vector (15 downto 0);
	signal x3b_out	: std_logic_vector (15 downto 0);
	signal x4b_out	: std_logic_vector (15 downto 0);
	signal x5b_out	: std_logic_vector (15 downto 0);
	signal x6b_out	: std_logic_vector (15 downto 0);
	signal x7b_out	: std_logic_vector (15 downto 0);

	signal x0c_in	: std_logic_vector (15 downto 0);
	signal x1c_in	: std_logic_vector (15 downto 0);
	signal x2c_in	: std_logic_vector (15 downto 0);
	signal x3c_in	: std_logic_vector (15 downto 0);
	signal x4c_in	: std_logic_vector (15 downto 0);
	signal x5c_in	: std_logic_vector (15 downto 0);
	signal x6c_in	: std_logic_vector (15 downto 0);
	signal x7c_in	: std_logic_vector (15 downto 0);

	signal x0c_out	: std_logic_vector (15 downto 0);
	signal x1c_out	: std_logic_vector (15 downto 0);
	signal x2c_out	: std_logic_vector (15 downto 0);
	signal x3c_out	: std_logic_vector (15 downto 0);
	signal x4c_out	: std_logic_vector (15 downto 0);
	signal x5c_out	: std_logic_vector (15 downto 0);
	signal x6c_out	: std_logic_vector (15 downto 0);
	signal x7c_out	: std_logic_vector (15 downto 0);

	signal x0d_in	: std_logic_vector (15 downto 0);
	signal x1d_in	: std_logic_vector (15 downto 0);
	signal x2d_in	: std_logic_vector (15 downto 0);
	signal x3d_in	: std_logic_vector (15 downto 0);
	signal x4d_in	: std_logic_vector (15 downto 0);
	signal x5d_in	: std_logic_vector (15 downto 0);
	signal x6d_in	: std_logic_vector (15 downto 0);
	signal x7d_in	: std_logic_vector (15 downto 0);

	signal x0d_out	: std_logic_vector (15 downto 0);
	signal x1d_out	: std_logic_vector (15 downto 0);
	signal x2d_out	: std_logic_vector (15 downto 0);
	signal x3d_out	: std_logic_vector (15 downto 0);
	signal x4d_out	: std_logic_vector (15 downto 0);
	signal x5d_out	: std_logic_vector (15 downto 0);
	signal x6d_out	: std_logic_vector (15 downto 0);
	signal x7d_out	: std_logic_vector (15 downto 0);


begin

	-- Expand column to 8 different signals

	x0a <= column_in(0);
	x1a <= column_in(1);
	x2a <= column_in(2);
	x3a <= column_in(3);
	x4a <= column_in(4);
	x5a <= column_in(5);
	x6a <= column_in(6);
	x7a <= column_in(7);

	-- PEA14 First step    

	sum_0a7a_inst : generic_adder_subtractor generic map (nab => nab0, cell_type => cell_type0) port map ( add_1 => x0a, add_2 => x7a, sub_add_n => '0', sum => x0b_in);
	sum_1a6a_inst : generic_adder_subtractor generic map (nab => nab1, cell_type => cell_type1) port map ( add_1 => x1a, add_2 => x6a, sub_add_n => '0', sum => x1b_in);
	sum_2a5a_inst : generic_adder_subtractor generic map (nab => nab2, cell_type => cell_type2) port map ( add_1 => x2a, add_2 => x5a, sub_add_n => '0', sum => x2b_in);
	sum_3a4a_inst : generic_adder_subtractor generic map (nab => nab3, cell_type => cell_type3) port map ( add_1 => x3a, add_2 => x4a, sub_add_n => '0', sum => x3b_in);
	sub_3a4a_inst : generic_adder_subtractor generic map (nab => nab4, cell_type => cell_type4) port map ( add_1 => x3a, add_2 => x4a, sub_add_n => '1', sum => x4b_in);
	sub_2a5a_inst : generic_adder_subtractor generic map (nab => nab5, cell_type => cell_type5) port map ( add_1 => x2a, add_2 => x5a, sub_add_n => '1', sum => x5b_in);
	sub_1a6a_inst : generic_adder_subtractor generic map (nab => nab6, cell_type => cell_type6) port map ( add_1 => x1a, add_2 => x6a, sub_add_n => '1', sum => x6b_in);
	sub_0a7a_inst : generic_adder_subtractor generic map (nab => nab7, cell_type => cell_type7) port map ( add_1 => x0a, add_2 => x7a, sub_add_n => '1', sum => x7b_in);

	-- Store results

	reg_x0b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x0b_in, data_out => x0b_out);
	reg_x1b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x1b_in, data_out => x1b_out);
	reg_x2b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x2b_in, data_out => x2b_out);
	reg_x3b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x3b_in, data_out => x3b_out);
	reg_x4b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x4b_in, data_out => x4b_out);
	reg_x5b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x5b_in, data_out => x5b_out);
	reg_x6b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x6b_in, data_out => x6b_out);
	reg_x7b_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x7b_in, data_out => x7b_out);

	-- PEA14 Second step    

	sum_0b3b_inst : generic_adder_subtractor generic map (nab => nab8, cell_type => cell_type8) port map ( add_1 => x0b_out	, add_2 => x3b_out, sub_add_n => '0', sum => x0c_in);
	sum_1b2b_inst : generic_adder_subtractor generic map (nab => nab9, cell_type => cell_type9) port map ( add_1 => x1b_out	, add_2 => x2b_out, sub_add_n => '0', sum => x1c_in);
	sub_1b2b_inst : generic_adder_subtractor generic map (nab => nab10, cell_type => cell_type10) port map ( add_1 => x1b_out	, add_2 => x2b_out, sub_add_n => '1', sum => x2c_in);
	sub_0b3b_inst : generic_adder_subtractor generic map (nab => nab11, cell_type => cell_type11) port map ( add_1 => x0b_out	, add_2 => x3b_out, sub_add_n => '1', sum => x3c_in);
	x4c_in <= x4b_out;
	x5c_in <= x5b_out;
	x6c_in <= x6b_out;
	x7c_in <= x7b_out;

	-- Store results

	reg_x0c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x0c_in, data_out => x0c_out);
	reg_x1c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x1c_in, data_out => x1c_out);
	reg_x2c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x2c_in, data_out => x2c_out);
	reg_x3c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x3c_in, data_out => x3c_out);
	reg_x4c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x4c_in, data_out => x4c_out);
	reg_x5c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x5c_in, data_out => x5c_out);
	reg_x6c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x6c_in, data_out => x6c_out);
	reg_x7c_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x7c_in, data_out => x7c_out);
	
	-- PEA14 Third step

	sum_0c1c_inst : generic_adder_subtractor generic map (nab => nab12, cell_type => cell_type12) port map ( add_1 => x0c_out, add_2 => x1c_out, sub_add_n => '0', sum => x0d_in);
	sub_0c1c_inst : generic_adder_subtractor generic map (nab => nab13, cell_type => cell_type13) port map ( add_1 => x0c_out, add_2 => x1c_out, sub_add_n => '1', sum => x1d_in);
	inv_2c_inst : generic_adder_subtractor generic map (nab => nab14, cell_type => cell_type14) port map ( add_1 => "0000000000000000", add_2 => x2c_out, sub_add_n => '1', sum => x2d_in);
	x3d_in <= x3c_out;
	x4d_in <= x4c_out;
	x5d_in <= x5c_out;
	x6d_in <= x6c_out;
	x7d_in <= x7c_out;

	-- Store results

	reg_x0d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x0d_in, data_out => x0d_out);
	reg_x1d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x1d_in, data_out => x1d_out);
	reg_x2d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x2d_in, data_out => x2d_out);
	reg_x3d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x3d_in, data_out => x3d_out);
	reg_x4d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x4d_in, data_out => x4d_out);
	reg_x5d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x5d_in, data_out => x5d_out);
	reg_x6d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x6d_in, data_out => x6d_out);
	reg_x7d_inst : GenericRegister port map( clk => clk, rst => rst_n, en => en, data_in => x7d_in, data_out => x7d_out); 

	-- PEA14 Permutation step

	column_out(0) <= x0d_out;
	column_out(1) <= x6d_out;
	column_out(2) <= x3d_out;
	column_out(3) <= x7d_out;
	column_out(4) <= x1d_out;
	column_out(5) <= x4d_out;
	column_out(6) <= x2d_out;
	column_out(7) <= x5d_out;

end dataflow;

