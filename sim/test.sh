#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

SIM_SRC="sim_rtl.f"
SYN_SRC="sim_gate.f"

# Loop over S and NUM
for img in {0..99}; do
    # Run the Verilog simulation and redirect output to a log file
    log_file="./rtl_sim_log/rtl_img${img}.log"
    vcs -full64 -R -debug_access+all +v2k +neg_tchk -f ${SIM_SRC}  +define+img=$img > $log_file 2>&1

    # Check for the pass/fail message in the log file
    if grep -q "setuphold<setup>" $log_file; then
      echo -e "${RED}Setup violation${NC} for picture=$img"
    elif grep -q "setuphold<hold>" $log_file; then
      echo -e "${RED}Hold violation${NC} for picture=$img"
    elif grep -q "Congratulation! All result are correct" $log_file; then
      echo -e "${GREEN}Simulation passed${NC} for picture=$img"
    elif grep -q "errors QQ" $log_file; then
      echo -e "${RED}Simulation failed${NC} for picture=$img"
    elif grep -q "You have exceeded the cycle count limit" $log_file; then
      echo -e "${RED}You have exceeded the cycle count limit${NC} for picture=$img"
    else
      echo -e "${RED}Simulation for img=$img, did not produce a recognizable pass/fail message${NC}"
    fi
done