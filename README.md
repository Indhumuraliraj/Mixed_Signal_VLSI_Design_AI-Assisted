# 🚀 Mixed-Signal VLSI Design 

## Introdution
This repository documents my work on the physical design of a mixed-signal ASIC integrating an analog 2×1 MUX and a digital SPI controller. The implementation uses the SKY130 PDK and open-source EDA tools including OpenLane, OpenROAD, Magic, Netgen, and ngspice, covering the  physical design flow, analog macro integration, floorplanning, placement, CTS, routing, DRC, LVS, and final layout generation.

---

## Tools Used

## 🛠️ Tools Used & Description

| Tool / Technology | Purpose in the Project |
|---|---|
| **Claude / Sonnet 5** | Used to understand the reference repository, generate Verilog, OpenLane configuration files, Tcl/shell scripts, simulation commands, and assist with debugging physical-design errors. |
| **Linux / Ubuntu** | Used as the main development environment for running OpenLane, Magic, Netgen, ngspice and other VLSI tools. |
| **OpenLane** | Used to automate the RTL-to-GDSII physical-design flow including synthesis, floorplanning, placement, CTS, routing and final layout generation. |
| **SKY130 PDK** | Provided the semiconductor process design kit, technology files, standard-cell libraries and process-specific information required for physical implementation. |
| **Yosys** | Used for RTL synthesis and conversion of the digital Verilog design into a gate-level representation. |
| **OpenROAD** | Used for automated physical-design stages such as floorplanning, placement, clock-tree synthesis, routing and related optimization. |
| **Magic** | Used for layout viewing, physical verification, DRC checking, extraction and generation/processing of the analog macro physical views. |
| **Netgen** | Used for Layout-versus-Schematic (LVS) verification by comparing the extracted layout connectivity with the reference circuit/netlist. |
| **KLayout** | Used to visualize and inspect the layout, GDSII files, metal layers, macro geometry and physical-design results. |
| **ngspice** | Used for SPICE-level circuit simulation and verification of the analog MUX behavior and post-layout extracted circuit. |
| **Shell / Bash** | Used to execute Linux commands, automation scripts, OpenLane runs and verification flows. |
| **Git / GitHub** | Used for version control, tracking changes and maintaining reproducible project files. |


---
## Project Progress


### TASK-1 — Digital VLSI and RTL-to-GDS Foundation

<details>
<summary>Theory</summary>

## 1. Introduction to Mixed-Signal Design

Mixed-signal design combines analog and digital circuits on the same
integrated circuit. Analog circuits process continuous-valued signals,
while digital circuits process discrete logic signals. Mixed-signal ASICs
are widely used in sensors, communication systems, data converters,
automotive electronics and IoT devices.

In a mixed-signal design, the analog and digital blocks are usually
developed using different design methodologies. The analog block may be
created as a transistor-level or custom layout, while the digital block
is described using RTL and implemented using standard cells.

![Image}()

The overall workflow is:
```text
                    System Specification
                            │
                            ▼
              Analog and Digital Partitioning
                            │
                 ┌──────────┴──────────┐
                 ▼                     ▼
        Analog Circuit Design     Digital RTL Design
                 │                     │
                 ▼                     ▼
           Analog Layout          RTL Verification
                 │                     │
                 ▼                     ▼
          Analog Macro Views       RTL Synthesis
                 │                     │
                 └──────────┬──────────┘
                            ▼
                 Mixed-Signal Integration
                            │
                            ▼
                    Physical Design
                            │
                            ▼
                 DRC / LVS / Verification
                            │
                            ▼
                          GDSII
```

---

### Project (2x1 mux)

The project implements a mixed-signal system in which a 2:1 analog
multiplexer (`AMUX2_3V`) is integrated with a digital SPI (Serial Peripheral Interface)-based control
block. The analog multiplexer selects one of two analog input signals
(`I0` or `I1`) based on the digital select signal and provides the selected
signal at the output.

The digital SPI controller provides the control interface for the analog
MUX. The analog macro is represented as a hard macro during synthesis and
physical implementation, while its physical and layout information is
provided through the required macro views.

![Image}()

The overall project workflow is:

```text
                 Project Specification
                         │
                         ▼
              Mixed-Signal Architecture
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
       Digital SPI Control      Analog AMUX2_3V
              │                     │
              ▼                     ▼
         RTL Design            Analog Macro
              │                     │
              ▼                     ▼
        RTL Verification       Macro Layout
              │                     │
              ▼                     ▼
         RTL Synthesis        LEF / LIB / GDS
              │                     │
              └──────────┬──────────┘
                         ▼
                Macro Integration
                         │
                         ▼
                  OpenLane Flow
                         │
                         ▼
                   Floorplanning
                         │
                         ▼
                Placement and PDN
                         │
                         ▼
                       CTS
                         │
                         ▼
                     Routing
                         │
                         ▼
                  DRC / LVS Check
                         │
                         ▼
                    Final GDSII
```

The digital and analog sections are developed separately and then
integrated into a common physical-design environment. The digital SPI
logic is synthesized using standard cells, while `AMUX2_3V` is maintained
as a fixed analog hard macro.

---

</details>

<details>
<summary>Prompts</summary>

## AI-Assisted Prompts

AI was used throughout the task to analyze the reference repository, understand the mixed-signal physical-design flow, generate the required analog and digital design files, prepare the `AMUX2_3V` hard macro views, and assist with integrating the analog macro with the digital SPI controller.

---

### Prompt 1: Repository Analysis and Understanding

#### Prompt

```text
Analyze the given reference repository and explain the complete project
structure and implementation flow.

Identify:
1. The purpose of the project.
2. The function of each important file.
3. The role of the AMUX2_3V analog macro.
4. How the analog macro is integrated with the digital SPI design.
5. The required input files for the physical-design flow.
6. The sequence of tools and stages used to generate the final layout.
```

#### Outcome

The repository structure, design methodology, important files, and overall mixed-signal RTL-to-GDSII flow were understood.

#### Files Identified

```text
design_mux.v
raven_spi.v
spi_slave.v
AMUX2_3V.v
AMUX2_3V.mag
AMUX2_3V.spice
AMUX2_3V.lef
AMUX2_3V.lib
AMUX2_3V.gds
config.json
macro.cfg
```

---

### Prompt 2: Identify Required Input Files

#### Prompt

```text
Based on the reference repository, identify all the input files required
to reproduce the AMUX2_3V mixed-signal physical-design flow.

For each file provide:
1. File name
2. File format
3. Purpose
4. Tool that uses the file
5. Stage of the physical-design flow where it is required.
```

#### Outcome

The required RTL, SPI digital design files, analog macro views, OpenLane configuration, and macro-placement files were identified.

#### Files Identified

| File             | Format  | Purpose                       |
| ---------------- | ------- | ----------------------------- |
| `raven_spi.v`    | Verilog | SPI controller RTL            |
| `spi_slave.v`    | Verilog | SPI slave/interface RTL       |
| `design_mux.v`   | Verilog | Top-level integration         |
| `AMUX2_3V.v`     | Verilog | Analog macro blackbox         |
| `AMUX2_3V.mag`   | Magic   | Analog physical layout        |
| `AMUX2_3V.spice` | SPICE   | Analog/post-layout simulation |
| `AMUX2_3V.lef`   | LEF     | Physical abstract view        |
| `AMUX2_3V.lib`   | Liberty | Timing/functional model       |
| `AMUX2_3V.gds`   | GDSII   | Final physical macro layout   |
| `config.json`    | JSON    | OpenLane configuration        |
| `macro.cfg`      | Config  | Macro placement configuration |

---

### Prompt 3: Generate Digital SPI Controller

#### Prompt

```text
Generate the Verilog RTL for the digital SPI controller used in the
mixed-signal design.

Create a file named raven_spi.v.

The SPI controller should provide the required SPI control and data
signals and should be suitable for integration with the AMUX2_3V analog
macro.

Maintain a synthesizable RTL coding style.

Include:
1. Clock and reset.
2. SPI control logic.
3. Serial data handling.
4. Required SPI interface signals.
5. Control signals required to connect with the analog AMUX.
6. Proper module and port definitions.

```

#### Outcome

The digital SPI controller RTL was generated and prepared for synthesis and physical-design integration.

#### Generated File

```text
src/raven_spi.v
```

#### Observation

The `raven_spi.v` file contains the synthesizable digital RTL of the SPI controller and provides the digital interface required for integration with the analog hard macro.

---

### Prompt 4: Generate SPI Slave RTL

#### Prompt

```text
Generate the Verilog RTL for the SPI slave interface used in the project.

Create a file named spi_slave.v.

Include:
1. SPI clock input.
2. Chip-select input.
3. Serial data input.
4. Serial data output.
5. Reset functionality.
6. Shift-register based serial data transfer.
7. Required control and data signals.
8. Synthesizable Verilog RTL.

Ensure that the module interface is compatible with the raven_spi.v
controller and the top-level design.

```

#### Outcome

The SPI slave RTL was generated for serial communication and integration with the digital controller.

#### Generated File

```text
src/spi_slave.v
```

#### Observation

The `spi_slave.v` module provides the SPI slave-side serial communication logic and can be integrated with the controller and top-level digital design.

---

### Prompt 5: Generate Top-Level RTL

#### Prompt

```text
Generate the required top-level Verilog file for the design_mux project.

Create a file named design_mux.v.

Integrate:
1. The digital SPI controller.
2. The SPI slave logic where required.
3. The AMUX2_3V analog hard macro.
4. Required clock and reset signals.
5. SPI interface signals.
6. AMUX control and data signals.

Instantiate AMUX2_3V as a hard macro.

Do not implement the internal analog circuitry in RTL.
```

#### Outcome

The top-level RTL required to integrate the digital SPI logic with the `AMUX2_3V` analog hard macro was generated.

#### Generated File

```text
src/design_mux.v
```

#### Observation

The top-level RTL provides the logical connectivity between the digital SPI design and the analog hard macro while keeping the analog implementation separate.

---

### Prompt 6: Generate Analog Macro Blackbox

#### Prompt

```text
Generate the Verilog blackbox model required for the AMUX2_3V analog
hard macro.

Create a file named AMUX2_3V.v.

Use the exact macro module name and required port names.

The blackbox should contain only:
1. Module declaration.
2. Input ports.
3. Output ports.
4. Power and ground ports.

Do not include the internal analog implementation.
```

#### Outcome

The `AMUX2_3V` Verilog blackbox was generated for hard-macro integration.

#### Generated File

```text
src/AMUX2_3V.v
```

#### Observation

The blackbox allows synthesis and OpenLane to recognize the analog macro without synthesizing its internal transistor-level implementation.

---

### Prompt 7: Generate AMUX2_3V MAG Layout

#### Prompt

```text
Analyze the AMUX2_3V analog macro layout requirements and provide the
procedure to create the final Magic (.mag) layout file.

Create the layout file AMUX2_3V.mag.

Ensure that:
1. The macro has the required dimensions.
2. All signal and power pins are correctly defined.
3. SKY130A-compatible layers are used.
4. Layout connectivity matches the analog design.
5. The macro is suitable for DRC and LVS.
6. The layout can be extracted for post-layout simulation.
```

#### Outcome

The transistor-level physical layout of the `AMUX2_3V` analog macro was prepared in Magic.

#### Generated File

```text
macros/AMUX2_3V.mag
```

#### Observation

The `.mag` file represents the physical transistor-level implementation of the analog macro and serves as the source for generating other physical views.

---

### Prompt 8: Generate Extracted SPICE

#### Prompt

```text
Using the completed AMUX2_3V Magic layout, provide the procedure to
extract the post-layout SPICE netlist.

Generate the extracted SPICE representation from AMUX2_3V.mag.

Ensure that:
1. Devices are extracted correctly.
2. Physical interconnections are represented.
3. The extracted netlist preserves circuit connectivity.
4. The netlist can be simulated using ngspice.
5. The extracted netlist can be used for post-layout verification.
```

#### Outcome

The post-layout SPICE representation was extracted from the Magic layout.

#### Generated File

```text
macros/AMUX2_3V.spice
```

#### Observation

The extracted SPICE netlist connects the physical layout with post-layout electrical simulation.

---

### Prompt 9: Generate LEF from MAG Layout

#### Prompt

```text
Using the completed AMUX2_3V.mag layout, generate the LEF abstract view.

Create AMUX2_3V.lef.

Include:
1. Macro name.
2. Macro width and height.
3. Input/output pins.
4. Power and ground pins.
5. Pin directions.
6. Correct routing layers.
7. Pin geometries.
8. Macro boundary.
9. Routing obstructions.
10. SKY130-compatible layer information.

Ensure that the LEF accurately represents the physical interface of the
AMUX2_3V hard macro for OpenLane floorplanning, placement and routing.
```

#### Outcome

The LEF abstract view of the analog hard macro was generated from the physical layout.

#### Generated File

```text
lef/AMUX2_3V.lef
```

#### Observation

The LEF provides the abstract physical representation required by OpenLane for macro placement and routing.

---

### Prompt 10: Generate Liberty Model

#### Prompt

```text
Prepare the Liberty model for the AMUX2_3V analog hard macro.

Create AMUX2_3V.lib.

Include:
1. Cell definition.
2. All macro pins.
3. Pin directions.
4. Power and ground pins.
5. Functional information where applicable.
6. Required timing information.
7. Pin names matching the Verilog blackbox and LEF.

Ensure that the LIB is consistent with the AMUX2_3V macro interface and
can be used by the digital physical-design flow.
```

#### Outcome

The Liberty functional/timing abstraction for the analog hard macro was prepared for OpenLane integration.

#### Generated File

```text
lib/AMUX2_3V.lib
```

#### Observation

The Liberty model provides the logical and timing abstraction required by the digital implementation tools.

---

### Prompt 11: Generate GDSII from MAG Layout

#### Prompt

```text
Using the verified AMUX2_3V.mag layout, generate the final GDSII physical
layout.

Create AMUX2_3V.gds.

Ensure that:
1. SKY130A layer mappings are correct.
2. Complete macro geometry is included.
3. Pin locations are preserved.
4. Macro dimensions remain consistent.
5. The GDS can be integrated into the OpenLane flow.
```

#### Outcome

The final physical GDSII representation of the analog hard macro was generated.

#### Generated File

```text
gds/AMUX2_3V.gds
```

#### Observation

The GDSII contains the detailed physical geometry required for final-chip integration.

---

### Prompt 12: Cross-View Consistency Check

#### Prompt

```text
Check the consistency of all AMUX2_3V macro views.

Compare:
1. AMUX2_3V.v
2. AMUX2_3V.mag
3. Extracted AMUX2_3V.spice
4. AMUX2_3V.lef
5. AMUX2_3V.lib
6. AMUX2_3V.gds

Verify:
- Macro name.
- Pin names.
- Pin directions.
- Power and ground connections.
- Macro dimensions.
- Pin locations.
- Logical connectivity.
- Physical connectivity.

Identify any inconsistencies that could cause DRC, LVS, routing,
timing or OpenLane integration failures.
```

#### Outcome

The different logical, physical, timing, and layout views of the `AMUX2_3V` hard macro were cross-checked before OpenLane integration.

#### Observation

Consistency between **Verilog, MAG, SPICE, LEF, LIB, and GDS** is essential for successful mixed-signal hard-macro integration.

---

### Prompt 13: Generate OpenLane Configuration

#### Prompt

```text
Generate the OpenLane configuration for the design_mux project.

Create the required configuration files.

Include:
1. Top-level Verilog files.
2. AMUX2_3V blackbox Verilog.
3. AMUX2_3V LEF.
4. AMUX2_3V LIB.
5. AMUX2_3V GDS.
6. Macro placement configuration.
7. SKY130A PDK settings.
8. Die and core parameters.
9. Clock configuration.
10. Hard-macro placement information.

Ensure that AMUX2_3V is treated as a hard macro and that all views are
correctly linked to the top-level digital design.
```

#### Outcome

The OpenLane configuration and macro-placement files required for the mixed-signal RTL-to-GDSII flow were prepared.

#### Generated Files

```text
config.json
cfg/macro.cfg
```

#### Observation

Correct file paths, macro names, pin definitions, dimensions, and placement coordinates are critical for successful hard-macro integration.

---

## Overall Flow

```text
Reference Repository Analysis
            ↓
Identify Required Files
            ↓
Digital RTL Generation
            ↓
 ┌─────────────────────────────┐
 │ raven_spi.v                 │
 │ spi_slave.v                 │
 │ design_mux.v                │
 └──────────────┬──────────────┘
                ↓
       AMUX2_3V Blackbox
          AMUX2_3V.v
                ↓
       AMUX2_3V MAG Layout
          AMUX2_3V.mag
                ↓
        ┌───────┼────────┐
        ↓       ↓        ↓
      SPICE    LEF      GDSII
        ↓       ↓        ↓
     .spice    .lef     .gds
                ↓
        LIB / Timing Model
          AMUX2_3V.lib
                ↓
      Cross-View Validation
                ↓
       OpenLane Configuration
                ↓
       Macro Placement
                ↓
       RTL-to-GDSII Flow
                ↓
          DRC / LVS / STA
                ↓
           Final GDSII
```


> Important Note: AI-generated outputs may contain errors, incorrect assumptions, or implementation mistakes. All AI-generated code, layout information, configuration files, and recommendations must therefore be reviewed, verified, corrected, and validated using the appropriate EDA tools, simulations, DRC, LVS, STA, and the SKY130A PDK before being used in the final design flow. AI was used as an assistance and development tool, while final design decisions and verification were performed by the designer.

---
</details>

<details>
<summary>Practical Implementation</summary>

### 1. Environment Setup

The mixed-signal physical-design flow was implemented using the following tools and technologies:

* **OS:** Ubuntu Linux
* **PDK:** SKY130A
* **Analog Simulation:** Xschem / ngspice
* **Layout:** Magic
* **LVS:** Netgen
* **Digital RTL Simulation:** Icarus Verilog
* **Physical Design:** OpenLane / OpenROAD
* **Layout Viewer:** KLayout
* **HDL:** Verilog
* **Scripting/Configuration:** Tcl, JSON

---

### 2. Project Structure

The project was organized into digital RTL, analog macro, physical views, and OpenLane configuration files.

```text
design_mux/
│
├── src/
│   ├── design_mux.v
│   ├── raven_spi.v
│   ├── spi_slave.v
│   └── AMUX2_3V.v
│
├── macros/
│   ├── AMUX2_3V.mag
│   └── AMUX2_3V.spice
│
├── lef/
│   └── AMUX2_3V.lef
│
├── lib/
│   └── AMUX2_3V.lib
│
├── gds/
│   └── AMUX2_3V.gds
│
├── cfg/
│   └── macro.cfg
│
└── config.json
```

---

### 3. Digital RTL Implementation

The digital portion of the design was implemented using Verilog RTL.

The main digital files are:

```text
src/raven_spi.v
src/spi_slave.v
src/design_mux.v
```

#### `raven_spi.v`

Implements the SPI controller logic and generates the required control and data signals.

#### `spi_slave.v`

Implements the SPI slave-side serial communication logic, including serial data transfer and control.

#### `design_mux.v`

Acts as the top-level integration module and connects the digital SPI logic with the `AMUX2_3V` analog hard macro.

The digital RTL was checked for syntax and functionality before proceeding to physical implementation.

---

### 4. AMUX2_3V Analog Macro

The `AMUX2_3V` block was implemented as an analog 2:1 multiplexer and integrated as a hard macro.

The analog macro provides:

```text
I0      → Input 0
I1      → Input 1
select  → Selection control
out     → Selected output
VPWR    → Power
VGND    → Ground
```

The macro was treated separately from the digital RTL because its internal implementation is transistor-level analog circuitry.

---

### 5. Analog Simulation

The analog design was simulated using **ngspice** before physical implementation.

The simulation flow was used to verify:

* Functional behaviour of the 2:1 multiplexer.
* Selection of `I0` when `select = 0`.
* Selection of `I1` when `select = 1`.
* Output transition behaviour.
* Power and ground connectivity.

Example simulation flow:

```text
Schematic
   ↓
SPICE Netlist
   ↓
ngspice
   ↓
Transient Simulation
   ↓
Waveform Verification
```

Both select states were verified before proceeding to layout.

---

### 6. AMUX2_3V Physical Layout

The transistor-level physical layout was created using **Magic**.

Generated layout:

```text
macros/AMUX2_3V.mag
```

The layout includes:

* Transistor geometries.
* Metal interconnections.
* Input/output pins.
* Power and ground connections.
* Required SKY130A layers.
* Macro boundary.

The layout was checked using Magic DRC before generating the abstract physical views.

---

### 7. DRC Verification

Design Rule Check (DRC) was performed on the `AMUX2_3V` layout.

The purpose of DRC was to verify that the physical layout follows the design rules of the SKY130A PDK.

```text
AMUX2_3V.mag
      ↓
   Magic DRC
      ↓
DRC Verification
```

The layout was iteratively modified whenever physical design-rule violations were identified.

---

### 8. LVS Verification

Layout Versus Schematic (LVS) was performed using **Netgen**.

The extracted layout netlist was compared against the reference schematic/SPICE netlist.

```text
Schematic/SPICE
      ↓
    Netgen
      ↑
Extracted Layout
```

LVS was used to verify:

* Device correspondence.
* Net connectivity.
* Pin correspondence.
* Power and ground connectivity.
* Overall circuit topology.

---

### 9. Post-Layout SPICE Extraction

After the physical layout was prepared, the layout was extracted to generate the post-layout SPICE representation.

Generated file:

```text
macros/AMUX2_3V.spice
```

The extracted netlist was simulated using ngspice to verify that the physical implementation retained the expected electrical behaviour.

```text
AMUX2_3V.mag
      ↓
Magic Extraction
      ↓
AMUX2_3V.spice
      ↓
ngspice
      ↓
Post-Layout Verification
```

---

### 10. LEF Generation

The abstract physical representation of the analog macro was generated as a LEF file.

Generated file:

```text
lef/AMUX2_3V.lef
```

The LEF contains the information required by the digital physical-design tools, including:

* Macro dimensions.
* Pin locations.
* Pin names.
* Routing layers.
* Blockages/obstructions.
* Macro boundary.

The LEF allows OpenLane/OpenROAD to treat `AMUX2_3V` as a physical hard macro during floorplanning and routing.

---

### 11. Liberty Model

A Liberty model was prepared for the analog macro.

Generated file:

```text
lib/AMUX2_3V.lib
```

The Liberty model provides the digital implementation flow with the required cell, pin, functional, and timing abstraction.

The following information was kept consistent:

```text
Verilog Pin Names
       ↕
LEF Pin Names
       ↕
LIB Pin Names
       ↕
GDS/MAG Physical Pins
```

---

### 12. GDSII Generation

The final physical representation of the `AMUX2_3V` macro was generated in GDSII format.

Generated file:

```text
gds/AMUX2_3V.gds
```

The GDSII contains the detailed physical geometry of the analog macro and is used for final physical integration.

---

### 13. Hard Macro Integration

The generated analog views were integrated into the digital OpenLane flow.

The major macro views are:

```text
AMUX2_3V.v       → Logical abstraction
AMUX2_3V.mag     → Transistor-level layout
AMUX2_3V.spice   → Extracted electrical representation
AMUX2_3V.lef     → Physical abstract
AMUX2_3V.lib     → Timing/functional abstraction
AMUX2_3V.gds     → Physical layout
```

These views were integrated with:

```text
raven_spi.v
      +
spi_slave.v
      +
design_mux.v
      +
AMUX2_3V hard macro
```

---

### 14. OpenLane Configuration

OpenLane was configured to recognize `AMUX2_3V` as a hard macro.

Important configuration files:

```text
config.json
cfg/macro.cfg
```

The configuration includes:

* Top-level design name.
* RTL source files.
* PDK configuration.
* LEF files.
* LIB files.
* GDS files.
* Macro placement.
* Die/core dimensions.
* Clock configuration.
* Macro-related settings.

---

### 15. RTL-to-GDSII Physical Design

The complete digital physical-design flow was executed using OpenLane.

```text
Verilog RTL
     ↓
Synthesis
     ↓
Floorplanning
     ↓
Macro Placement
     ↓
Power Planning
     ↓
Placement
     ↓
CTS
     ↓
Routing
     ↓
Parasitic Extraction
     ↓
STA
     ↓
DRC
     ↓
LVS
     ↓
Final GDSII
```

The `AMUX2_3V` analog macro was preserved as a hard macro throughout the digital physical-design flow.

---

### 16. Final Verification

The final implementation was checked using multiple verification stages.

| Verification           | Purpose                                    |
| ---------------------- | ------------------------------------------ |
| RTL Simulation         | Verify digital functionality               |
| ngspice Simulation     | Verify analog functionality                |
| Magic DRC              | Check layout design rules                  |
| Netgen LVS             | Check layout-versus-schematic connectivity |
| Post-Layout Simulation | Verify extracted physical implementation   |
| STA                    | Check timing constraints                   |
| OpenLane Signoff       | Verify physical implementation             |

---

</details>

  
</details>

<details>
<summary>Bugs & Debugs</summary>
</details>

---

### TASK-2 — Analog 2×1 MUX Physical Design

<details>
<summary>Theory</summary>
</details>

<details>
<summary>Prompts</summary>
</details>

<details>
<summary>Practical Implementation</summary>
</details>

<details>
<summary>Bugs & Debugs</summary>
</details>

---

### TASK-3 — Digital SPI Controller Physical Design

<details>
<summary>Task & Concept Clarity</summary>
</details>

<details>
<summary>Prompts</summary>
</details>

<details>
<summary>Practical Implementation</summary>
</details>

<details>
<summary>Bugs & Debugs</summary>
</details>

---

### TASK-4 — Mixed-Signal Integration and Final RTL-to-GDSII

<details>
<summary>Task & Concept Clarity</summary>
</details>

<details>
<summary>Prompts</summary>
</details>

<details>
<summary>Practical Implementation</summary>
</details>

<details>
<summary>Bugs & Debugs</summary>
</details>


---

## Conclusion

---

