module lenet (
    input wire clk,
    input wire rst_n,

    input wire compute_start,
    output reg compute_finish,

    // Quantization scale
    input wire [31:0] scale_CONV1,
    input wire [31:0] scale_CONV2,
    input wire [31:0] scale_CONV3,
    input wire [31:0] scale_FC1,
    input wire [31:0] scale_FC2,

    // Weight sram, dual port
    output reg [ 3:0] sram_weight_wea0,
    output reg [15:0] sram_weight_addr0,
    output reg [31:0] sram_weight_wdata0,
    input wire [31:0] sram_weight_rdata0,
    output reg [ 3:0] sram_weight_wea1,
    output reg [15:0] sram_weight_addr1,
    output reg [31:0] sram_weight_wdata1,
    input wire [31:0] sram_weight_rdata1,

    // Activation sram, dual port
    output reg [ 3:0] sram_act_wea0,
    output reg [15:0] sram_act_addr0,
    output reg [31:0] sram_act_wdata0,
    input wire [31:0] sram_act_rdata0,
    output reg [ 3:0] sram_act_wea1,
    output reg [15:0] sram_act_addr1,
    output reg [31:0] sram_act_wdata1,
    input wire [31:0] sram_act_rdata1
);
    // Add your design here
    //input dff for lenet //
reg rst_n_d,  compute_start_d,compute_finish_d;
//M
reg  signed [31:0] scale_CONV1_d, scale_CONV2_d, scale_CONV3_d, scale_FC1_d, scale_FC2_d;
//SRAM READ DATA
//SRAM WRITE ENABLE
reg [3:0] sram_weight_wea0_d, sram_weight_wea1_d, sram_act_wea0_d, sram_act_wea1_d;
//SRAM ADDRESS
reg [15:0] sram_weight_addr0_d, sram_weight_addr1_d, sram_act_addr0_d, sram_act_addr1_d;
//SRAM DATA //
reg [31:0] sram_weight_wdata0_d, sram_weight_wdata1_d, sram_act_wdata0_d, sram_act_wdata1_d;

reg signed[7:0] sram_weight_rdata0_d [3:0];
reg signed[7:0] sram_weight_rdata1_d [3:0];
reg signed [7:0] sram_act_rdata0_d [3:0];
reg signed [7:0] sram_act_rdata1_d [3:0];

integer i;

always@(posedge clk)
begin 
        compute_start_d <= compute_start;

        scale_CONV1_d <= scale_CONV1;
        scale_CONV2_d <= scale_CONV2;
        scale_CONV3_d <= scale_CONV3;
        scale_FC1_d <= scale_FC1;
        scale_FC2_d <= scale_FC2;

        {sram_weight_rdata0_d[3], sram_weight_rdata0_d[2], sram_weight_rdata0_d[1], sram_weight_rdata0_d[0]} <= sram_weight_rdata0;
        {sram_weight_rdata1_d[3], sram_weight_rdata1_d[2], sram_weight_rdata1_d[1], sram_weight_rdata1_d[0]} <= sram_weight_rdata1;
        
        {sram_act_rdata0_d[3], sram_act_rdata0_d[2], sram_act_rdata0_d[1], sram_act_rdata0_d[0]} <= sram_act_rdata0;
        {sram_act_rdata1_d[3], sram_act_rdata1_d[2], sram_act_rdata1_d[1], sram_act_rdata1_d[0]} <= sram_act_rdata1;
end

/*
    sram weight doesn't need to write data

*/
always@(posedge clk)begin
    sram_weight_wea0 <= 0;
    sram_weight_wea1 <= 0;
    sram_weight_wdata0 <= 0;
    sram_weight_wdata1 <= 0;
    sram_act_wea1 <= 0;
end


/*

    conv1 fsm

*/


parameter idle = 4'd0;
parameter load_addr = 4'd1;
parameter load_data0 = 4'd2;
parameter load_data1 = 4'd3;
parameter compute = 4'd4;
parameter to_zero = 4'd5;
parameter to_zero1 = 4'd6;
parameter wr_in_reg1 = 4'd7;
parameter wr_in_reg2 = 4'd8;
parameter reload_addr = 4'd9;
parameter finish = 4'd10;

(* synthesis, fsm_state = "onehot" *) reg [3:0] next_state, state;
(* synthesis, fsm_state = "onehot" *) reg [2:0] next_state1, state1;

reg [2:0] localcounter , localcounter_next;
reg [4:0] outputchannelcounter , outputchannelcounter_next;
reg [2:0] intputchannelcounter , intputchannelcounter_next;
reg [2:0] colcounter, colcounter_next;
reg [3:0] rowcounter , rowcounter_next;
reg [8:0] writecounter_sram , writecounter_sram_next;
reg [1:0] writecounter, writecounter_next;
reg [5:0] coumput_cnt , coumput_cnt_next;

reg startcom1;
reg startcom2;
reg done0;
reg done1;
reg write_enable , write_enable_next;



wire  signed [24:0] psum [7:0];
reg   signed [24:0] psum_o0 [3:0];
wire signed [24:0] out_max[1:0];
wire signed [7:0] out_actq[1:0];
reg  signed [31:0] scale;
wire signed [7:0] in [4:0];
wire signed [7:0] we [3:0];
reg  signed [7:0] weight_buffer1 [4:0];
wire [24:0] psum_to_actq ;

always @(posedge clk) begin
    if(!rst_n)begin
        scale <= 0;
    end
    else begin
        case (state1)
            0: scale <= scale_CONV1_d;
            1: scale <= scale_CONV2_d;
            2: scale <= scale_CONV3_d;
            3: scale <= scale_FC1_d;
            default: scale <= 0;
        endcase
    end
end
always@(posedge clk)begin
    if(!rst_n)begin
        state1 <= 0;
    end
    else begin
        state1 <= next_state1;
    end
end
always @(*) begin
    next_state1 = 0;
    case(state1)
        0 : begin
            if(sram_act_addr0 == 591 && state == reload_addr) next_state1 = 1;
            else next_state1 = 0;
        end
        1 : begin
            if(outputchannelcounter == 16 && state == reload_addr) next_state1 = 2;
            else next_state1 = 1;
        end
        2: begin
            if (sram_act_addr0 == 721 ) next_state1 = 3;
            else next_state1 = 2;
        end
        3: begin
            if (sram_act_addr0 == 742 ) next_state1 = 4;
            else next_state1 = 3;
        end
        4: next_state1 = 4;
        default: next_state1 = 0;
    endcase
end

always@(posedge clk)begin
    if(!rst_n) state <= idle;
    else state <= next_state;
end

always@(*)begin
    case(state)
        idle: begin
            if(compute_start_d) next_state = load_addr;
            else next_state = idle;
        end
        load_addr: next_state = load_data0;
        load_data0: next_state = load_data1;
        load_data1: next_state = compute;
        compute: begin
            case(state1)
            0 : begin
                if(coumput_cnt == 4) next_state = to_zero;
                else next_state = compute;
            end
            1 : begin
                if(coumput_cnt == 34) next_state = to_zero;
                else next_state = compute;
            end
            2 : begin
                if(coumput_cnt == 49) next_state = to_zero;
                else next_state = compute;
            end
            3 : begin
                if(coumput_cnt == 14) next_state = to_zero;
                else next_state = compute;
            end
            4 : begin
                if(coumput_cnt == 10) next_state = to_zero;
                else next_state = compute;
            end
            default: next_state = idle;
            endcase
        end
        to_zero: begin
            case(state1)
            0 : begin
                if(writecounter == 2 || colcounter == 7) next_state = to_zero1;
                else next_state = compute; 
            end
            1 : begin
                if(writecounter == 2 || colcounter == 3 || writecounter == 3) next_state = to_zero1;
                else next_state = compute;
            end
            2,3 : begin
                if(writecounter == 3) next_state = wr_in_reg2;
                else next_state = compute;
            end
            4 : next_state = wr_in_reg2;

            default: next_state = idle;
            endcase
        end
        to_zero1 : next_state = wr_in_reg1; 
        wr_in_reg1: next_state = wr_in_reg2;
        wr_in_reg2: next_state = reload_addr;
        reload_addr:begin
            case(state1)
                0 : begin
                    if(sram_act_addr0 == 591) next_state = load_addr;
                    else next_state = load_data0;
                end
                1 : begin
                    if(outputchannelcounter == 16) next_state = load_addr;
                    else next_state = load_data0;
                end
                2 : begin
                    if(sram_act_addr0 == 721) next_state = load_addr;
                    else next_state = load_data0;
                end
                3 : begin
                    if(sram_act_addr0 == 742) next_state = load_addr;
                    else next_state = load_data0;
                end
                4 : begin
                    if(sram_act_addr0 == 752) next_state = finish;
                    else next_state = load_data0;
                end

                default: next_state = idle;
            endcase 
        end
        finish: next_state = idle;
        default: next_state = idle;
    endcase
end

/*
    finish signal
*/
always@(posedge clk)begin
    if(!rst_n) compute_finish <= 0;
    else begin
        if(state == finish) compute_finish <= 1;
        else compute_finish <= 0;
    end
end

/*
    comput signal 
 */

 always@(*)begin
    case(state)
        compute: begin
            if(localcounter == 1) startcom1 = 0;
            else startcom1 = 1;
        end
        default: startcom1 = 0;
    endcase
 end
 always@(posedge clk)begin
    if(startcom1) startcom2 <= 1;
    else startcom2 <= 0;
 end

always@(posedge clk) begin
    if(!rst_n) done0 <= 0;
    else begin
        if(state == to_zero) done0 <= 1;
        else done0 <= 0;
    end
end
always@(posedge clk)begin
    if(done0) done1 <= 1;
    else done1 <= 0; 
end

 /*
    counter
 */

 // local counter 0-6
 always@(*)begin
    case(state1)
    0, 1 : begin
        case(state)
            load_data0 , load_data1 , compute , to_zero:  begin
                if(localcounter == 5) localcounter_next = 0;
                else localcounter_next = localcounter + 1;
            end
            default : localcounter_next = 0;
        endcase
    end
    default : localcounter_next = 0;
    endcase
end

always@(posedge clk)begin
    if(!rst_n) localcounter <= 0;
    else localcounter <= localcounter_next;
end

// comput counter 0~50 conv1 = 0-5 

always@(*)begin
    case(state)
        compute : coumput_cnt_next = coumput_cnt + 1;
        default : coumput_cnt_next = 0;
    endcase
end

always@(posedge clk)begin
    if(!rst_n) coumput_cnt <= 0;
    else coumput_cnt <= coumput_cnt_next;
end

// column counter 3bit, 0~6 in conv1, 0~2 in conv2 
always@(*)begin
    if(coumput_cnt==1 && state1 == 0) colcounter_next = colcounter + 1;
    else if (coumput_cnt == 32 && state1 == 1) colcounter_next = colcounter + 1;
    else if (state == wr_in_reg1) begin
        if(colcounter == 7) colcounter_next = 0;
        else colcounter_next = colcounter;
    end
    else if (state == wr_in_reg2 && state1 == 1 && colcounter == 3) colcounter_next = 0;
    else colcounter_next = colcounter;
end

always@(posedge clk)begin
    if(!rst_n) colcounter <= 0;
    else colcounter <= colcounter_next;
end

// row counter 0~13 in conv1

always@(*)begin
    case(state1)
    0:begin
        if(colcounter == 6 && coumput_cnt == 1) rowcounter_next = rowcounter + 1;
        else if (rowcounter == 14) rowcounter_next = 0;
        else rowcounter_next = rowcounter;
    end
    1 : begin
        if(colcounter == 3 && coumput_cnt == 33) rowcounter_next = rowcounter + 1;
        else if (rowcounter == 5) rowcounter_next = 0;
        else rowcounter_next = rowcounter;
    end
    default: rowcounter_next = 0;
    endcase
end
always@(posedge clk)begin
    if(!rst_n) rowcounter <= 0;
    else rowcounter <= rowcounter_next;
end

// input channel counter 0 in conv1, 0~5 in conv2
always@(*)begin
    if (coumput_cnt == 32) intputchannelcounter_next = 0;
    else if(state1 == 1 && localcounter == 4) intputchannelcounter_next = intputchannelcounter + 1;
    else intputchannelcounter_next = intputchannelcounter;
end 
always@(posedge clk)begin
    if(!rst_n) intputchannelcounter <= 0;
    else intputchannelcounter <= intputchannelcounter_next;
end

// output channel counter 0~5 in conv1, 0~15 in conv2
always@(*)begin
    case(state1)
        0 : begin
            if(rowcounter == 14) outputchannelcounter_next = outputchannelcounter + 1;
            else if (outputchannelcounter == 6) outputchannelcounter_next = 0;
            else outputchannelcounter_next = outputchannelcounter;
        end
        1 : begin
            if(rowcounter == 5) outputchannelcounter_next = outputchannelcounter + 1;
            else if (outputchannelcounter == 16 && state == reload_addr) outputchannelcounter_next = 0;
            else outputchannelcounter_next = outputchannelcounter;
        end
        4 : begin
            if(coumput_cnt == 9) outputchannelcounter_next = outputchannelcounter + 1;
            else outputchannelcounter_next = outputchannelcounter;
        end
        default: outputchannelcounter_next = 0;
    endcase
end
always@(posedge clk)begin
    if(!rst_n) outputchannelcounter <= 0;
    else outputchannelcounter <= outputchannelcounter_next;
end

/*
    act write data and control and write counter 
*/

//write counter 0~3 in conv1
always@(*)begin
    if (state1 == 4) writecounter_next = 0;
    else if(write_enable) begin
        if(state1 == 1 && colcounter == 3) writecounter_next = writecounter + 1;
        else if (state1 > 1) writecounter_next = writecounter + 1;
        else writecounter_next = writecounter + 2;
    end
    else if (state == reload_addr && state1 == 0) writecounter_next = 0;
    else writecounter_next = writecounter;
end
always@(posedge clk)begin
    if(!rst_n) writecounter <= 0;
    else writecounter <= writecounter_next;
end
// write enable into out_data register
always@(*)begin
    if(done1 && state1 < 2 ) write_enable_next = 1;
    else if (state1 == 1 && colcounter == 3) write_enable_next = 0;
    else if (state1 > 1 && state == to_zero) write_enable_next = 1;
    else write_enable_next = 0;
end
always@(posedge clk)begin
    if(!rst_n) write_enable <= 0;
    else write_enable <= write_enable_next;
end

/*
    wdata1
*/

always@(posedge clk)begin
    if(!rst_n) sram_act_wdata1 <= 0;
    else if (write_enable && writecounter == 3) sram_act_wdata1 <= {24'b0 , out_actq[1]};
    else sram_act_wdata1 <= sram_act_wdata1;
end


always@(posedge clk)begin
    if(!rst_n) sram_act_wea0 <= 0 ;
    else begin
        if(state == wr_in_reg2 || (state1 >1 && state == to_zero1)) sram_act_wea0 <= 4'b1111;
        else sram_act_wea0 <= 0;
    end
end

always@(posedge clk)begin
    if(!rst_n) sram_act_wdata0 <= 0 ;
    else begin
        if(write_enable) begin
            if(state1 == 1 && colcounter == 3)begin
                case(writecounter)
                0: sram_act_wdata0        <= {24'b0 ,out_actq[0]};
                1: sram_act_wdata0[15:0]  <=  {out_actq[0] , sram_act_wdata1[7:0]}; //8-15
                2: sram_act_wdata0[23:16] <=  out_actq[0]; //16-23
                3: sram_act_wdata0[31:24] <=  out_actq[0]; //24-31
                default: sram_act_wdata0  <= 0;
                endcase
            end
            else begin
                if(state1 < 2) begin
                    case(writecounter)
                    0: sram_act_wdata0        <= {16'b0 ,out_actq[1], out_actq[0]};  //0-7
                    1: begin
                        if (colcounter == 2) sram_act_wdata0[23:0] <= {out_actq[1],out_actq[0] , sram_act_wdata1[7:0]};
                        else sram_act_wdata0[23:8]  <=  {out_actq[1],out_actq[0]}; //8-15
                    end
                    2: sram_act_wdata0[31:16] <=  {out_actq[1],out_actq[0]}; //16-23
                    3: sram_act_wdata0[31:24] <= out_actq[0]; //24-31
                    default: sram_act_wdata0  <= 0;
                    endcase
                end
                else begin
                    case(writecounter)
                    0: begin
                        if(state1 == 4) sram_act_wdata0 <= {{{7{psum[0][24]}},psum[0]} + {{7{psum[3][24]}},psum[3]} + {sram_weight_rdata0_d[3],sram_weight_rdata0_d[2],sram_weight_rdata0_d[1],sram_weight_rdata0_d[0]}};  //0-7  
                        else sram_act_wdata0        <= {24'b0,out_actq[0]};  //0-7
                    end
                    1: sram_act_wdata0[15:8]  <=  out_actq[0]; //8-15
                    2: sram_act_wdata0[23:16] <=  out_actq[0]; //16-23
                    3: sram_act_wdata0[31:24] <=  out_actq[0]; //24-31
                    default: sram_act_wdata0  <= 0;
                    endcase
                end
            end
        end
        else sram_act_wdata0 <= sram_act_wdata0;
    end
end

// write counter into sram 
always@(*)begin
    case(state)
        reload_addr : begin
            case(state1)
                0,2,3,4 : writecounter_sram_next = writecounter_sram + 1; 
                1 : begin
                    if(writecounter == 0) writecounter_sram_next = writecounter_sram + 1;
                    else writecounter_sram_next = writecounter_sram;
                end
                default: writecounter_sram_next = 0;
            endcase

        end
        wr_in_reg2 : begin
            if(writecounter == 3 && colcounter != 3 & state1 == 1) writecounter_sram_next = writecounter_sram + 1;
            else writecounter_sram_next = writecounter_sram;
        end
        default: writecounter_sram_next = writecounter_sram;
    endcase
end
always@(posedge clk)begin
    if(!rst_n) writecounter_sram <= 0;
    else writecounter_sram <= writecounter_sram_next;
end

/*
    act address control
*/
reg [15:0] sram_act_addr0_next;
reg [15:0] sram_act_addr1_next;

always@(*)begin
    case (state)
        idle: begin
            sram_act_addr0_next = 0;
            sram_act_addr1_next = 0;
        end
        load_addr: begin
            case(state1)
                0 : begin
                    sram_act_addr0_next = 0;
                    sram_act_addr1_next = 1;
                end
                1 : begin
                    sram_act_addr0_next = 256;
                    sram_act_addr1_next = 257;
                end
                2 : begin
                    sram_act_addr0_next = 592;
                    sram_act_addr1_next = 593;
                end
                3 : begin
                    sram_act_addr0_next = 692;
                    sram_act_addr1_next = 693;
                end
                4 : begin
                    sram_act_addr0_next = 722;
                    sram_act_addr1_next = 723;
                end
                default: begin
                    sram_act_addr0_next = 0;
                    sram_act_addr1_next = 0;
                end
            endcase
        end
        compute: begin
            case(state1)
                0 : begin
                    if(coumput_cnt == 3) begin
                        sram_act_addr0_next = 0 + colcounter + (rowcounter << 4);
                        sram_act_addr1_next = 1 + colcounter + (rowcounter << 4);
                    end
                    else begin
                        sram_act_addr0_next = sram_act_addr0 + 8; 
                        sram_act_addr1_next = sram_act_addr1 + 8;
                    end
                end
                1 : begin
                    if(localcounter == 5) begin
                        sram_act_addr0_next = 256 + colcounter + (rowcounter << 3) + intputchannelcounter * 56;
                        sram_act_addr1_next = 257 + colcounter + (rowcounter << 3) + intputchannelcounter * 56;
                    end
                    else begin
                        sram_act_addr0_next = sram_act_addr0 + 4; 
                        sram_act_addr1_next = sram_act_addr1 + 4;
                    end
                end
                2 : begin
                        if(coumput_cnt == 48) begin
                            sram_act_addr0_next = 592 ;
                            sram_act_addr1_next = 593 ;
                        end
                        else begin
                            sram_act_addr0_next = sram_act_addr0 + 2; 
                            sram_act_addr1_next = sram_act_addr1 + 2;
                        end
                end
                3 : begin
                        if(coumput_cnt == 13) begin
                            sram_act_addr0_next = 692 ;
                            sram_act_addr1_next = 693 ;
                        end
                        else begin
                            sram_act_addr0_next = sram_act_addr0 + 2; 
                            sram_act_addr1_next = sram_act_addr1 + 2;
                        end
                end
                4 : begin
                        sram_act_addr0_next = sram_act_addr0 + 2; 
                        sram_act_addr1_next = sram_act_addr1 + 2;
                end
                default: begin
                    sram_act_addr0_next = 0;
                    sram_act_addr1_next = 0;
                end
            endcase
        end
        wr_in_reg2 : begin          
            sram_act_addr0_next = 256 + writecounter_sram; 
            sram_act_addr1_next = 257 + writecounter_sram;
        end
        reload_addr : begin
            case(state1)
            0 : begin 
                sram_act_addr0_next = 0 + colcounter + (rowcounter << 4);
                sram_act_addr1_next = 1 + colcounter + (rowcounter << 4);
            end 
            1 : begin
                sram_act_addr0_next = 256 + colcounter + (rowcounter << 3) + intputchannelcounter * 56;
                sram_act_addr1_next = 257 + colcounter + (rowcounter << 3) + intputchannelcounter * 56;
            end
            2 : begin
                sram_act_addr0_next = 592;
                sram_act_addr1_next = 593;
            end
            3 : begin
                sram_act_addr0_next = 692;
                sram_act_addr1_next = 693;
            end
            4 : begin
                sram_act_addr0_next = 722;
                sram_act_addr1_next = 723;
            end
            default: begin
                sram_act_addr0_next = 0;
                sram_act_addr1_next = 0;
            end
            endcase
        end
        default: begin
            case(state1)
                0 : begin
                    sram_act_addr0_next = sram_act_addr0 + 8; 
                    sram_act_addr1_next = sram_act_addr1 + 8;
                end
                1 : begin
                    sram_act_addr0_next = sram_act_addr0 + 4; 
                    sram_act_addr1_next = sram_act_addr1 + 4;
                end
                2,3,4 : begin
                    sram_act_addr0_next = sram_act_addr0 + 2; 
                    sram_act_addr1_next = sram_act_addr1 + 2;
                end
                default: begin
                    sram_act_addr0_next = 0; 
                    sram_act_addr1_next = 0;
                end
            endcase
        end
    endcase
end

always@(posedge clk)begin
    if(!rst_n) begin
        sram_act_addr0 <= 0 ;
        sram_act_addr1 <= 0 ;
    end
    else begin
        sram_act_addr0 <= sram_act_addr0_next;
        sram_act_addr1 <= sram_act_addr1_next;
    end
end

/*
    weight address control
*/

reg [15:0] sram_weight_addr0_next;
reg [15:0] sram_weight_addr1_next;

always@(*)begin
    case (state)
        idle: begin
            sram_weight_addr0_next = 0;
            sram_weight_addr1_next = 0;
        end
        load_addr: begin
            case(state1)
            0 : begin
                sram_weight_addr0_next = 0;
                sram_weight_addr1_next = 1;
            end
            1 : begin
                sram_weight_addr0_next = 60;
                sram_weight_addr1_next = 61;
            end
            2 : begin
                sram_weight_addr0_next = 1020;
                sram_weight_addr1_next = 1021;
            end
            3 : begin
                sram_weight_addr0_next = 13020;
                sram_weight_addr1_next = 13021;
            end
            4 : begin
                sram_weight_addr0_next = 15540;
                sram_weight_addr1_next = 15541;
            end
            default: begin
                sram_weight_addr0_next = 0;
                sram_weight_addr1_next = 0;
            end
            endcase
        end
        compute: begin
            case(state1) 
                0 : begin
                    if(coumput_cnt == 3) begin
                        sram_weight_addr0_next = 0 + 10 * outputchannelcounter;
                        sram_weight_addr1_next = 1 + 10 * outputchannelcounter;
                    end
                    else begin
                        sram_weight_addr0_next = sram_weight_addr0 + 2; 
                        sram_weight_addr1_next = sram_weight_addr1 + 2;
                    end
                end
                1 : begin
                    if(coumput_cnt == 33) begin
                        sram_weight_addr0_next = 60 + 60 * outputchannelcounter;
                        sram_weight_addr1_next = 61 + 60 * outputchannelcounter;
                    end
                    else if (localcounter == 4) begin
                        sram_weight_addr0_next = sram_weight_addr0;
                        sram_weight_addr1_next = sram_weight_addr1;
                    end
                    else begin
                        sram_weight_addr0_next = sram_weight_addr0 + 2; 
                        sram_weight_addr1_next = sram_weight_addr1 + 2;
                    end
                end
                2 : begin
                    if(coumput_cnt == 48) begin
                        sram_weight_addr0_next = sram_weight_addr0 ; 
                        sram_weight_addr1_next = sram_weight_addr1 ;
                    end
                    else begin
                        sram_weight_addr0_next = sram_weight_addr0 + 2; 
                        sram_weight_addr1_next = sram_weight_addr1 + 2;
                    end
                end
                3 : begin
                    if(coumput_cnt == 13) begin
                        sram_weight_addr0_next = sram_weight_addr0 ; 
                        sram_weight_addr1_next = sram_weight_addr1 ;
                    end
                    else begin
                        sram_weight_addr0_next = sram_weight_addr0 + 2; 
                        sram_weight_addr1_next = sram_weight_addr1 + 2;
                    end
                end
                4 : begin
                    if(coumput_cnt == 9) begin
                        sram_weight_addr0_next = 15750 + outputchannelcounter; 
                        sram_weight_addr1_next = sram_weight_addr1 ;
                    end
                    else begin
                        sram_weight_addr0_next = sram_weight_addr0 + 2; 
                        sram_weight_addr1_next = sram_weight_addr1 + 2;
                    end
                end
                default: begin
                    sram_weight_addr0_next = 0;
                    sram_weight_addr1_next = 0;
                end
            endcase
        end
        reload_addr : begin
            case(state1)
                    0 : begin 
                        sram_weight_addr0_next = 0 + 10 * outputchannelcounter;
                        sram_weight_addr1_next = 1 + 10 * outputchannelcounter;
                    end
                    1 : begin
                        sram_weight_addr0_next = 60 + 60 * outputchannelcounter;
                        sram_weight_addr1_next = 61 + 60 * outputchannelcounter;
                    end
                    2,3 : begin
                        sram_weight_addr0_next = sram_weight_addr0 - 6;
                        sram_weight_addr1_next = sram_weight_addr1 - 6;
                    end
                    4 : begin
                        sram_weight_addr0_next = 15540 + outputchannelcounter * 21;
                        sram_weight_addr1_next = 15541 + outputchannelcounter * 21;
                    end
                    default: begin
                        sram_weight_addr0_next = 0;
                        sram_weight_addr1_next = 0;
                    end
                endcase
        end
        default: begin
            sram_weight_addr0_next = sram_weight_addr0 + 2; 
            sram_weight_addr1_next = sram_weight_addr1 + 2;
        end
    endcase

end
always@(posedge clk)begin
    if(!rst_n) begin
        sram_weight_addr0 <= 0 ;
        sram_weight_addr1 <= 0 ;
    end
    else begin
        sram_weight_addr0 <= sram_weight_addr0_next;
        sram_weight_addr1 <= sram_weight_addr1_next;
    end
end

/*

        ******************
           weigth buffer
        ******************

*/

always@(posedge clk)begin
        weight_buffer1[0] <= sram_weight_rdata0_d[0];
        weight_buffer1[1] <= sram_weight_rdata0_d[1];
        weight_buffer1[2] <= sram_weight_rdata0_d[2];
        weight_buffer1[3] <= sram_weight_rdata0_d[3];
        weight_buffer1[4] <= sram_weight_rdata1_d[0];
end

maxpool maxpool0(
    .clk(clk),
    .rst_n(rst_n),
    .in_data0(psum_o0[0]),
    .in_data1(psum_o0[1]),
    .in_data2(psum[4]),
    .in_data3(psum[5]),
    .out_data(out_max[0])
);

maxpool maxpool1(
    .clk(clk),
    .rst_n(rst_n),
    .in_data0(psum_o0[2]),
    .in_data1(psum_o0[3]),
    .in_data2(psum[6]),
    .in_data3(psum[7]),
    .out_data(out_max[1])
);

/*
    act mux after conv1
*/

assign psum_to_actq = (state1 > 1) ? psum[0]+psum[3] : out_max[0];

actq actq0(
    .M(scale[24:0]),
    .in_data(psum_to_actq),
    .out_data(out_actq[0])
);

actq actq1(
    .M(scale[24:0]),
    .in_data(out_max[1]),
    .out_data(out_actq[1])
);

/*
    pe mux after conv2
*/

assign in[0] = (state1 > 1 ) ? 0 : sram_act_rdata0_d[3];
assign in[1] = (state1 > 1 ) ? 0 : sram_act_rdata1_d[0];
assign in[2] = (state1 == 4 && coumput_cnt == 10) ? 0 : sram_act_rdata1_d[1];
assign in[3] = (state1 == 4 && coumput_cnt == 10) ? 0 : sram_act_rdata1_d[2];
assign in[4] = (state1 == 4 && coumput_cnt == 10) ? 0 : sram_act_rdata1_d[3];

assign we[0] = (state1 > 1 ) ? sram_weight_rdata1_d[1] : sram_weight_rdata0_d[2];
assign we[1] = (state1 > 1 ) ? sram_weight_rdata1_d[2] : sram_weight_rdata0_d[3];
assign we[2] = (state1 > 1 ) ? sram_weight_rdata1_d[3] : sram_weight_rdata1_d[0];
assign we[3] = (state1 == 4 && coumput_cnt == 10) ? 0 : sram_act_rdata1_d[0];

/*
    psum buffer
*/
always@(posedge clk)begin
    psum_o0[0] <= psum[0];
    psum_o0[1] <= psum[1];
    psum_o0[2] <= psum[2];
    psum_o0[3] <= psum[3];
end



pe pe00(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(sram_act_rdata0_d[0]),
    .in_data1(sram_act_rdata0_d[1]),
    .in_data2(sram_act_rdata0_d[2]),
    .in_data3(sram_act_rdata0_d[3]),
    .in_data4(we[3]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(sram_weight_rdata0_d[2]),
    .weight_data3(sram_weight_rdata0_d[3]),
    .weight_data4(sram_weight_rdata1_d[0]),
    .out_data(psum[0])
);
pe pe01(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(sram_act_rdata0_d[1]),
    .in_data1(sram_act_rdata0_d[2]),
    .in_data2(sram_act_rdata0_d[3]),
    .in_data3(sram_act_rdata1_d[0]),
    .in_data4(sram_act_rdata1_d[1]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(sram_weight_rdata0_d[2]),
    .weight_data3(sram_weight_rdata0_d[3]),
    .weight_data4(sram_weight_rdata1_d[0]),
    .out_data(psum[1])
);
pe pe02(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(sram_act_rdata0_d[2]),
    .in_data1(sram_act_rdata0_d[3]),
    .in_data2(sram_act_rdata1_d[0]),
    .in_data3(sram_act_rdata1_d[1]),
    .in_data4(sram_act_rdata1_d[2]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(sram_weight_rdata0_d[2]),
    .weight_data3(sram_weight_rdata0_d[3]),
    .weight_data4(sram_weight_rdata1_d[0]),
    .out_data(psum[2])
);
pe pe03(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(in[0]),
    .in_data1(in[1]),
    .in_data2(in[2]),
    .in_data3(in[3]),
    .in_data4(in[4]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(we[0]),
    .weight_data3(we[1]),
    .weight_data4(we[2]),
    .out_data(psum[3])
);

pe pe10(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom2),
    .done(done1),
    .in_data0(sram_act_rdata0_d[0]),
    .in_data1(sram_act_rdata0_d[1]),
    .in_data2(sram_act_rdata0_d[2]),
    .in_data3(sram_act_rdata0_d[3]),
    .in_data4(sram_act_rdata1_d[0]),
    .weight_data0(weight_buffer1[0]),
    .weight_data1(weight_buffer1[1]),
    .weight_data2(weight_buffer1[2]),
    .weight_data3(weight_buffer1[3]),
    .weight_data4(weight_buffer1[4]),
    .out_data(psum[4])
);
pe pe11(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom2),
    .done(done1),
    .in_data0(sram_act_rdata0_d[1]),
    .in_data1(sram_act_rdata0_d[2]),
    .in_data2(sram_act_rdata0_d[3]),
    .in_data3(sram_act_rdata1_d[0]),
    .in_data4(sram_act_rdata1_d[1]),
    .weight_data0(weight_buffer1[0]),
    .weight_data1(weight_buffer1[1]),
    .weight_data2(weight_buffer1[2]),
    .weight_data3(weight_buffer1[3]),
    .weight_data4(weight_buffer1[4]),
    .out_data(psum[5])
);
pe pe12(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom2),
    .done(done1),
    .in_data0(sram_act_rdata0_d[2]),
    .in_data1(sram_act_rdata0_d[3]),
    .in_data2(sram_act_rdata1_d[0]),
    .in_data3(sram_act_rdata1_d[1]),
    .in_data4(sram_act_rdata1_d[2]),
    .weight_data0(weight_buffer1[0]),
    .weight_data1(weight_buffer1[1]),
    .weight_data2(weight_buffer1[2]),
    .weight_data3(weight_buffer1[3]),
    .weight_data4(weight_buffer1[4]),
    .out_data(psum[6])
);
pe pe13(
    .clk(clk),
    .rst_n(rst_n),
    .compute_start(startcom2),
    .done(done1),
    .in_data0(sram_act_rdata0_d[3]),
    .in_data1(sram_act_rdata1_d[0]),
    .in_data2(sram_act_rdata1_d[1]),
    .in_data3(sram_act_rdata1_d[2]),
    .in_data4(sram_act_rdata1_d[3]),
    .weight_data0(weight_buffer1[0]),
    .weight_data1(weight_buffer1[1]),
    .weight_data2(weight_buffer1[2]),
    .weight_data3(weight_buffer1[3]),
    .weight_data4(weight_buffer1[4]),
    .out_data(psum[7])
);

endmodule


module pe (
    input clk,
    input rst_n,
    input compute_start,
    input done,
    input signed [7:0] in_data0,
    input signed [7:0] in_data1,
    input signed [7:0] in_data2,
    input signed [7:0] in_data3,
    input signed [7:0] in_data4,

    input signed [7:0] weight_data0,
    input signed [7:0] weight_data1,
    input signed [7:0] weight_data2,
    input signed [7:0] weight_data3,
    input signed [7:0] weight_data4,


    output reg signed [24:0] out_data
);
    integer i;
    reg signed [15:0] product [4:0];
    wire signed [15:0] product_next [4:0];

    assign product_next[0] = (compute_start) ? in_data0 * weight_data0  : 0;
    assign product_next[1] = (compute_start) ? in_data1 * weight_data1  : 0;
    assign product_next[2] = (compute_start) ? in_data2 * weight_data2  : 0;
    assign product_next[3] = (compute_start) ? in_data3 * weight_data3  : 0;
    assign product_next[4] = (compute_start) ? in_data4 * weight_data4  : 0;
    
    always@(posedge clk)begin
        for(i = 0; i < 5; i = i + 1)begin
            product[i] <= product_next[i];
        end
    end

    wire signed [24:0] out_data_next;

    assign out_data_next = (done) ? 0 : ((((product[0] + product[1]) + (product[2] + product[3])) + product[4]) + out_data);

    always@(posedge clk)begin
        if(!rst_n) out_data <= 0;
        else out_data <= out_data_next;
    end

endmodule

module maxpool (
    input clk,
    input rst_n,
    input signed [24:0] in_data0,
    input signed [24:0] in_data1,
    input signed [24:0] in_data2,
    input signed [24:0] in_data3,

    output reg signed [24:0] out_data
);

    wire signed [24:0] temp0,temp1,temp2;
    assign temp0 = (in_data0 > in_data1) ? in_data0 : in_data1;
    assign temp1 = (in_data2 > in_data3) ? in_data2 : in_data3;
    assign temp2 = (temp0 > temp1) ? temp0 : temp1;
    always @(posedge clk) begin
        if(!rst_n) out_data <= 0;
        else out_data <= temp2;
    end
endmodule

module actq (
    input signed [24:0] M,
    input signed [24:0] in_data,
    output wire signed [7:0] out_data
);
    wire signed [7:0] data;
    wire signed [24:0] temp;
    assign temp =  (M * in_data) >>> 16;
    assign data =  (temp > 127) ? 127 : (temp < -128) ? -128 : temp;
    assign out_data = (in_data > 0) ? data : 0;
endmodule