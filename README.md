# Hardware-Based Canny Edge Detection using Verilog HDL

## 📌 Project Overview
This project presents a **hardware-optimized implementation of the Canny Edge Detection algorithm** using **Verilog HDL**, designed for FPGA and VLSI-based image processing systems. The architecture avoids floating-point operations and employs adaptive local thresholding and hysteresis tracking to achieve efficient edge detection suitable for real-time embedded applications.

---

## 🎯 Objectives
- Implement the complete Canny Edge Detection pipeline at RTL level  
- Optimize the design for FPGA-friendly architectures  
- Use adaptive thresholding and hysteresis tracking in hardware  
- Verify functionality using simulation-based image processing  

---

## 🧠 Hardware Canny Pipeline
Input Image
↓
3×3 Line Buffer
↓
Sobel Gradient Magnitude
↓
Gradient Direction Quantization (8 Zones)
↓
Non-Maximum Suppression
↓
Local Mean Adaptive Threshold
↓
Hysteresis Edge Tracking
↓
Final Edge Output


---

## 📁 Repository Structure

Canny-Edge-Detection-Verilog/
├── input/
│ ├── input.hex
│ └── input.png
│
├── python/
│ ├── PNG_to_HEX.py
│ └── HEX_to_PNG.py
│
├── results/
│ ├── Canny_output.hex
│ ├── Canny_output.png
│ └── waveform.png
│
├── rtl/
│ ├── canny_top.v
│ ├── line_buffer_3x3.v
│ ├── sobel_grad_mag_quad.v
│ ├── grad_dir_8zone.v
│ ├── nms_8dir.v
│ ├── local_mean_threshold.v
│ ├── hysteresis_tracker.v
│ └── line_buffer_mag.v
│
├── tb/
│ └── tb_canny.v
│
└── README.md

---

## 🧩 RTL Module Description

| Module Name | Description |
|------------|-------------|
| canny_top.v | Top-level module integrating the complete Canny pipeline |
| line_buffer_3x3.v | Generates 3×3 sliding window for convolution |
| sobel_grad_mag_quad.v | Computes Sobel gradient magnitude |
| grad_dir_8zone.v | Quantizes gradient direction into 8 directional zones |
| nms_8dir.v | Direction-based Non-Maximum Suppression |
| local_mean_threshold.v | Adaptive local mean thresholding |
| hysteresis_tracker.v | Edge tracking using hysteresis |
| line_buffer_mag.v | Buffers gradient magnitude for NMS |

---

## 🧪 Simulation & Verification
- **Input:** 8-bit grayscale image in HEX format  
- **Resolution:** 256 × 256 (configurable)  
- **Verification:** Testbench-driven simulation  
- **Output:** Edge image in HEX and PNG formats  

Simulation confirms correct gradient computation, proper non-maximum suppression, adaptive threshold stability, and continuous edge linking using hysteresis.

---

## 🛠 Tools & Technologies
- Verilog HDL  
- Vivado Simulator / ModelSim  
- Python (image pre/post-processing)  
- RTL pipelined architecture  

---

## 🚀 Applications
- FPGA-based vision systems  
- Object boundary detection  
- Autonomous navigation  
- Medical image preprocessing  
- Embedded surveillance systems  

---

## 📈 Future Enhancements
- AXI-Stream interface integration  
- BRAM-optimized line buffers  
- FPGA synthesis and timing analysis  
- Power and area optimization  
- Real-time camera interface  

---

## 📜 License
This project is intended for academic and research use.

---

## 👤 Author
**Nitheesh S**  
Undergraduate Engineer – Electronics Engineering (VLSI DT) 
Hardware Image Processing | FPGA | Verilog HDL
