# fso-ethernet-transceiver
Prototyping a free-space optical transceiver with custom circuits, embedded systems, optics, and simulation-based verification

## Overview

This project explores the feasibility of transmitting Ethernet data over free space using infrared laser beams. The system integrates custom analog and digital circuits, embedded logic, optical components, and mechanical alignment systems. Simulation and modeling are used to verify performance under real-world and worst-case conditions.

## Key Components

- **Custom Circuits**: Analog and digital design for laser driver, photodetector amplifier, and Ethernet signal interfacing
- **Embedded Systems**: Verilog-based control and data timing for transmission and reception
- **Optical Design**: Lens-based collimation and alignment system for point-to-point transmission
- **Computational Modeling**:
  - Monte Carlo ray tracing in C++ to simulate alignment tolerances
  - FPGA logic simulation and timing validation in MATLAB/Simulink
  - Solar irradiance modeling in R using real-world datasets for environmental interference analysis
- **Mechanical Design**: SolidWorks-based prototyping of chassis, optical mounts, and aiming systems
- **PCB Design**: Schematic capture and layout in KiCad with modular, debug-friendly structure
- **Circuit Simulation**: LTSpice modeling of amplifier stability, bandwidth, and signal integrity

## System Diagram

![Block Diagram](./docs/block-diagram.svg)

## Repository Structure

- /circuits/ - KiCad schematics and board files (partial, redacted)
- /spice/ - LTSpice simulations of analog subcircuits
- /optics/ - Ray tracing code and optical performance models
- /r-analysis/ - R scripts and irradiance modeling datasets
- /cad/ - SolidWorks assemblies and optical mount designs
- /embedded/ - Verilog code and testbenches (in progress)
- /docs/ - Diagrams, datasheets, engineering notes


## Simulation & Modeling

### Ray Tracing (C++)

A custom Monte Carlo ray tracing engine is used to estimate optical alignment sensitivity. It incorporates beam divergence, lens parameters, and receiver aperture geometry to evaluate coupling efficiency under misalignment.

### FPGA Logic Simulation (MATLAB/Simulink)

A MATLAB/Simulink model is used to simulate signal flow and timing behavior in the digital logic system prior to implementation in Verilog. This helps verify interface timing, synchronization, and control logic feasibility for the transceiver system.

### Solar Spectrum Modeling (R)

Public irradiance datasets were cleaned and analyzed to extract realistic solar spectral conditions under both average and worst-case outdoor environments. This informs photodiode filtering and noise margin testing.

### Circuit Simulation (LTSpice)

Transient and frequency-domain simulations are used to validate amplifier gain, phase stability, and overall signal chain performance before hardware prototyping.

## Planned Additions

- Verilog control logic for PHY interface and timing alignment
- Expanded circuit validation in LTSpice with modeled parasitics
- 3D printed chassis and optical alignment system
- Ethernet signal decoding and testing setup
- Assembly instructions and bill of materials

## Licensing and Intellectual Property

Some files (e.g., full schematics, PCB layouts, Verilog source code) are intentionally excluded from this public repository due to ongoing development and potential future patenting.

Please contact me directly if you're interested in collaboration, discussion, or technical details.

## Contact

Trystan Skye  
[LinkedIn](https://www.linkedin.com/in/trystanskye)  
[GitHub](https://github.com/trystanskye)  
Email: trystansk1@gmail.com

