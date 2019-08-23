/*
串口协议发送：起始位 + 8位数据位 + 校验位 + 停止位 = 11位 * 16 = 176个时钟周期
clk频率 = 波特率 * 16
*/

module uart_tx_8bit(

//input
input clk,                //UART时钟=16*波特率
input rst_n,
input [7:0] data_in,       //需要发送的数据
input trig,                //上升沿发送数据

//output
output busy,                 //高电平忙:数据正在发送中
output reg tx                //发送数据信号

);

reg[7:0] cnt;             //计数器
reg trig_buf;
reg trig_posedge_flag;
// reg trig_negedge_flag;
reg send;

reg [10:0] data_in_buf;     //trig上升沿读取输入的字节，拼接数据帧

wire odd_bit;   //奇校验位 = ~偶校验位
wire even_bit;  //偶校验位 = 各位异或
wire POLARITY_BIT = even_bit;  //偶校验
// wire POLARITY_BIT = odd_bit;   //奇校验

assign even_bit = ^data_in; //一元约简，= data_in[0] ^ data_in[1] ^ .....
assign odd_bit = ~even_bit;
assign busy = send;     //输出的忙信号

//起始位+8位数据位+校验位+停止位 = 11位 * 16 = 176个时钟周期
parameter CNT_MAX = 176;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        trig_buf <= 0;
        trig_posedge_flag <= 0;
        // trig_negedge_flag <= 0;
    end
    else 
    begin
        trig_buf <= trig;
        trig_posedge_flag <= (~trig_buf) & trig; //在trig信号上升沿时产生1个时钟周期的高电平
        // trig_negedge_flag <= trig_buf & (~trig); //在trig信号下降沿时产生1个时钟周期的高电平    
    end
end

always @(posedge clk)
begin
    if(!rst_n)
        send <= 0;
    else if (trig_posedge_flag &  (~busy))  //当发送命令有效且线路为空闲时，启动新的数据发送进程
        send <= 1;
    else if(cnt == CNT_MAX)      //一帧资料发送结束
        send <= 0;
end

always @ (posedge clk)
begin
    if(!rst_n)
        data_in_buf <= 11'b0;
    else if(trig_posedge_flag & (~busy))    //只读取一次数据，一帧数据发送过程中，改变输入无效
        data_in_buf <= {1'b1, POLARITY_BIT, data_in[7:0], 1'b0};   //数据帧拼接
end

always @ (posedge clk)
begin
    if(!rst_n)
        cnt <= 0;
    else if(!send || cnt >= CNT_MAX)
        cnt <= 0;
    else if(send)
        cnt <= cnt + 1;
end

always @(posedge clk)
begin
    if(!rst_n)
        tx <= 1;
    else if(send)  
    begin
        case(cnt)                 //1位占用16个时钟周期
            0: tx <= data_in_buf[0];           //低位在前，高位在后
            16: tx <= data_in_buf[1];    //bit0,占用第16~31个时钟
            32: tx <= data_in_buf[2];    //bit1,占用第47~32个时钟
            48: tx <= data_in_buf[3];    //bit2,占用第63~48个时钟
            64: tx <= data_in_buf[4];    //bit3,占用第79~64个时钟
            80: tx <= data_in_buf[5];    //bit4,占用第95~80个时钟
            96: tx <= data_in_buf[6];    //bit5,占用第111~96个时钟
            112: tx <= data_in_buf[7];   //bit6,占用第127~112个时钟
            128: tx <= data_in_buf[8];   //bit7,占用第143~128个时钟
            144: tx <= data_in_buf[9];   //发送奇偶校验位，占用第159~144个时钟
            160: tx <= data_in_buf[10];  //发送停止位，占用第160~167个时钟            
            CNT_MAX: tx <= 1;            //无空闲位
            default:;
        endcase
    end
    else if(!send) 
        tx <= 1;
end

endmodule

