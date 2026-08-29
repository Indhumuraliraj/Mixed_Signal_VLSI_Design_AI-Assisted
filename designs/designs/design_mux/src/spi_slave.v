//------------------------------------------------
// spi_slave.v
//------------------------------------------------
// General purpose SPI slave module
// Written by Tim Edwards, efabless, inc.
// April 23, 2017
//------------------------------------------------
// SCK   --- Clock input
// SDI   --- Data  input
// SDO   --- Data  output
// CSB   --- Chip  select (active low)
// idata --- Data from chip to transmit (8 bits)
// odata --- Input data to chip (8 bits)
// oaddr --- Decoded address to upstream circuits
// rdstb --- Read  strobe: upstream must supply idata
// wrstb --- Write strobe: upstream must latch odata
//------------------------------------------------

`define COMMAND  2'b00
`define ADDRESS  2'b01
`define DATA     2'b10
`define IDLE     2'b11

module spi_slave (
    input        SCK,
    input        SDI,
    input        CSB,
    output       SDO,
    output reg   sdoenb,
    input  [7:0] idata,
    output [7:0] odata,
    output [7:0] oaddr,
    output reg   rdstb,
    output reg   wrstb
);

    reg  [7:0] addr;
    reg  [1:0] state;
    reg  [2:0] count;
    reg        writemode;
    reg        readmode;
    reg  [2:0] fixed;
    reg  [6:0] predata;
    reg  [7:0] ldata;

    assign odata = {predata, SDI};
    assign oaddr = (state == `ADDRESS) ? {addr[6:0], SDI} : addr;
    assign SDO   = ldata[7];

    // Drive SDO on falling edge so it is stable at next rising edge (SPI Mode 0)
    always @(negedge SCK or posedge CSB) begin
        if (CSB == 1'b1) begin
            wrstb  <= 1'b0;
            ldata  <= 8'b0000_0000;
            sdoenb <= 1'b1;
        end else begin
            if (state == `DATA) begin
                if (readmode == 1'b1) begin
                    sdoenb <= 1'b0;
                    if (count == 3'b000)
                        ldata <= idata;
                    else
                        ldata <= {ldata[6:0], 1'b0};
                end else begin
                    sdoenb <= 1'b1;
                end

                // Assert write strobe on second-to-last bit so data
                // latches on the rising edge of the last bit
                if (count == 3'b111) begin
                    if (writemode == 1'b1)
                        wrstb <= 1'b1;
                end else begin
                    wrstb <= 1'b0;
                end
            end else begin
                wrstb  <= 1'b0;
                sdoenb <= 1'b1;
            end
        end
    end

    // Sample SDI and advance state machine on rising edge
    always @(posedge SCK or posedge CSB) begin
        if (CSB == 1'b1) begin
            addr      <= 8'h00;
            rdstb     <= 1'b0;
            predata   <= 7'b000_0000;
            state     <= `COMMAND;
            count     <= 3'b000;
            readmode  <= 1'b0;
            writemode <= 1'b0;
            fixed     <= 3'b000;
        end else begin
            if (state == `COMMAND) begin
                rdstb <= 1'b0;
                count <= count + 1;
                if      (count == 3'b000) writemode <= SDI;
                else if (count == 3'b001) readmode  <= SDI;
                else if (count  < 3'b101) fixed     <= {fixed[1:0], SDI};
                else if (count == 3'b111) state     <= `ADDRESS;
            end else if (state == `ADDRESS) begin
                count <= count + 1;
                addr  <= {addr[6:0], SDI};
                if (count == 3'b111) begin
                    if (readmode == 1'b1) rdstb <= 1'b1;
                    state <= `DATA;
                end else begin
                    rdstb <= 1'b0;
                end
            end else if (state == `DATA) begin
                predata <= {predata[5:0], SDI};
                count   <= count + 1;
                if (count == 3'b111) begin
                    if (fixed == 3'b001)
                        state <= `COMMAND;
                    else if (fixed != 3'b000) begin
                        fixed <= fixed - 1;
                        addr  <= addr + 1;
                    end else begin
                        addr  <= addr + 1;
                    end
                end else begin
                    rdstb <= 1'b0;
                end
            end
        end
    end

endmodule
