module asynchronous_robot_control (
    input wire Z, // Proximity sensor input
    input wire clk, // Clock for asynchronous flip-flop transitions
    output reg left, right // Outputs controlling left or right rotation
);

    // States: Left Rotation = 0, Right Rotation = 1
    reg state;

    // Asynchronous state transition logic
    always @ (posedge clk) begin
        if (Z == 1)
            state <= state; // Keep rotating in the same direction
        else
            state <= ~state; // Alternate direction when Z=0
    end

    // Output logic
    always @ (*) begin
        case (state)
            1'b0: begin
                left = 1; right = 0; // Left rotation
            end
            1'b1: begin
                left = 0; right = 1; // Right rotation
            end
        endcase
    end

endmodule

// Testbench for Asynchronous Design

module asynchronous_robot_control (
    input wire Z, // Proximity sensor input
    input wire clk, // Clock for asynchronous flip-flop transitions
    output reg left, right // Outputs controlling left or right rotation
);

    // States: Left Rotation = 0, Right Rotation = 1
    reg state;

    // Asynchronous state transition logic
    always @ (posedge clk) begin
        if (Z == 1)
            state <= state; // Keep rotating in the same direction
        else
            state <= ~state; // Alternate direction when Z=0
    end

    // Output logic
    always @ (*) begin
        case (state)
            1'b0: begin
                left = 1; right = 0; // Left rotation
            end
            1'b1: begin
                left = 0; right = 1; // Right rotation
            end
        endcase
    end

endmodule
