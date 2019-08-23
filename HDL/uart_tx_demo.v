//0123456789每隔100ms循环发送
module uart_tx_demo( 

input clk,      //16M,波特率1M
input rst_n,

output led,
output idle,

output tx

);

reg [31:0] cnt_500ms;
reg tx_ctrl;    //上升沿触发发送
reg [7:0] tx_buf;

parameter CST_500ms = 8_000_000;
parameter CST_100ms = 1_600_000;
//parameter CST_DELAY = CST_100ms;
parameter CST_DELAY = 8000;      //仿真测试使用

reg [3:0] tx_cnt;

assign led = tx_ctrl;

always @ (posedge clk)
begin
    if(!rst_n)
        cnt_500ms <= 0;
    else if(cnt_500ms >= CST_DELAY)
        cnt_500ms <= 0;
    else 
        cnt_500ms <= cnt_500ms + 1;
end

always @ (posedge clk)
begin
    if(!rst_n)
        tx_ctrl <= 0;
    else if(cnt_500ms < 2 && idle == 0)
        tx_ctrl <= 1;
    else
        tx_ctrl <= 0; 
end
//发送字符串计数
always @ (posedge clk)
begin
    if(!rst_n)
        tx_cnt <= 0;
    else if(tx_cnt > 9)     //计数最大值9
        tx_cnt <= 0;
    else if(cnt_500ms == CST_DELAY)
        tx_cnt <= tx_cnt + 1;
end

always @ (posedge clk)
begin
    if(!rst_n)
        tx_buf <= 8'h30;
    else 
    begin
        tx_buf <= 8'h30 + tx_cnt;    
    end
end

uart_tx_8bit uut (
    //input
    .clk(clk), 
    .data_in(tx_buf), 
    .rst_n(rst_n),
    .trig(tx_ctrl), 
    
    //output
    .busy(idle), 
    .tx(tx)
);

endmodule

