# Verilog Digital Integrator — GitHub Project

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
└── .gitignore
```

---

# 1. `rtl/integrator.v`

```verilog
`timescale 1ns/1ps

module integrator #(
    parameter WIDTH = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   enable,
    input  wire signed [WIDTH-1:0] input_data,
    output reg  signed [WIDTH-1:0] output_data
);

    /*
     * Discrete-time integrator:
     *
     * output[n] = output[n-1] + input[n]
     *
     * Reset clears the accumulated value.
     */

    always @(posedge clk) begin
        if (rst) begin
            output_data <= 0;
        end
        else if (enable) begin
            output_data <= output_data + input_data;
        end
    end

endmodule
```

---

# 2. `tb/tb_integrator.v`

```verilog
`timescale 1ns/1ps

module tb_integrator;

    parameter WIDTH = 16;

    reg clk;
    reg rst;
    reg enable;
    reg signed [WIDTH-1:0] input_data;
    wire signed [WIDTH-1:0] output_data;

    // Instantiate DUT
    integrator #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .input_data(input_data),
        .output_data(output_data)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Waveform dump
        $dumpfile("integrator.vcd");
        $dumpvars(0, tb_integrator);

        // Initial values
        clk        = 0;
        rst        = 1;
        enable     = 0;
        input_data = 0;

        $display("==============================================");
        $display("       DIGITAL INTEGRATOR SIMULATION");
        $display("==============================================");
        $display("Time\tReset\tEnable\tInput\tOutput");
        $display("----------------------------------------------");

        // Hold reset for two clock cycles
        #12;
        rst = 0;
        enable = 1;

        // Input = 1
        input_data = 1;
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Input = 2
        input_data = 2;
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Input = 3
        input_data = 3;
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Disable integration
        enable = 0;
        input_data = 5;

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Enable again
        enable = 1;
        input_data = -2;

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Finish simulation
        #10;

        $display("----------------------------------------------");
        $display("Simulation completed successfully.");
        $display("==============================================");

        $finish;
    end

endmodule
```

---

# 3. `simulation/expected_output.txt`

```text
==============================================
       DIGITAL INTEGRATOR SIMULATION
==============================================
Time    Reset   Enable  Input   Output
----------------------------------------------
16      0       1       1       1
26      0       1       1       2
36      0       1       1       3
46      0       1       2       5
56      0       1       2       7
66      0       1       3       10
76      0       1       3       13
86      0       0       5       13
96      0       1      -2       11
106     0       1      -2       9
----------------------------------------------
Simulation completed successfully.
==============================================
```

> The exact displayed simulation timestamps can vary slightly if you modify the testbench timing. The important expected behavior is the accumulated output sequence:
>
> **1 → 2 → 3 → 5 → 7 → 10 → 13 → 13 → 11 → 9**

---

# 4. `README.md`

````markdown
# Digital Integrator in Verilog

## Overview

This project implements a simple discrete-time digital integrator using Verilog HDL.

A digital integrator accumulates the input signal over time. The basic equation used in this project is:

    output[n] = output[n-1] + input[n]

The design is implemented as a synchronous accumulator controlled by a clock, reset, and enable signal.

## Features

- Synthesizable Verilog RTL
- Parameterized data width
- Synchronous clocked operation
- Reset functionality
- Enable control
- Signed input and output
- Self-checking-style simulation through a testbench display
- VCD waveform generation
- Compatible with Icarus Verilog and GTKWave

## Block Diagram

```text
              +----------------+
              |                |
input_data -->|     Adder      |----> output_data
              |                |
              +-------+--------+
                      |
                      v
              +---------------+
              |   Register    |
              |  Accumulator  |
              +-------+-------+
                      |
                      +----------+
                                 |
                                 +----> Feedback
````

## Working Principle

At every positive edge of the clock:

```text
output = output + input
```

When `rst` is asserted:

```text
output = 0
```

When `enable` is low, the output retains its previous value.

### Example

If the input sequence is:

```text
1, 1, 1, 2, 2, 3, 3
```

The output sequence becomes:

```text
1, 2, 3, 5, 7, 10, 13
```

This demonstrates the accumulation behavior of the integrator.

## Ports

| Port          | Direction | Description               |
| ------------- | --------- | ------------------------- |
| `clk`         | Input     | System clock              |
| `rst`         | Input     | Reset signal              |
| `enable`      | Input     | Enables integration       |
| `input_data`  | Input     | Signed input value        |
| `output_data` | Output    | Accumulated signed output |

## Parameter

The module has a configurable data width:

```verilog
parameter WIDTH = 16
```

The default input/output width is 16 bits.

## Requirements

You can use any Verilog simulator. This project can be simulated using:

* Icarus Verilog
* GTKWave
* ModelSim
* QuestaSim
* Vivado Simulator

## Simulation Using Icarus Verilog

### Step 1: Compile

From the project root directory:

```bash
iverilog -o integrator_sim rtl/integrator.v tb/tb_integrator.v
```

### Step 2: Run

```bash
vvp integrator_sim
```

### Step 3: View Waveform

The testbench generates:

```text
integrator.vcd
```

Open it using GTKWave:

```bash
gtkwave integrator.vcd
```

## Expected Output

The important accumulated values are:

```text
Input       Output
------------------
1           1
1           2
1           3
2           5
2           7
3           10
3           13
5           13   <- disabled
-2          11
-2          9
```

When `enable = 0`, the input is ignored and the output remains unchanged.

## Applications

Digital integrators are useful in:

* Digital signal processing
* Control systems
* PID controllers
* Digital filters
* Sensor signal processing
* Embedded systems
* FPGA-based control systems

## Limitations

This basic implementation uses fixed-width arithmetic. If the accumulated value exceeds the available signed range, overflow can occur.

For a 16-bit signed output, the normal range is:

```text
-32768 to +32767
```

For practical applications, additional bits can be added to the accumulator to reduce the possibility of overflow.

## Future Improvements

Possible extensions include:

1. Add configurable gain.
2. Add saturation logic.
3. Add an adjustable integration step.
4. Add overflow detection.
5. Create a pipelined version.
6. Add a SystemVerilog assertion-based testbench.
7. Compare RTL output with a software reference model.
8. Add automated simulation using GitHub Actions.

## License

This project is provided for educational and academic purposes.

````

---

# 5. `.gitignore`

```text
*.vcd
*.out
*.vvp
*.log
*.wlf
*.jou
*.pb
*.cache
````

---

# GitHub Upload Commands

Create a repository named something like:

```text
verilog-integrator
```

Then run:

```bash
git init

git add .

git commit -m "Initial commit - Verilog digital integrator"

git branch -M main

git remote add origin YOUR_GITHUB_REPOSITORY_URL

git push -u origin main
```

## Suggested GitHub Repository Description

```text
A parameterized digital integrator implemented in Verilog HDL with RTL design, testbench, simulation output, waveform generation, and documentation.
```

## Suggested Topics/Tags

```text
verilog
fpga
digital-design
integrator
hdl
rtl
simulation
iverilog
gtkwave
digital-signal-processing
```
