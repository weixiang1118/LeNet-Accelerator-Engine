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

always@(posedge clk)
begin
        //input
         rst_n_d <= rst_n;
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
        //output
        /*compute_finish <= compute_finish_d;
        sram_act_wea0 <= sram_act_wea0_d;
        sram_act_wea1 <= sram_act_wea1_d;
        sram_weight_wea0 <= sram_weight_wea0_d;
        sram_weight_wea1 <= sram_weight_wea1_d;

        sram_act_addr0 <= sram_act_addr0_d;
        sram_act_addr1 <= sram_act_addr1_d;
        sram_weight_addr0 <= sram_weight_addr0_d;
        sram_weight_addr1 <= sram_weight_addr1_d;

        sram_act_wdata0 <= sram_act_wdata0_d;
        sram_act_wdata1 <= sram_act_wdata1_d;
        sram_weight_wdata0 <= sram_weight_wdata0_d;
        sram_weight_wdata1 <= sram_weight_wdata1_d;*/

end

always@(posedge clk)begin
    if(!rst_n)begin
        compute_finish <= 0;
        sram_act_wea0 <= 0;
        sram_act_wea1 <= 0;
        sram_weight_wea0 <= 0;
        sram_weight_wea1 <= 0;

        sram_act_addr0 <= 0;
        sram_act_addr1 <= 0;
        sram_weight_addr0 <= 0;
        sram_weight_addr1 <= 0;

        sram_act_wdata0 <= 0;
        sram_act_wdata1 <= 0;
        sram_weight_wdata0 <= 0;
        sram_weight_wdata1 <= 0;
    end
    else begin
        compute_finish <= compute_finish_d;
        sram_act_wea0 <= sram_act_wea0_d;
        sram_act_wea1 <= sram_act_wea1_d;
        sram_weight_wea0 <= sram_weight_wea0_d;
        sram_weight_wea1 <= sram_weight_wea1_d;

        sram_act_addr0 <= sram_act_addr0_d;
        sram_act_addr1 <= sram_act_addr1_d;
        sram_weight_addr0 <= sram_weight_addr0_d;
        sram_weight_addr1 <= sram_weight_addr1_d;

        sram_act_wdata0 <= sram_act_wdata0_d;
        sram_act_wdata1 <= sram_act_wdata1_d;
        sram_weight_wdata0 <= sram_weight_wdata0_d;
        sram_weight_wdata1 <= sram_weight_wdata1_d;
    end
end
 
/*
    sram weight doesn't need to write data

*/
always@(posedge clk)begin
    sram_weight_wea0_d <= 4'b0;
    sram_weight_wea1_d <= 4'b0;
    sram_weight_wdata0_d <= 0;
    sram_weight_wdata1_d <= 0;
end


/*

    conv1 fsm

*/


parameter idle = 6'd0;
parameter waitidle = 6'd1;
parameter conv1 = 6'd2;
parameter addrwait = 6'd3;
parameter counterwait = 6'd4;
parameter maxpools = 6'd5;
parameter actqs = 6'd6;
parameter wait1 = 6'd7;
parameter wait2 = 6'd8;
parameter wait3 = 6'd9;
parameter wait4 = 6'd10;
parameter conv2 = 6'd11;
parameter wait5 = 6'd12;
parameter wait6 = 6'd13;
parameter wait7 = 6'd14;
parameter wait8 = 6'd15;
parameter wait9 = 6'd16;
parameter w10 = 6'd17;
parameter w11 = 6'd18;
parameter w12 = 6'd19;
parameter w13 = 6'd20;
parameter w14 = 6'd21;
parameter w15 = 6'd22;
parameter addrwait1 = 6'd23;
parameter counterwait1 = 6'd24;
parameter maxpools1 = 6'd25;
parameter actqs1 = 6'd26;
parameter w16 = 6'd27;
parameter w17 = 6'd28;
parameter w18 = 6'd29;
parameter w19 = 6'd30;
parameter w20 = 6'd31;
parameter w21 = 6'd32;
parameter w22 = 6'd33;
parameter w23 = 6'd34;
parameter w24 = 6'd35;
parameter w25 = 6'd36;
parameter w26 = 6'd37;
parameter w27 = 6'd38;
parameter w28 = 6'd39;
parameter w29 = 6'd40;
parameter w30 = 6'd41;
parameter w35 = 6'd42;
parameter finfish = 6'd60;

reg [5:0] next_state, state;
reg [2:0] next_state1, state1;

reg [2:0] localcounter;
reg [4:0] outputchannelcounter;
reg [2:0] intputchannelcounter;
reg [2:0] colcounter;
reg [3:0] rowcounter;
reg [8:0] writeecounter;
reg [1:0] counter;

reg startcom1;
reg startcom2;
reg done0;
reg done1;
reg wrflag;


wire  signed [24:0] psum [7:0];
reg   signed [24:0] psum_o0 [3:0];
wire  signed [24:0] psum_o1 [3:0];
wire signed [24:0] out_max [1:0];
wire signed [7:0] out_actq [1:0];
reg  signed [31:0] scale;
wire signed [7:0] in [5:0];
wire signed [7:0] we [5:0];
wire signed [24:0] temp1;
wire signed [24:0] temp2;
reg  signed [24:0] temp3;
reg signed [7:0] outbuffer [2:0];

always @(posedge clk or negedge rst_n_d) begin
    if(!rst_n_d)begin
        scale <= 0;
    end
    /*else if (state1 == 0) begin
        scale <= scale_CONV1_d;
    end
    else if (state1 == 1) begin
        scale <= scale_CONV2_d;
    end
    else if (state1 == 2) begin
        scale <= scale_CONV3_d;
    end
    else if (state1 == 3) begin
        scale <= scale_FC1_d;
    end
    else  begin
        scle <= scale;
    end*/
    else begin
        case (state1)
            0: scale <= scale_CONV1_d;
            1: scale <= scale_CONV2_d;
            2: scale <= scale_CONV3_d;
            3: scale <= scale_FC1_d;
            default: scale <= scale;
        endcase
    end
end
always@(posedge clk or negedge rst_n_d)begin
    if(!rst_n_d)begin
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
            if(state == 17) next_state1 = 1;
            else next_state1 = 0;
        end
        1 : begin
            if(outputchannelcounter == 16 && state ==26) next_state1 = 2;
            else next_state1 = 1;
        end
        2: begin
            if (state == 36 && sram_weight_addr0_d == 13018) next_state1 = 3;
            else next_state1 = 2;
        end
        3: begin
            if (state == 36 && sram_weight_addr0_d == 15538) next_state1 = 4;
            else next_state1 = 3;
        end
        4: begin
             next_state1 = 4;
        end
        default: next_state1 = 0;
    endcase
end
always@(posedge clk or negedge rst_n_d)begin
    if(!rst_n_d)
        state <= idle;
    else 
        state <= next_state;
end

always@(*)begin
    next_state = idle;
    case(state)
        idle : begin
            if(compute_start_d) next_state = w35;
            else next_state = idle;
        end
        w35 : next_state = waitidle;
        waitidle: next_state = conv1;
        conv1: begin
            next_state = addrwait;
        end
        addrwait: begin
            if(localcounter ==4) next_state = counterwait;
            else next_state = addrwait;
        end
        counterwait: begin
            next_state = maxpools;
        end
        maxpools: begin
            next_state = actqs;
        end
        actqs: begin
            if(outputchannelcounter == 6) next_state = w10; 
            else next_state = wait1;
        end
        wait1: next_state = wait2;
        wait2: next_state = wait3;
        wait3: next_state = wait4;
        wait4: next_state = addrwait;
        conv2 : next_state = wait5;
        wait5: next_state = wait6;
        wait6: next_state = wait7;
        wait7: next_state = wait8;
        wait8: next_state = wait9;
        wait9: begin
            if(intputchannelcounter == 5) next_state = addrwait1;
            else next_state = conv2;
        end
        w10 : next_state = w11;
        w11 : next_state = w12;
        w12 : next_state = w13;
        w13 : next_state = w14;
        w14 : next_state = conv2;  
        w15 : next_state = finfish;
        addrwait1: begin
            if(localcounter ==3) next_state = counterwait1;
            else next_state = addrwait1;
        end
        counterwait1: begin
            next_state = maxpools1;
        end
        maxpools1: begin
            next_state = actqs1;
        end
        actqs1: begin
           if(outputchannelcounter == 16) next_state = w16;
           else next_state = w10;
        end
        finfish: next_state = idle;
        w16 : next_state = w17;
        w17 : next_state = w18;
        w18 : next_state = w19;
        w19 : begin
            if (sram_act_addr0_d == 688 || sram_act_addr0_d == 718 || sram_act_addr0_d == 740 ) next_state = w20;
            else next_state = w19;
        end
        w20 : next_state = w21;
        w21 : begin
             next_state = w22;
        end
        w22 : next_state = w23;
        w23 : next_state = w24;
        w24 : begin
            if (state1 == 4) next_state = w27;
            else next_state = w25;
        end
        w25 : next_state = w26;
        w26 :begin
            /*if (sram_act_addr0_d == 742) next_state = w15;
            else*/ if (rowcounter == 3) next_state = w16;
            else next_state = w19; 
        end
        w27 : begin 
            if (sram_act_addr0_d == 753) next_state = w15;
            else next_state = w16;
        end
        default: next_state = idle;
    endcase
end

always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        compute_finish_d <= 0;
    end
    else if(state == finfish)begin
        compute_finish_d <= 1;
    end
    else begin
        compute_finish_d <= 0;
    end
end
integer i;
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        startcom1 <= 1;
    end
    /*else begin
        case(state)
            waitidle: startcom1 <= 0;
            wait7: startcom1 <= 0;
            wait6: startcom1 <= 1;
            default: startcom1 <= startcom1;
        endcase
    end*/
    else if(state == waitidle || state == wait7)begin
        startcom1 <= 0;
    end
    else if (state == wait6) begin
        startcom1 <= 1;
    end
    else begin
        startcom1 <= startcom1;
    end
end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        startcom2 <= 1;
    end
    else if(startcom1)begin
        startcom2 <= 1;
    end
    else begin
        startcom2 <= 0;
    end
end



always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        localcounter <= 0;
    end
    /*else begin
        case (state)
            addrwait: begin
                localcounter <= localcounter + 1;
            end
            addrwait1: begin
                localcounter <= localcounter + 1;
            end
            default: localcounter <= 0;
        endcase
    end*/
    else if(state == addrwait || state == addrwait1 )begin
        localcounter <= localcounter + 1;
    end
    else begin
        localcounter <= 0;
    end
end

always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        done0 <= 0;
    end
    else if (state == 36 || state == 37 )begin
        if (rowcounter == 3)begin
            done0 <= 1;
        end
        else begin
            done0 <= 0;
        end
    end
    else if (state == 35 )begin
        done0 <= 1;
    end
    else if (state  == 23 && localcounter == 3) begin
        done0 <= 1;
    end
    else if(localcounter == 4 )begin
        done0 <= 1;
    end
    else if (state == wait3 || state == w12 || state == w18)
        done0 <= 0;
    else begin
        done0 <= done0;
    end
end

always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        done1 <= 0;
    end
    else if(done0)begin
        done1 <= 1;
    end
    else begin
        done1 <= 0;
    end
end

/*

        ******************
        deal with weight
        3.weigth buffer
        ******************

*/
reg  signed [7:0] weight_buffer1 [4:0];
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        for(i = 0; i < 5; i = i + 1)begin
            weight_buffer1[i] <= 0;
        end
    end
    else if(state <2)begin
        for(i = 0; i < 5; i = i + 1)begin
            weight_buffer1[i] <= 0;
        end
    end
    else if (state == w35)begin
        for(i = 0; i < 5; i = i + 1)begin
            weight_buffer1[i] <= 0;
        end
    end
    else begin
        weight_buffer1[0] <= sram_weight_rdata0_d[0];
        weight_buffer1[1] <= sram_weight_rdata0_d[1];
        weight_buffer1[2] <= sram_weight_rdata0_d[2];
        weight_buffer1[3] <= sram_weight_rdata0_d[3];
        weight_buffer1[4] <= sram_weight_rdata1_d[0];
    end
end 
/*

    weight address control

*/

always@(posedge clk or negedge rst_n_d)begin
    if(!rst_n_d)begin
        sram_weight_addr0_d <= 0;
        sram_weight_addr1_d <= 1;
    end
    else if (state == idle) begin
        if (compute_start_d)begin
            sram_weight_addr0_d <= sram_act_addr0_d + 2;
            sram_weight_addr1_d <= sram_act_addr1_d + 2;
        end
        else begin
            sram_weight_addr0_d <= 0;
            sram_weight_addr1_d <= 1;
        end
    end
    else if(state==actqs)begin
        if(sram_act_addr0_d == 591)begin
            sram_weight_addr0_d <= 60;
            sram_weight_addr1_d <= 61;
        end
        else begin
            sram_weight_addr0_d <= 0 + outputchannelcounter*10;
            sram_weight_addr1_d <= 1 + outputchannelcounter*10;
        end
    end
    else if(state==actqs1)begin
        if(sram_act_addr0_d == 691 && outputchannelcounter == 16)begin
            sram_weight_addr0_d <= 1020;
            sram_weight_addr1_d <= 1021;
        end
        else begin
            sram_weight_addr0_d <= 60 + outputchannelcounter*60;
            sram_weight_addr1_d <= 61 + outputchannelcounter*60;
        end
    end
    else if (state == 30)begin
        if(state1 == 4 && sram_act_addr0_d == 740)begin
            sram_weight_addr0_d <=sram_weight_addr0_d+2;
            sram_weight_addr1_d <= 15750 + outputchannelcounter;
        end
        else begin
            sram_weight_addr0_d <= sram_weight_addr0_d+2;
            sram_weight_addr1_d <= sram_weight_addr1_d+2;
        end
    end
    else if (state == 38)begin
        sram_weight_addr0_d <= sram_weight_addr0_d + 1;
        sram_weight_addr1_d <= sram_weight_addr0_d + 2;
    end
    else if ((state==36 || state==35 || state==34 || state == 33) && (rowcounter == 3 || state1 == 4))begin
        sram_weight_addr0_d <= sram_weight_addr0_d;
        sram_weight_addr1_d <= sram_weight_addr1_d;
    end
    else if (state == w14 || state == addrwait || state == wait9  || state == addrwait1 || state == 31 || state == 32 ) begin
        sram_weight_addr0_d <= sram_weight_addr0_d;
        sram_weight_addr1_d <= sram_weight_addr1_d;
    end
    else begin
        sram_weight_addr0_d <= sram_weight_addr0_d+2;
        sram_weight_addr1_d <= sram_weight_addr1_d+2;
    end
end

/*

        ******************
        deal with input data
        1. data address control
        ******************

*/
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d) intputchannelcounter <= 0;
    else if(state == addrwait1) intputchannelcounter <= 0;
    /*else begin
        case(state)
            w14: intputchannelcounter <= intputchannelcounter + 1 ;
            wait9: intputchannelcounter <= intputchannelcounter + 1 ;
            default: intputchannelcounter <= intputchannelcounter;
        endcase
    end*/
    else if(state == w14 || state == wait9)begin
        intputchannelcounter <= intputchannelcounter + 1;
    end
    else begin
        intputchannelcounter <= intputchannelcounter;
    end

end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        outputchannelcounter <= 0;
    end
    else if (state1 == 4 && state == 31)begin
           outputchannelcounter <= outputchannelcounter + 1;
    end
    else if (state == 6 && outputchannelcounter == 6) outputchannelcounter <= 0;
    else if (state == 26 && outputchannelcounter == 16) outputchannelcounter <= 0;
    else if(colcounter == 6 && state == 4 && rowcounter == 13)begin
        outputchannelcounter <= outputchannelcounter + 1;
    end
    else if(colcounter == 2 && state == 24 && rowcounter == 4)begin
        outputchannelcounter <= outputchannelcounter + 1;
    end
    else begin
        outputchannelcounter <= outputchannelcounter;
    end
end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        rowcounter <= 0;
    end
    else if (state1 == 4) rowcounter <= 0;
    else if (state == 37) begin
        if(rowcounter == 3) rowcounter <= 0;
        else rowcounter <= rowcounter + 1;
    end
    else if(colcounter == 6 && state == 4)begin
        if(rowcounter ==13) rowcounter <= 0;
        else rowcounter <= rowcounter + 1;
    end
    else if(colcounter == 2 && state == 24)begin
        if(rowcounter ==4) rowcounter <= 0;
        else rowcounter <= rowcounter + 1;
    end
    else 
        rowcounter <= rowcounter;
end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        counter <= 0;
    end
    /*else if (state1 == 4 && state == 31)begin
           counter <= counter + 1;
    end*/
    else if(colcounter == 0 && state == 26)begin
           counter <= counter + 1;
    end
    else begin
        counter <= counter;
    end
end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        colcounter <= 0;
    end
    else if(state == 4)begin
        if(colcounter == 6) colcounter <= 0;
        else colcounter <= colcounter + 1;
    end
    else if (state == 24) begin
        if(colcounter == 2) colcounter <= 0;
        else colcounter <= colcounter + 1;
    end
    else begin
        colcounter <= colcounter;
    end

end
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        writeecounter <= 0;
    end
    else if (( wrflag  || colcounter == 0) && state == maxpools ) begin
        writeecounter <= writeecounter + 1;
    end
    else if ( rowcounter == 3&& state == 37 ) begin
        writeecounter <= writeecounter + 1;
    end
    else if (state  == maxpools1)begin
        case (counter)
            0:begin
                 if(colcounter == 2) writeecounter <= writeecounter + 1;
                 else writeecounter <= writeecounter;
            end
            1: begin
                 if(colcounter == 2) writeecounter <= writeecounter + 1;
                 else writeecounter <= writeecounter;
            end
            2: begin
                 if(colcounter == 1) writeecounter <= writeecounter + 1;
                 else writeecounter <= writeecounter;
            end
            3: begin
                 if(colcounter == 1 || colcounter == 0) writeecounter <= writeecounter + 1;
                 else writeecounter <= writeecounter;
            end
            default: writeecounter <= writeecounter;
        endcase
    end
    else if (state == 38) begin
        writeecounter <= writeecounter + 1;
    end
    else begin
        writeecounter <= writeecounter;
    end
end
always@(posedge clk or negedge rst_n_d)begin
    if(!rst_n_d)begin
        sram_act_addr0_d <= 0;
        sram_act_addr1_d <= 1;
    end
    else if (state == idle)begin
        if(compute_start_d)begin
            sram_act_addr0_d <= sram_act_addr0_d + 2;
            sram_act_addr1_d <= sram_act_addr1_d + 2;
        end
        else begin
            sram_act_addr0_d <= 0;
            sram_act_addr1_d <= 1;
        end
    end
    else if(state == maxpools )begin
        sram_act_addr0_d <= 256 + writeecounter;
        sram_act_addr1_d <= 0;
    end
    else if(state == 35 && state1 == 4)begin
        sram_act_addr0_d <= 256 + writeecounter;
        sram_act_addr1_d <= 0;
    end
    else if(rowcounter == 3 && state == 36)begin
        sram_act_addr0_d <= 256 + writeecounter;
        sram_act_addr1_d <= 0;
    end
    else if(state == maxpools1)begin
        sram_act_addr0_d <= 256 + writeecounter;
        //sram_act_addr1_d <= sram_act_addr1_d;
        case (counter)
            1: begin
                 if(colcounter == 2) sram_act_addr1_d <= 256 + writeecounter + 1;
                 else sram_act_addr1_d <= 0;
            end
            3: begin
                 if(colcounter == 1) sram_act_addr1_d <= 256 + writeecounter + 1;
                 else sram_act_addr1_d <= 0;
            end
            default: sram_act_addr1_d <= 0;
        endcase
    end
    else if(state == actqs)begin
        if(sram_act_addr0_d == 591)begin
            sram_act_addr0_d <= 256 ;
            sram_act_addr1_d <= 257 ;
        end
        else begin
        sram_act_addr0_d <= colcounter + (rowcounter<<4);
        sram_act_addr1_d <= colcounter + (rowcounter<<4) +1;
        end
    end
     else if(state == actqs1)begin
        if(sram_act_addr0_d == 691 && outputchannelcounter == 16)begin
            sram_act_addr0_d <= 592;
            sram_act_addr1_d <= 593;
        end
        else begin
        sram_act_addr0_d <= 256 + colcounter + (rowcounter<<3);
        sram_act_addr1_d <= 257 + colcounter + (rowcounter<<3);
        end
    end
    else if(state == conv2)begin
        sram_act_addr0_d <= 256 + colcounter + (rowcounter<<3) + intputchannelcounter*56;
        sram_act_addr1_d <= 257 + colcounter + (rowcounter<<3) + intputchannelcounter*56;
    end
     else if (state == 37) begin
        if(rowcounter == 3)begin
            if (state1  == 2)begin
                sram_act_addr0_d <= 592;
                sram_act_addr1_d <= 593;
            end
            else if (state1 == 3)begin
                sram_act_addr0_d <= 692;
                sram_act_addr1_d <= 693;
            end
            else if (state1 == 4)begin
                sram_act_addr0_d <= 722;
                sram_act_addr1_d <= 723;
            end
            else begin
                sram_act_addr0_d <= sram_act_addr0_d;
                sram_act_addr1_d <= sram_act_addr1_d;
            end
        end
        else begin
            sram_act_addr0_d <= sram_act_addr0_d + 2;
            sram_act_addr1_d <= sram_act_addr1_d + 2;
        end
    end
    else if (state == 38) begin
        sram_act_addr0_d <= 722;
        sram_act_addr1_d <= 723; 
    end
    else if (state == 33) begin
        if (state1 == 2)begin
            sram_act_addr0_d <= 592;
            sram_act_addr1_d <= 593;
        end
        else if (state1 == 3)begin
            sram_act_addr0_d <= 692;
            sram_act_addr1_d <= 693;
        end
    end
    else if (state == 23 || state == 32  || state == 31)begin
        sram_act_addr0_d <= sram_act_addr0_d ;
        sram_act_addr1_d <= sram_act_addr1_d ;
    end
    else if(state == w10 || state1 == 1) begin 
        sram_act_addr0_d <= sram_act_addr0_d + 4;
        sram_act_addr1_d <= sram_act_addr1_d + 4;
    end
    else if(state1 == 0) begin 
        sram_act_addr0_d <= sram_act_addr0_d + 8;
        sram_act_addr1_d <= sram_act_addr1_d + 8;
    end
    else if (state1 > 1)begin 
        sram_act_addr0_d <= sram_act_addr0_d + 2;
        sram_act_addr1_d <= sram_act_addr1_d + 2;
    end
end

/*
    
        ******************
        systolic array 4*2 
        8 pe
        conv -> maxpool+relu -> *M +actq +memwrite
        ******************

*/

always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        for(i = 0; i < 4; i = i + 1)begin
            psum_o0[i] <= 0;
        end
    end
    else if(state == counterwait || state == counterwait1)begin
        for(i = 0; i < 4; i = i + 1)begin
            psum_o0[i] <= psum[i];
        end
    end
   else if(state == maxpools || state == maxpools1)begin
        for(i = 0; i < 4; i = i + 1)begin
            psum_o0[i] <= 0;
        end
    end
    else begin
        for(i = 0; i < 4; i = i + 1)begin
            psum_o0[i] <= psum_o0[i];
        end
    end
end

assign psum_o1[0] = psum[4] ;
assign psum_o1[1] = psum[5] ;
assign psum_o1[2] = psum[6] ;
assign psum_o1[3] = psum[7] ;

/*
    sram data write

*/

always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        wrflag <= 0;
    end
    else if(state == actqs)begin
        if(colcounter ==0) wrflag <= 0;
        else wrflag <= wrflag +1;
    end
    else begin
        wrflag <= wrflag;
    end
end

always@(*)begin
    if(!rst_n_d)begin
        sram_act_wdata0_d = 0;
        sram_act_wea0_d = 4'b0000;
        sram_act_wdata1_d = 0;
        sram_act_wea1_d = 4'b0000;
    end
    /*else begin
        case (state)
        actqs:begin
                case (wrflag)
                    0:begin
                        sram_act_wdata0_d = {16'b0 ,out_actq[1] ,out_actq[0]};
                        sram_act_wea0_d = 4'b1111;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    1:begin
                        sram_act_wdata0_d =  {out_actq[1] ,out_actq[0],16'b0};
                        sram_act_wea0_d = 4'b1100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
        end
        actqs1: begin
        case(counter)
            0:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {16'b0 ,out_actq[1] ,out_actq[0]};
                        sram_act_wea0_d = 4'b1111;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {out_actq[1] ,out_actq[0],16'b0};
                        sram_act_wea0_d = 4'b1100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {24'b0 ,out_actq[0]};
                        sram_act_wea0_d = 4'b1111;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            1:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {8'b0 ,out_actq[1] ,out_actq[0], 8'b0};
                        sram_act_wea0_d = 4'b0110;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {out_actq[0] ,24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d=  {24'b0 ,out_actq[1]};
                        sram_act_wea1_d  = 4'b1111;
                    end
                    0 : begin
                        sram_act_wdata0_d = {16'b0 ,out_actq[0],8'b0};
                        sram_act_wea0_d = 4'b0010;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            2:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {out_actq[1] ,out_actq[0], 16'b0};
                        sram_act_wea0_d = 4'b1100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {16'b0,out_actq[1] ,out_actq[0]};
                        sram_act_wea0_d = 4'b0011;
                        sram_act_wdata1_d= 0;
                        sram_act_wea1_d  = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {8'b0 ,out_actq[0],16'b0};
                        sram_act_wea0_d = 4'b0100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            3:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {out_actq[0], 24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d = {24'b0,out_actq[1]};
                        sram_act_wea1_d = 4'b1111;
                    end
                    2:begin
                        sram_act_wdata0_d =  {8'b0,out_actq[1] ,out_actq[0], 8'b0};
                        sram_act_wea0_d = 4'b0110;
                        sram_act_wdata1_d= 0;
                        sram_act_wea1_d  = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {out_actq[0],24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            default:begin
                sram_act_wdata0_d = 0;
                sram_act_wea0_d = 4'b0000;
                sram_act_wdata1_d = 0;
                sram_act_wea1_d = 4'b0000;
            end
        endcase
    end
    38 : begin
        sram_act_wdata0_d = {{7{psum[0][24]}},psum[0]} + {{7{temp3[24]}},temp3} + {sram_weight_rdata1_d[3],sram_weight_rdata1_d[2],sram_weight_rdata1_d[1],sram_weight_rdata1_d[0]};
        sram_act_wea0_d = 4'b1111;
        sram_act_wdata1_d = 0;
        sram_act_wea1_d = 4'b0000;
    end
    37 : begin
        if (rowcounter == 3) begin
            sram_act_wdata0_d = {out_actq[0],outbuffer[2],outbuffer[1],outbuffer[0]};
            sram_act_wea0_d = 4'b1111;
            sram_act_wdata1_d = 0;
            sram_act_wea1_d = 4'b0000;
        end
        else begin
            sram_act_wdata0_d = 0;
            sram_act_wea0_d = 4'b0000;
            sram_act_wdata1_d = 0;
            sram_act_wea1_d = 4'b0000;
        end
    end
    default:  begin
        sram_act_wdata0_d = 0;
        sram_act_wea0_d = 4'b0000;
        sram_act_wdata1_d = 0;
        sram_act_wea1_d = 4'b0000;
    end

    endcase
    end*/
    else if(state == actqs)begin
        case (wrflag)
            0:begin
                sram_act_wdata0_d = {16'b0 ,out_actq[1] ,out_actq[0]};
                sram_act_wea0_d = 4'b1111;
                sram_act_wdata1_d = 0;
                sram_act_wea1_d = 4'b0000;
            end
            1:begin
                sram_act_wdata0_d =  {out_actq[1] ,out_actq[0],16'b0};
                sram_act_wea0_d = 4'b1100;
                sram_act_wdata1_d = 0;
                sram_act_wea1_d = 4'b0000;
            end
            default:begin
                sram_act_wdata0_d = 0;
                sram_act_wea0_d = 4'b0000;
                sram_act_wdata1_d = 0;
                sram_act_wea1_d = 4'b0000;
            end
        endcase
    end
    else if (state == actqs1)begin
        case(counter)
            0:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {16'b0 ,out_actq[1] ,out_actq[0]};
                        sram_act_wea0_d = 4'b1111;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {out_actq[1] ,out_actq[0],16'b0};
                        sram_act_wea0_d = 4'b1100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {24'b0 ,out_actq[0]};
                        sram_act_wea0_d = 4'b1111;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            1:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {8'b0 ,out_actq[1] ,out_actq[0], 8'b0};
                        sram_act_wea0_d = 4'b0110;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {out_actq[0] ,24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d=  {24'b0 ,out_actq[1]};
                        sram_act_wea1_d  = 4'b1111;
                    end
                    0 : begin
                        sram_act_wdata0_d = {16'b0 ,out_actq[0],8'b0};
                        sram_act_wea0_d = 4'b0010;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            2:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {out_actq[1] ,out_actq[0], 16'b0};
                        sram_act_wea0_d = 4'b1100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    2:begin
                        sram_act_wdata0_d =  {16'b0,out_actq[1] ,out_actq[0]};
                        sram_act_wea0_d = 4'b0011;
                        sram_act_wdata1_d= 0;
                        sram_act_wea1_d  = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {8'b0 ,out_actq[0],16'b0};
                        sram_act_wea0_d = 4'b0100;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            3:begin
                case(colcounter)
                    1:begin
                        sram_act_wdata0_d = {out_actq[0], 24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d = {24'b0,out_actq[1]};
                        sram_act_wea1_d = 4'b1111;
                    end
                    2:begin
                        sram_act_wdata0_d =  {8'b0,out_actq[1] ,out_actq[0], 8'b0};
                        sram_act_wea0_d = 4'b0110;
                        sram_act_wdata1_d= 0;
                        sram_act_wea1_d  = 4'b0000;
                    end
                    0 : begin
                        sram_act_wdata0_d = {out_actq[0],24'b0};
                        sram_act_wea0_d = 4'b1000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                    default:begin
                        sram_act_wdata0_d = 0;
                        sram_act_wea0_d = 4'b0000;
                        sram_act_wdata1_d = 0;
                        sram_act_wea1_d = 4'b0000;
                    end
                endcase
            end
            default:begin
                sram_act_wdata0_d = 0;
                sram_act_wea0_d = 4'b0000;
                sram_act_wdata1_d = 0;
                sram_act_wea1_d = 4'b0000;
            end
        endcase
    end
    else if (state == 38)begin
        sram_act_wdata0_d = {{7{psum[0][24]}},psum[0]} + {{7{temp3[24]}},temp3} + {sram_weight_rdata1_d[3],sram_weight_rdata1_d[2],sram_weight_rdata1_d[1],sram_weight_rdata1_d[0]};
        sram_act_wea0_d = 4'b1111;
        sram_act_wdata1_d = 0;
        sram_act_wea1_d = 4'b0000;
    end
    else if (state == 37)begin
        if (rowcounter == 3) begin
            sram_act_wdata0_d = {out_actq[0],outbuffer[2],outbuffer[1],outbuffer[0]};
            sram_act_wea0_d = 4'b1111;
            sram_act_wdata1_d = 0;
            sram_act_wea1_d = 4'b0000;
        end
        else begin
            sram_act_wdata0_d = 0;
            sram_act_wea0_d = 4'b0000;
            sram_act_wdata1_d = 0;
            sram_act_wea1_d = 4'b0000;
        end
    end
    else begin
        sram_act_wdata0_d = 0;
        sram_act_wea0_d = 4'b0000;
        sram_act_wdata1_d = 0;
        sram_act_wea1_d = 4'b0000;
    end
end

maxpool maxpool0(
    .clk(clk),
    .rst_n_d(rst_n_d),
    //.state(state),
    .in_data0(psum_o0[0]),
    .in_data1(psum_o0[1]),
    .in_data2(psum_o1[0]),
    .in_data3(psum_o1[1]),
    .out_data(out_max[0])
);
maxpool maxpool1(
    .clk(clk),
    .rst_n_d(rst_n_d),
    //.state(state),
    .in_data0(psum_o0[2]),
    .in_data1(psum_o0[3]),
    .in_data2(psum_o1[2]),
    .in_data3(psum_o1[3]),
    .out_data(out_max[1])
);
//assign temp1 = psum[0] + psum[1];
always@(posedge clk or negedge rst_n_d )begin
    if(!rst_n_d)begin
        temp3 <= 0;
    end
    /*else begin
        case(state)
            35: temp3 <= psum[1];
            36:begin
                if (state1 == 4)begin
                    temp3 <= psum[0] + temp3; 
                end
                else begin
                    temp3 <= psum[0] + psum[1];
                end
            end
            default: temp3 <= 0;
        endcase
    end*/
    else if (state == 35) begin
        temp3 <= psum[1];
    end
    else if(state == 36)begin
        if (state1 == 4)begin
            temp3 <= psum[0] + temp3; 
        end
        else begin
            temp3 <= psum[0] + psum[1];
        end
    end
    else begin
        temp3 <= 0;
    end
end
assign temp2 = (state1 >1) ? temp3 : out_max[0];
actq actq0(
    .rst_n_d(rst_n_d),
    .M(scale),
    //.state(state),
    .in_data(temp2),
    .out_data(out_actq[0])
);
always@(posedge clk)begin
    if(!rst_n_d)begin
        for(i = 0 ; i<3 ; i=i+1)begin
            outbuffer[i] <= 0;
        end
    end
    else if(state == 37 && rowcounter !=3)begin
        outbuffer[rowcounter] <= out_actq[0];
        //$display("out_actq[0] = %d",out_actq[0]);
        //$display("outbuffer[%d] = %d",rowcounter,outbuffer[rowcounter]);
    end
    else begin
        for(i = 0 ; i<3 ; i=i+1)begin
            outbuffer[i] <= outbuffer[i];
        end
    end
end
actq actq1(
    .rst_n_d(rst_n_d),
    .M(scale),
    //.state(state),
    .in_data(out_max[1]),
    .out_data(out_actq[1])
);

assign in[0] = (state1 > 1) ? sram_act_rdata1_d[1] : sram_act_rdata0_d[1];
assign in[1] = (state1 > 1) ? sram_act_rdata1_d[2] : sram_act_rdata0_d[2];
assign in[2] = (state1 > 1) ? sram_act_rdata1_d[3] : sram_act_rdata0_d[3];
assign in[3] = (state1 > 1) ? 0 : sram_act_rdata1_d[0];
assign in[4] = (state1 > 1) ? 0 : sram_act_rdata1_d[1];

assign we[0] = (state1 > 1) ? sram_weight_rdata1_d[1] : sram_weight_rdata0_d[0];
assign we[1] = (state1 > 1) ? sram_weight_rdata1_d[2] : sram_weight_rdata0_d[1];
assign we[2] = (state1 > 1) ? sram_weight_rdata1_d[3] : sram_weight_rdata0_d[2];
assign we[3] = (state1 > 1) ? 0 : sram_weight_rdata0_d[3];
assign we[4] = (state1 > 1) ? 0 : sram_weight_rdata1_d[0];

assign in[5] = (state == 34 && sram_act_addr0_d == 742) ? 0 : sram_act_rdata1_d[0];
assign we[5] = (state == 34 && sram_act_addr0_d == 742 ) ? 0 : sram_weight_rdata1_d[0];


pe pe00(
    .clk(clk),
    .rst_n_d(rst_n_d),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(sram_act_rdata0_d[0]),
    .in_data1(sram_act_rdata0_d[1]),
    .in_data2(sram_act_rdata0_d[2]),
    .in_data3(sram_act_rdata0_d[3]),
    .in_data4(in[5]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(sram_weight_rdata0_d[2]),
    .weight_data3(sram_weight_rdata0_d[3]),
    .weight_data4(we[5]),
    .out_data(psum[0])
);
pe pe01(
    .clk(clk),
    .rst_n_d(rst_n_d),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(in[0]),
    .in_data1(in[1]),
    .in_data2(in[2]),
    .in_data3(in[3]),
    .in_data4(in[4]),
    .weight_data0(we[0]),
    .weight_data1(we[1]),
    .weight_data2(we[2]),
    .weight_data3(we[3]),
    .weight_data4(we[4]),
    .out_data(psum[1])
);
pe pe02(
    .clk(clk),
    .rst_n_d(rst_n_d),
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
    .rst_n_d(rst_n_d),
    .compute_start(startcom1),
    .done(done0),
    .in_data0(sram_act_rdata0_d[3]),
    .in_data1(sram_act_rdata1_d[0]),
    .in_data2(sram_act_rdata1_d[1]),
    .in_data3(sram_act_rdata1_d[2]),
    .in_data4(sram_act_rdata1_d[3]),
    .weight_data0(sram_weight_rdata0_d[0]),
    .weight_data1(sram_weight_rdata0_d[1]),
    .weight_data2(sram_weight_rdata0_d[2]),
    .weight_data3(sram_weight_rdata0_d[3]),
    .weight_data4(sram_weight_rdata1_d[0]),
    .out_data(psum[3])
);

pe pe10(
    .clk(clk),
    .rst_n_d(rst_n_d),
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
    .rst_n_d(rst_n_d),
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
    .rst_n_d(rst_n_d),
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
    .rst_n_d(rst_n_d),
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
    input rst_n_d,
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
    always @(posedge clk or negedge rst_n_d ) begin
        if(!rst_n_d)begin
            for(i = 0; i < 5; i = i + 1)begin 
                product[i] <= 0;
            end
        end
        else if(compute_start || done)begin
            for(i = 0; i < 5; i = i + 1)begin
                product[i] <= 0;
            end
        end
        else begin
                product[0] <= in_data0 * weight_data0;
                product[1] <= in_data1 * weight_data1;
                product[2] <= in_data2 * weight_data2;
                product[3] <= in_data3 * weight_data3;
                product[4] <= in_data4 * weight_data4;
        end
    end

    always @(posedge clk or negedge rst_n_d ) begin
        if(!rst_n_d)begin
            out_data <= 0;
        end
        else if(done)begin
            out_data <= 0;
        end
        else begin
            out_data <= out_data + (product[0] + ((product[1] + product[2]) + (product[3] + product[4])));
        end
    end

endmodule

module maxpool (
    input clk,
    input rst_n_d,
    //input signed [31:0] M,
    //input [5:0] state,
    input signed [24:0] in_data0,
    input signed [24:0] in_data1,
    input signed [24:0] in_data2,
    input signed [24:0] in_data3,

    output reg signed [24:0] out_data
);

    wire signed [24:0] temp0,temp1,temp2;
    assign temp0 = /*(state != 5) ? 0 :*/(in_data0 > in_data1) ? in_data0 : in_data1;
    assign temp1 = /*(state != 5) ? 0 :*/(in_data2 > in_data3) ? in_data2 : in_data3;
    assign temp2 = /*(state != 5) ? 0 :*/(temp0 > temp1) ? temp0 : temp1;
    //assign temp3 = /*(state != 5) ? 0 : */(temp2 > 0) ? temp2 : 0;
    always @(posedge clk or negedge rst_n_d ) begin
        if(!rst_n_d)begin
            out_data <= 0;
        end
        /*else if(state == 5 || state == 25)begin
            out_data <= temp2;
        end*/
        else begin
            out_data <= temp2;
        end
    end
endmodule

module actq (
    input rst_n_d,
    input signed [31:0] M,
    //input [5:0] state,
    input signed [24:0] in_data,
    output reg signed [7:0] out_data
);
    wire signed [7:0] data;
    //wire signed [49:0] temp3;
    //wire signed [24:0] temp0;
    wire signed [33:0] temp;
    //wire signed [24:0] temp1;
    //assign temp0 = (in_data > 0) ? temp : 0;
    //assign temp0 = (in_data <= 0) ? 0 : (((M[24:0]*in_data) >> 16) > 127) ? 127 : (((M[24:0]*in_data) >> 16) < -128) ? -128 : ((M[24:0]*in_data) >> 16);
    //assign temp3 = M[24:0] * in_data;
    assign temp =  (M[24:0] * in_data) >> 16;
    //assign temp1 = temp0 >> 16;
    assign data =(temp > 127) ? 127 : (temp < -128) ? -128 : temp;
    always @(*) begin
        if(!rst_n_d)begin
            out_data = 0;
        end
        else if(in_data > 0)begin
            out_data = data;
        end
        else begin
            out_data = 0;
        end
    end
endmodule