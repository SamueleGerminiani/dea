`define SA(ID,SIGNAL,SIZE) \
`ifdef ID  \
    {SIGNAL & ~({{SIZE-1{1'b0}}, 1'b1} << `bit)}\
`else\
    SIGNAL\
`endif

