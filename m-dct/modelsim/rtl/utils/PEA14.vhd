--! @file PEA14.vhd
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


entity PEA14 is
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
			clk		: in   std_logic;

			en		: in   std_logic;
			rst_n	: in   std_logic;

			blk_in  : in	dct_block;
			blk_out : out	dct_block
    );
end PEA14;

architecture dataflow of PEA14 is

	component PEA141D is
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
			rst_n			: in   	std_logic;

			column_in 		: in 	dct_vector;
			column_out 		: out 	dct_vector
		);
	end component;

	signal row_transf_blk_in	:	dct_block;
	signal row_transf_blk_out	:	dct_block;
	signal transp_blk_in		:	dct_block;
	signal transp_blk_out		:	dct_block;
	signal col_transf_blk_in	:	dct_block;
	signal col_transf_blk_out	:	dct_block;

begin

	-- Initial transposition
	initial_transp_generate : for i in 0 to 7 generate
		row_transf_blk_in(i)(0) <= blk_in(0)(i);
		row_transf_blk_in(i)(1) <= blk_in(1)(i);
		row_transf_blk_in(i)(2) <= blk_in(2)(i);
		row_transf_blk_in(i)(3) <= blk_in(3)(i);
		row_transf_blk_in(i)(4) <= blk_in(4)(i);
		row_transf_blk_in(i)(5) <= blk_in(5)(i);
		row_transf_blk_in(i)(6) <= blk_in(6)(i);
		row_transf_blk_in(i)(7) <= blk_in(7)(i);
	end generate;


	-- Rows transformation block

	row_transform_generate : for i in 0 to 7 generate
		row_transform_inst: PEA141D
			generic map(
				nab0 			=> nab0,
				cell_type0 		=> cell_type0,
				nab1 			=> nab1,
				cell_type1 		=> cell_type1,
				nab2 			=> nab2,
				cell_type2 		=> cell_type2,
				nab3 			=> nab3,
				cell_type3 		=> cell_type3,
				nab4 			=> nab4,
				cell_type4 		=> cell_type4,
				nab5 			=> nab5,
				cell_type5 		=> cell_type5,
				nab6 			=> nab6,
				cell_type6 		=> cell_type6,
				nab7 			=> nab7,
				cell_type7 		=> cell_type7,
				nab8 			=> nab8,
				cell_type8 		=> cell_type8,
				nab9 			=> nab9,
				cell_type9 		=> cell_type9,
				nab10 			=> nab10,
				cell_type10 	=> cell_type10,
				nab11 			=> nab11,
				cell_type11 	=> cell_type11,
				nab12 			=> nab12,
				cell_type12 	=> cell_type12,
				nab13 			=> nab13,
				cell_type13 	=> cell_type13,
				nab14 			=> nab14,
				cell_type14 	=> cell_type14
			)
			port map(
				clk 		=> clk,
				en 			=> en,
				rst_n 		=> rst_n,
				column_in 	=> row_transf_blk_in(i),
				column_out 	=> row_transf_blk_out(i)
			);
	end generate;

	--

	-- DCT1D transposition 
	transp_blk_in <= row_transf_blk_out;
	transp_blk_generate : for i in 0 to 7 generate
		transp_blk_out(i)(0) <= transp_blk_in(0)(i);
		transp_blk_out(i)(1) <= transp_blk_in(1)(i);
		transp_blk_out(i)(2) <= transp_blk_in(2)(i);
		transp_blk_out(i)(3) <= transp_blk_in(3)(i);
		transp_blk_out(i)(4) <= transp_blk_in(4)(i);
		transp_blk_out(i)(5) <= transp_blk_in(5)(i);
		transp_blk_out(i)(6) <= transp_blk_in(6)(i);
		transp_blk_out(i)(7) <= transp_blk_in(7)(i);
	end generate;



	-- Column transformation block

	col_transf_blk_in <= transp_blk_out;
	column_transform_generate : for i in 0 to 7 generate
		column_transform_inst: PEA141D
			generic map(
				nab0 			=> nab0,
				cell_type0 		=> cell_type0,
				nab1 			=> nab1,
				cell_type1 		=> cell_type1,
				nab2 			=> nab2,
				cell_type2 		=> cell_type2,
				nab3 			=> nab3,
				cell_type3 		=> cell_type3,
				nab4 			=> nab4,
				cell_type4 		=> cell_type4,
				nab5 			=> nab5,
				cell_type5 		=> cell_type5,
				nab6 			=> nab6,
				cell_type6 		=> cell_type6,
				nab7 			=> nab7,
				cell_type7 		=> cell_type7,
				nab8 			=> nab8,
				cell_type8 		=> cell_type8,
				nab9 			=> nab9,
				cell_type9 		=> cell_type9,
				nab10 			=> nab10,
				cell_type10 	=> cell_type10,
				nab11 			=> nab11,
				cell_type11 	=> cell_type11,
				nab12 			=> nab12,
				cell_type12 	=> cell_type12,
				nab13 			=> nab13,
				cell_type13 	=> cell_type13,
				nab14 			=> nab14,
				cell_type14 	=> cell_type14
			)
			port map(
				clk 		=> clk,
				en 			=> en,
				rst_n 		=> rst_n,
				column_in 	=> col_transf_blk_in(i),
				column_out 	=> col_transf_blk_out(i)
			);
	end generate;

	-- Output assignament
	blk_out <= col_transf_blk_out;

end dataflow;

