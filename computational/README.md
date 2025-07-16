# Optical Modeling

This folder contains modeling tools used to evaluate the optical performance and robustness of the free-space optical (FSO) link in the FSO Ethernet Transceiver project.

---

## Submodules

### `monte-carlo-ray-tracing/`
High-volume ray tracing simulation (C++) for assessing optical alignment and beam spread.

### `solar-irradiance-modeling/`
Real-world spectral analysis (R) using irradiance data to quantify ambient light interference and validate filter choices.

---

## Goals

- Estimate photon coupling efficiency under misalignment
- Simulate Lambertian emission and receiver angular sensitivity
- Quantify environmental optical noise in critical IR bands
- Validate optical and photodetector design decisions using modeling

---

## Monte Carlo Ray Tracing (C++)

### Purpose

Simulates photon trajectories between the emitter and photodetector using a Lambertian distribution to assess the angular tolerance of the optical link.

### Features

- Uniform surface emission with cosine-weighted angular distribution
- Large-scale Monte Carlo integration (up to 10⁸+ iterations)
- Parallelized with OpenMP
- Models hit probability on a photodiode array at a fixed distance

### File Structure

```
/monte-carlo-ray-tracing/
├── main.cpp           # Core simulation logic
├── CMakeLists.txt     # OpenMP-compatible build script
```

### Build Instructions

```bash
cd monte-carlo-ray-tracing
mkdir build && cd build
cmake ..
make
./MonteCarloRayTracing
```

---

## Solar Irradiance Modeling (R)

### Purpose

Processes real-world solar spectral data to evaluate expected environmental noise and interference in the IR band. Assists in verifying photodiode filter choices and calculating expected background signal levels.

### Features

- Loads 2002-wavelength-band irradiance data from NREL's NSRDB
- Integrates spectra to estimate total and filtered irradiance (e.g., 840–860nm)
- Identifies highest-intensity environmental conditions (Feb 22, 2022 @ 7PM)
- Provides visualizations of raw, filtered, and responsivity-limited spectra
- Includes basic R-based ray tracing model for comparison with C++

### File Structure

```
/solar-irradiance-modeling/
├── spectrum-analysis.R     # Full data wrangling, visualization, and filtering logic
```

---

## Data Source

The irradiance data was obtained from the **NSRDB Spectral On-Demand Service**, powered by the **FARMS-NIT** model from NREL.

- Wavelength range: **280–4000 nm** (2002 bands)
- Conditions: Fixed-tilt, south-facing panel, 90° angle
- Model: **FARMS-NIT** (Fast All-sky Radiation Model for Solar Applications with Narrowband Irradiances on Tilted Surfaces)
- Methodology:
  - Clear-sky model uses SMARTS for optical properties
  - Cloudy-sky conditions are modeled using DISORT-derived BTDF and lookup tables
  - Outputs spectral irradiance (W/m²/μm) over time
- Citation:  
  Xie, Y., Sengupta, M. (2018). *Solar Energy*, 174, 691–702.

### ⚠️ Note:
The large raw `.csv` file containing the full 8760-hour dataset is **excluded** from the repository due to size. It can be shared upon request.

---

## Future Work

- Expand ray tracing to include lens systems and mechanical jitter
- Generate monthly average and worst-case irradiance models
- Model photodiode signal-to-noise ratio with filter response
- Correlate simulated and experimental optical performance
