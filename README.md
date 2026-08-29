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



### Project (2x1 mux)

This project implements a mixed-signal system in which a 2:1 analog
multiplexer (`AMUX2_3V`) is integrated with a digital SPI-based control
block. The analog multiplexer selects one of two analog input signals
(`I0` or `I1`) based on the digital select signal and provides the selected
signal at the output.

The digital SPI controller provides the control interface for the analog
MUX. The analog macro is represented as a hard macro during synthesis and
physical implementation, while its physical and layout information is
provided through the required macro views.

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

AI was used throughout the task to analyze the reference repository,
understand the mixed-signal physical-design flow, generate the required
input files and assist in completing the physical-design implementation.

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
4. How the analog macro is integrated with the digital design.
5. The required input files for the physical-design flow.
6. The sequence of tools and stages used to generate the final layout.
```

#### Outcome

The repository structure, design methodology, important files and overall
mixed-signal RTL-to-GDSII flow were understood.

#### Observation

The analysis showed that the analog macro requires different views such as
Verilog, LEF, LIB and GDS for integration into the physical-design flow.

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

The required RTL, analog macro, LEF, LIB, GDS, OpenLane configuration
and macro-placement files were identified.

#### Observation

Each file has a specific role in the flow. The logical, physical, timing
and layout information must remain consistent across all macro views.

---

### Prompt 3: Generate Top-Level RTL

#### Prompt

```text
Generate the required top-level Verilog file for the design_mux project.

Instantiate the AMUX2_3V analog macro as a hard macro and maintain the
required macro interface and signal connectivity.

Do not implement the internal analog circuitry in RTL.
```

#### Outcome

The top-level RTL required for integrating the analog macro with the
digital design was generated.

#### Observation

The top-level RTL provides the logical connection to the analog macro
while allowing its physical implementation to remain as a separate hard
macro.

---

### Prompt 4: Generate Analog Macro Blackbox

#### Prompt

```text
Generate the Verilog blackbox model required for the AMUX2_3V analog
hard macro.

Use the exact macro module name and port names required by the reference
design. The blackbox should contain only the macro interface and should
not contain the internal analog implementation.
```

#### Outcome

The `AMUX2_3V` blackbox Verilog file was generated.

#### Observation

The blackbox allows synthesis and OpenLane to recognize the analog macro
without synthesizing its internal analog circuitry.

---

### Prompt 5: Generate LEF and Physical Macro Information

#### Prompt

```text
Explain and generate the required procedure to create the AMUX2_3V LEF
abstract view from the analog layout.

Include the required macro dimensions, pins, layers, routing information
and obstructions needed by OpenLane for physical implementation.
```

#### Outcome

The required LEF generation procedure and physical macro information were
obtained.

#### Observation

The LEF provides the abstract physical representation required for
floorplanning, placement and routing.

---

### Prompt 6: Generate LIB and Timing Information

#### Prompt

```text
Generate or explain the required Liberty model for AMUX2_3V.

Identify the required cell, pin, functional and timing information needed
to integrate the macro into the OpenLane physical-design flow.
```

#### Outcome

The required LIB information for the analog macro was generated and
prepared for integration.

#### Observation

The LIB provides the timing and functional abstraction required by the
digital implementation tools.

---

### Prompt 7: Generate OpenLane Configuration

#### Prompt

```text
Generate the OpenLane configuration required for the design_mux project.

Include:
1. Top-level Verilog
2. AMUX2_3V LEF
3. AMUX2_3V LIB
4. AMUX2_3V GDS
5. Macro placement configuration
6. SKY130 PDK settings
7. Required die and core parameters.

Ensure that the AMUX2_3V is treated as a hard macro.
```

#### Outcome

The OpenLane configuration and macro-placement configuration required
for the project were generated.

#### Observation

Correct file paths, macro names and physical dimensions are critical for
successful macro integration.

---

### Prompt 8: Complete Physical-Design Flow

#### Prompt

```text
Using the generated design files and OpenLane configuration, provide the
complete sequence of commands required to perform the physical-design flow.

Include:
1. Synthesis
2. Floorplanning
3. Placement
4. PDN generation
5. CTS
6. Routing
7. DRC
8. LVS
9. GDSII generation.

Explain the expected output of each stage.
```

#### Outcome

The required physical-design commands and execution sequence were
generated.

#### Observation

The physical-design stages were executed sequentially, with the output
of each stage used as the input for the next stage.

---

AI was therefore used not only for generating code, but also for
understanding the reference implementation, preparing the required
inputs, executing the physical-design flow.
---

</details>

<details>
<summary>AI-Generated Files</summary>

</details>

<details>
<summary>Practical Implementation</summary>
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
<summary>AI-Generated Files</summary>
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

