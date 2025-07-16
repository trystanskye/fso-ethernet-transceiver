# fso-ethernet-transceiver
Prototyping a free-space optical transceiver with custom circuits, embedded systems, optics, and simulation-based verification

## Overview

This project implements a fully custom hardware system to transmit a 100BASE-TX Ethernet signal using free-space optical communication. The project spans multiple engineering domains, combining analog and digital circuit design, FPGA-based signal processing, computational modeling, and mechanical design to create a modular and reproducible prototype.

---

## System Diagram

![Block Diagram](./docs/block-diagram.svg)

---

## Repository Structure

- electrical/ → Schematics, PCB layouts (KiCad), and SPICE simulations
- embedded/ → Simulink timing models and FPGA implementation files
- computational/ → Monte Carlo ray tracing, solar irradiance analysis (C++, R)
- mechanical/ → SolidWorks chassis, mounts, and alignment systems
- docs/ → System diagram, engineering notes, design references

---

## Subsystem Overview

### Electrical
- **Custom Circuit Design**: Analog photodetector amplifier, laser driver, and Ethernet PHY interface
- **PCB Design**: KiCad-based schematic capture and modular PCB layout
- **SPICE Simulation**: Stability, bandwidth, and signal integrity analysis in LTSpice

### Embedded
- **Simulink Timing Model**: Simulates synchronization, clock domains, and interface behavior
- **FPGA Implementation**: Handles serialization/deserialization (SERDES) and signal processing logic

### Computational
- **Monte Carlo Ray Tracing (C++)**: Simulates coupling efficiency under misalignment, beam divergence, and lens parameters
- **Solar Irradiance Modeling (R)**: Analyzes spectral noise conditions using real-world datasets to guide photodetector filtering and signal margining
- **Signal Modeling**: Frequency and time-domain simulations of critical analog subcircuits

### Mechanical
- **Optical Mounts**: Modeled supports for lenses, detectors, and laser modules
- **Aiming Mechanism**: Mechanical alignment system for beam targeting
- **Chassis Design**: 3D-modeled full system enclosure and support frame

---

## Planned Features

- FPGA-based control logic for final transceiver prototype
- 3D printed mechanical chassis and alignment mechanism
- Finalized testing, waveforms, and photos (to be added to `/results`)
- Assembly instructions and complete bill of materials (BOM)

---

## Contact

Trystan Skye  
[LinkedIn](https://www.linkedin.com/in/trystanskye)  
[GitHub](https://github.com/trystanskye)  
Email: trystansk1@gmail.com

