//------------------------------------------------
// design_mux.v
//------------------------------------------------
// Top-level mixed signal design
// Integrates:
//   - AMUX2_3V : analog 2:1 mux macro (blackbox)
//   - raven_spi: digital SPI controller
//
// Signal flow:
//   raven_spi.SDO   → AMUX2_3V.I0  (SPI data out)
//   raven_spi.reset → AMUX2_3V.I1  (chip reset)
//   select          → AMUX2_3V.select
//   AMUX2_3V.out    → out (top-level output)
//------------------------------------------------

`include "raven_spi.v"

module design_mux (
    output       out,          // Mux output — goes off-chip
    input        select,       // Analog mux channel select
    input        RST,          // SPI + chip reset
    input        SCK,          // SPI clock
    input        SDI,          // SPI data in
    input        CSB,          // SPI chip select (active low)
    input        trap,         // PicoSoC trap signal (read-only via SPI)
    input  [3:0] mask_rev_in   // Metal-programmed mask revision
);

    //--------------------------------------------------
    // Internal wires — connect raven_spi to AMUX2_3V
    //--------------------------------------------------
    wire I0;           // raven_spi SDO   → AMUX2_3V I0
    wire I1;           // raven_spi reset → AMUX2_3V I1

    // Unused raven_spi outputs — kept as wires
    // so the module instantiation is complete
    wire        sdo_enb;
    wire        xtal_ena;
    wire        reg_ena;
    wire        pll_vco_ena;
    wire        pll_cp_ena;
    wire        pll_bias_ena;
    wire [3:0]  pll_trim;
    wire        pll_bypass;
    wire        irq;
    wire [11:0] mfgr_id;
    wire [7:0]  prod_id;
    wire [3:0]  mask_rev;

    //--------------------------------------------------
    // Analog macro instantiation (blackbox)
    // VDD/VSS are physical supply pins — connected
    // by the power grid during floorplan, not here
    //--------------------------------------------------
    AMUX2_3V AMUX2_3V (
        .I0     (I0),      // Input 0 : SDO from raven_spi
        .I1     (I1),      // Input 1 : reset from raven_spi
        .out    (out),     // Output  : goes to top-level out pin
        .select (select),   // Select  : top-level input pin
        .VPWR (VPWR),
        .VGND (VGND)	
	);

    //--------------------------------------------------
    // Digital SPI controller instantiation
    //--------------------------------------------------
    raven_spi raven_spi (
        .RST          (RST),
        .SCK          (SCK),
        .SDI          (SDI),
        .CSB          (CSB),
        .SDO          (I0),          // SPI data out → AMUX2_3V I0
        .sdo_enb      (sdo_enb),
        .xtal_ena     (xtal_ena),
        .reg_ena      (reg_ena),
        .pll_vco_ena  (pll_vco_ena),
        .pll_cp_ena   (pll_cp_ena),
        .pll_bias_ena (pll_bias_ena),
        .pll_trim     (pll_trim),
        .pll_bypass   (pll_bypass),
        .irq          (irq),
        .reset        (I1),          // chip reset → AMUX2_3V I1
        .trap         (trap),
        .mfgr_id      (mfgr_id),
        .prod_id      (prod_id),
        .mask_rev_in  (mask_rev_in),
        .mask_rev     (mask_rev)
    );

endmodule
