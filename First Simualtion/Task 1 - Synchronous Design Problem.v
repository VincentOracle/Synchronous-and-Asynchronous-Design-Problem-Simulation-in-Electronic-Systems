// Synchronous Robot Control FSM
module synchronous_robot_control (
    input wire clk,      // Clock signal
    input wire reset,    // Reset signal
    input wire S1,       // Proximity sensor 1
    input wire S2,       // Proximity sensor 2
    output reg Z1,       // Motor control signal 1 (forward drive)
    output reg Z2        // Motor control signal 2 (brake)
);

    // State encoding (2-bit)
    typedef enum reg [1:0] {
        A = 2'b00,  // State A: No motion
        B = 2'b01,  // State B: Drive forward (S1=0, S2=1)
        C = 2'b10,  // State C: Drive forward (S1=1, S2=0)
        D = 2'b11   // State D: Brake or reverse (S1=1, S2=1)
    } state_t;

    state_t current_state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            A: begin
                if (S1 == 0 && S2 == 0)
                    next_state = A;  // Stay in A (no motion)
                else if (S1 == 0 && S2 == 1)
                    next_state = B;  // Go to state B (drive forward)
                else if (S1 == 1 && S2 == 0)
                    next_state = C;  // Go to state C (drive forward)
                else if (S1 == 1 && S2 == 1)
                    next_state = D;  // Go to state D (brake)
            end
            B: begin
                if (S1 == 1 && S2 == 1)
                    next_state = D;  // Go to state D (brake)
                else if (S1 == 0 && S2 == 0)
                    next_state = A;  // Go to state A (no motion)
                else
                    next_state = B;  // Stay in B (drive forward)
            end
            C: begin
                if (S1 == 1 && S2 == 1)
                    next_state = D;  // Go to state D (brake)
                else if (S1 == 0 && S2 == 0)
                    next_state = A;  // Go to state A (no motion)
                else
                    next_state = C;  // Stay in C (drive forward)
            end
            D: begin
                if (S1 == 0 && S2 == 0)
                    next_state = A;  // Go to state A (no motion)
                else
                    next_state = D;  // Stay in D (brake)
            end
            default: next_state = A;  // Default state is A
        endcase
    end

    // State register (sequential logic)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;  // Reset to state A
        else
            current_state <= next_state;  // Update state
    end

    // Output logic (combinational)
    always @(*) begin
        case (current_state)
            A: begin
                Z1 = 0; Z2 = 0;  // Brake
            end
            B: begin
                Z1 = 1; Z2 = 0;  // Drive forward (S1=0, S2=1)
            end
            C: begin
                Z1 = 1; Z2 = 0;  // Drive forward (S1=1, S2=0)
            end
            D: begin
                Z1 = 0; Z2 = 1;  // Brake (S1=1, S2=1)
            end
            default: begin
                Z1 = 0; Z2 = 0;  // Default: Brake
            end
        endcase
    end

endmodule

// Testbench for the Synchronous FSM
// Testbench for Synchronous Robot Control FSM
module tb_synchronous_robot_control;

    // Inputs
    reg clk;
    reg reset;
    reg S1;
    reg S2;

    // Outputs
    wire Z1;
    wire Z2;

    // Instantiate the FSM module
    synchronous_robot_control uut (
        .clk(clk),
        .reset(reset),
        .S1(S1),
        .S2(S2),
        .Z1(Z1),
        .Z2(Z2)
    );

    // Clock generation
    always #5 clk = ~clk;  // Toggle clock every 5 time units

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;  // Apply reset
        S1 = 0; S2 = 0;  // No obstacle detected
        #10 reset = 0;  // Release reset

        // Test different sensor inputs
        #10 S1 = 0; S2 = 1;  // Move to state B (drive forward)
        #10 S1 = 1; S2 = 0;  // Move to state C (drive forward)
        #10 S1 = 1; S2 = 1;  // Move to state D (brake)
        #10 S1 = 0; S2 = 0;  // Move back to state A (brake)

        // Additional transitions can be tested here
        #50 $finish;  // End simulation
    end

endmodule
