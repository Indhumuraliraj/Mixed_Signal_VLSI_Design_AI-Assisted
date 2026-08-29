//-------------------------------------
// raven_spi.v
//-------------------------------------
// SPI controller for Raven (PicoSoC)
// Written by Tim Edwards
// efabless, inc. January 3, 2018
//-------------------------------------
// Standalone 3V slave SPI for the Raven chip.
// Controls PLL, oscillator, regulator, reset, IRQ,
// and ID registers — all independent of the PicoSoC core.
//
// Register map:
//   0x00 : SPI status/control    (reserved, always 0)
//   0x01 : {mask_rev, mfgr_id[11:8]}
//   0x02 : mfgr_id[7:0]         (0x56, fixed)
//   0x03 : prod_id               (0x02, fixed)
//   0x04 : {xtal_ena, reg_ena, pll_vco_ena, pll_cp_ena, pll_trim[3:0]}
//   0x05 : pll_bypass            (bit 0)
//   0x06 : irq                   (bit 0)
//   0x07 : reset                 (bit 0)
//   0x08 : trap                  (bit 0, read-only)
//-------------------------------------

`include "spi_slave.v"

module raven_spi (
    input        RST,
    input        SCK,
    input        SDI,
    input        CSB,
    output       SDO,
    output       sdo_enb,
    output reg   xtal_ena,
    output reg   reg_ena,
    output reg   pll_vco_ena,
    output reg   pll_cp_ena,
    output reg   pll_bias_ena,
    output reg   [3:0] pll_trim,
    output reg   pll_bypass,
    output reg   irq,
    output reg   reset,
    input        trap,
    input  [3:0] mask_rev_in,
    output [11:0] mfgr_id,
    output [7:0]  prod_id,
    output [3:0]  mask_rev
);

    wire [7:0] odata;
    wire [7:0] idata;
    wire [7:0] iaddr;
    wire       rdstb;
    wire       wrstb;

    // Instantiate generic SPI slave protocol engine
    spi_slave U1 (
        .SCK    (SCK),
        .SDI    (SDI),
        .CSB    (CSB),
        .SDO    (SDO),
        .sdoenb (sdo_enb),
        .idata  (odata),
        .odata  (idata),
        .oaddr  (iaddr),
        .rdstb  (rdstb),
        .wrstb  (wrstb)
    );

    // Hard-coded identification values
    assign mfgr_id  = 12'h456;
    assign prod_id  = 8'h02;
    assign mask_rev = mask_rev_in;

    // Read mux — selects register contents to send out on SDO
    assign odata =
        (iaddr == 8'h00) ? 8'h00 :
        (iaddr == 8'h01) ? {mask_rev, mfgr_id[11:8]} :
        (iaddr == 8'h02) ? mfgr_id[7:0] :
        (iaddr == 8'h03) ? prod_id :
        (iaddr == 8'h04) ? {xtal_ena, reg_ena, pll_vco_ena, pll_cp_ena, pll_trim} :
        (iaddr == 8'h05) ? {7'b000_0000, pll_bypass} :
        (iaddr == 8'h06) ? {7'b000_0000, irq} :
        (iaddr == 8'h07) ? {7'b000_0000, reset} :
        (iaddr == 8'h08) ? {7'b000_0000, trap} :
                           8'h00;

    // Write path — latch incoming SPI data into registers
    always @(posedge SCK or posedge RST) begin
        if (RST == 1'b1) begin
            // Power-on reset defaults
            pll_trim     <= 4'b0000;
            xtal_ena     <= 1'b1;
            reg_ena      <= 1'b1;
            pll_vco_ena  <= 1'b1;
            pll_cp_ena   <= 1'b1;
            pll_bias_ena <= 1'b1;
            pll_bypass   <= 1'b0;
            irq          <= 1'b0;
            reset        <= 1'b0;
        end else if (wrstb == 1'b1) begin
            case (iaddr)
                8'h04: begin
                    pll_trim     <= idata[3:0];
                    pll_cp_ena   <= idata[4];
                    pll_vco_ena  <= idata[5];
                    reg_ena      <= idata[6];
                    xtal_ena     <= idata[7];
                end
                8'h05: pll_bypass <= idata[0];
                8'h06: irq        <= idata[0];
                8'h07: reset      <= idata[0];
                // 0x08 is read-only (trap), no write action
            endcase
        end
    end

endmodule
