//Verilog实现串口协议接收，带错误指示，校验错误和停止位错误

/*
16个时钟周期接收1位，中间采样
*/
module my_uart_rx(

input clk,             //采样时钟
input rst_n,
input rx,              //UART数据输入
output reg [7:0] dataout,        //接收数据输出
output reg rx_ok,          //接收数据有效，高说明接收到一个字节
output reg err_check,      //数据出错指示
output reg err_frame     //帧出错指示

);

reg [7:0] cnt;
reg [10:0] dataout_buf;

reg rx_buf;
reg rx_negedge_flag;
reg receive;

wire busy;
wire odd_bit;   //奇校验位 = ~偶校验位
wire even_bit;  //偶校验位 = 各位异或
wire POLARITY_BIT;   //本地计算的奇偶校验
// wire polarity_ok;
// assign polarity_ok = (POLARITY_BIT == dataout_buf[9]) ? 1 : 0; //校验正确=1，否则=0

assign busy = rx_ok;
assign even_bit = ^dataout;     //一元约简，= data_in[0] ^ data_in[1] ^ .....
assign odd_bit = ~even_bit;
assign POLARITY_BIT = even_bit;  //偶校验
// assign POLARITY_BIT = odd_bit;  //奇校验

parameter CNT_MAX = 176;

//rx信号下降沿标志位
always @(posedge clk)   
begin
    if(!rst_n)
    begin
        rx_buf <= 0;
        rx_negedge_flag <= 0;
    end
    else
    begin
        rx_buf <= rx;
        rx_negedge_flag <= rx_buf & (~rx);
    end
end
//在接收期间，保持高电平
always @(posedge clk)
begin
    if(!rst_n)
        receive <= 0;
    else if (rx_negedge_flag && (~busy))  //检测到线路的下降沿并且原先线路为空闲，启动接收数据进程
        receive <= 1;      //开始接收数据
    else if(cnt == CNT_MAX)  //接收数据完成
        receive <= 0;
end
//起始位+8位数据位+校验位+停止位 = 11位 * 16 = 176个时钟周期
always @ (posedge clk)
begin
    if(!rst_n)
        cnt <= 0;
    else if(!receive || cnt >= CNT_MAX)
        cnt <= 0;
    else if(receive)
        cnt <= cnt + 1;
end
//校验错误:奇偶校验不一致
always @ (posedge clk)
begin
    if(!rst_n)
        err_check <= 0;
    else if(cnt == 152)
    begin
        // if(POLARITY_BIT == rx)
        if(POLARITY_BIT != dataout_buf[9])      //奇偶校验正确
            err_check <= 1;         //锁存
        // else
            // err_check <= 1;       
    end
end
//帧错误:停止位不为1
always @ (posedge clk)
begin
    if(!rst_n)
        err_frame <= 0;
    else if(cnt == CNT_MAX)
    begin
        if(dataout_buf[10] != 1)        //停止位
            err_frame <= 1;
        // else
            // err_frame <= 1;      //如果没有接收到停止位，表示帧出错
    end
end

always @ (posedge clk)
begin
    if(!rst_n)
        dataout <= 11'h00;
    else if(receive)
    begin
        // if(rx_ok)
        if(cnt >= 137)
            dataout <= dataout_buf[8:1];        //数据位:8-1位
        // else if(!rx_ok)
            // dataout <= 0;
    end
end

always @ (posedge clk)
begin
    if(!rst_n)
        rx_ok <= 0;
    else if(receive)
    begin
        if(cnt >= 137)   //137-169
            rx_ok <= 1;
        else 
            rx_ok <= 0;
    end
    else 
        rx_ok <= 0;
end


//起始位+8位数据+奇偶校验位+停止位 = 11 * 16 = 176位

always @(posedge clk)
begin
    if(!rst_n)
        dataout_buf <= 8'h00;
    else if(receive)
    begin
        case (cnt)      //中间采样
            8'd8: dataout_buf[0] <= rx;         //起始位=0
            8'd24: dataout_buf[1] <= rx;        //LSB低位在前
            8'd40: dataout_buf[2] <= rx;
            8'd56: dataout_buf[3] <= rx;
            8'd72: dataout_buf[4] <= rx;
            8'd88: dataout_buf[5] <= rx;
            8'd104: dataout_buf[6] <= rx;
            8'd120: dataout_buf[7] <= rx;
            8'd136: dataout_buf[8] <= rx;       //MSB高位在后
            8'd152: dataout_buf[9] <= rx;       //奇偶校验位
            8'd168: dataout_buf[10] <= rx;      //停止位=1
            default:;
        endcase
    end
end


endmodule

