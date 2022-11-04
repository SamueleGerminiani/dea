
`define SAC(SIGNAL,MASK) \
`ifdef SIGNAL  \
    {SIGNAL & MASK}\
`else\
    SIGNAL\
`endif
