```verilog
`timescale 1ns/1ps

module tb_integrator;

    parameter WIDTH = 16;

    reg clk;
    reg rst;
    reg enable;

    reg signed [WIDTH-1:0] input_data;
    wire signed [WIDTH-1:0] output_data;

    // Instantiate Integrator
    integrator #(
        .WIDTH(WIDTH)
    ) dut (
        .input_data(input_data),
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .output_data(output_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Generate waveform
        $dumpfile("integrator.vcd");
        $dumpvars(0, tb_integrator);

        // Initial values
        clk = 0;
        rst = 1;
        enable = 0;
        input_data = 0;

        $display("==============================================");
        $display("       DIGITAL INTEGRATOR SIMULATION");
        $display("==============================================");
        $display("Time\tReset\tEnable\tInput\tOutput");
        $display("----------------------------------------------");

        // Reset
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

        // Disable integrator
        enable = 0;
        input_data = 5;

        @(posedge clk);
        #1;
        $display("%0t\t%b\t%b\t%d\t%d",
                 $time, rst, enable, input_data, output_data);

        // Enable again with negative input
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

        $display("----------------------------------------------");
        $display("Simulation completed successfully.");
        $display("==============================================");

        #10;
        $finish;

    end

endmodule
```
