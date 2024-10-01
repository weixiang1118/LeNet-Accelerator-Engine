set cycle 1.73
analyze -format verilog  { ../hdl/lenet.v  }

elaborate lenet -architecture verilog 

source compile.tcl
