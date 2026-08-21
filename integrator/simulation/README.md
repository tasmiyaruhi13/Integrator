````markdown
# Digital Integrator Using Verilog

## Project Description

This project implements a digital integrator using Verilog HDL.

A digital integrator accumulates the input signal at every positive edge of the clock.

The basic equation is:

    output[n] = output[n-1] + input[n]

The design contains:

- Verilog RTL code
- Verilog testbench
- Clock generation
- Reset control
- Enable control
- Signed input and output
- VCD waveform generation
- Expected simulation output

---

## Project Structure

```text
verilog-integrator/
│
├── rtl/
│   └── integrator.v
│
├── tb/
│   └── tb_integrator.v
│
├── simulation/
│   └── expected_output.txt
│
├── README.md
│
└── .gitignore
````

---

## Block Diagram

```text
                input_data
                    |
                    v
             +-------------+
             |             |
             |    Adder    |
             |             |
             +------+------+
                    |
                    v
             +-------------+
             |             |
             | Accumulator |
             |  Register   |
             |             |
             +------+------+
                    |
                    |
                    +----------------+
                                     |
                                     |
                                  output_data
```

---

## Module Ports

| Signal      | Direction | Width | Description         |
| ----------- | --------- | ----- | ------------------- |
| clk         | Input     | 1 bit | Clock               |
| rst         | Input     | 1 bit | Reset               |
| enable      | Input     | 1 bit | Enables integration |
| input_data  | Input     | WIDTH | Signed input        |
| output_data | Output    | WIDTH | Integrated output   |

---

## Working Principle

When reset is active:

```text
output_data = 0
```

When enable is active:

```text
output_data = output_data + input_data
```

When enable is disabled:

```text
output_data = previous output_data
```

---

## Example

Suppose the input sequence is:

```text
1, 1, 1, 2, 2, 3, 3
```

The output becomes:

```text
1, 2, 3, 5, 7, 10, 13
```

Calculation:

```text
Initial output = 0

After input 1:
0 + 1 = 1

After input 1:
1 + 1 = 2

After input 1:
2 + 1 = 3

After input 2:
3 + 2 = 5

After input 2:
5 + 2 = 7

After input 3:
7 + 3 = 10

After input 3:
10 + 3 = 13
```

---

## Simulation

### Using Icarus Verilog

Compile the design:

```bash
iverilog -o integrator_sim rtl/integrator.v tb/tb_integrator.v
```

Run the simulation:

```bash
vvp integrator_sim
```

The testbench creates a waveform file:

```text
integrator.vcd
```

Open the waveform using GTKWave:

```bash
gtkwave integrator.vcd
```

---

## Expected Simulation

The expected accumulated values are:

```text
Input    Output
----------------
1        1
1        2
1        3
2        5
2        7
3        10
3        13
5        13
-2       11
-2       9
```

When `enable = 0`, the output does not change.

---

## Applications

Digital integrators can be used in:

* Digital signal processing
* Control systems
* FPGA designs
* PID controllers
* Digital filters
* Sensor processing
* Embedded systems

---

## Tools

This project can be simulated using:

* Icarus Verilog
* GTKWave
* ModelSim
* QuestaSim
* Vivado

---

## Future Improvements

Possible improvements include:

1. Fixed-point arithmetic
2. Overflow detection
3. Saturation logic
4. Configurable gain
5. Larger accumulator width
6. SystemVerilog assertions
7. Automated GitHub Actions simulation
8. MATLAB/Python reference model

---

## Author

Digital Integrator Project

## License

This project is intended for educational purposes.

```
```
