module synchronous_robot_control (
    input wire clk,  // Clock signal for the D flip-flops
    input wire reset, // Reset signal to reset the FSM to the initial state
    input wire S1, S2, // Sensor inputs
    output reg Z1, Z2  // Motor control outputs
);

    // Define the states of the FSM
    typedef enum logic [1:0] {
        A = 2'b00,  // State A
        B = 2'b01,  // State B
        C = 2'b10,  // State C
        D = 2'b11   // State D
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic (combinational logic)
    always @(*) begin
        case (current_state)
            A: begin
                if (S1 == 0 && S2 == 0)
                    next_state = A;
                else if (S1 == 0 && S2 == 1)
                    next_state = B;
                else if (S1 == 1 && S2 == 0)
                    next_state = C;
                else if (S1 == 1 && S2 == 1)
                    next_state = D;
                Z1 = 0; Z2 = 0; // Motor brakes in state A
            end
            B: begin
                if (S1 == 0 && S2 == 1)
                    next_state = B;
                else if (S1 == 1 && S2 == 0)
                    next_state = C;
                else if (S1 == 1 && S2 == 1)
                    next_state = D;
                else
                    next_state = A;
                Z1 = 1; Z2 = 0; // Drive forward in state B
            end
            C: begin
                if (S1 == 0 && S2 == 1)
                    next_state = B;
                else if (S1 == 1 && S2 == 0)
                    next_state = C;
                else if (S1 == 1 && S2 == 1)
                    next_state = D;
                else
                    next_state = A;
                Z1 = 1; Z2 = 0; // Drive forward in state C
            end
            D: begin
                if (S1 == 0 && S2 == 1)
                    next_state = B;
                else if (S1 == 1 && S2 == 0)
                    next_state = C;
                else if (S1 == 1 && S2 == 1)
                    next_state = D;
                else
                    next_state = A;
                Z1 = 0; Z2 = 1; // Motor brake in state D
            end
            default: begin
                next_state = A;
                Z1 = 0; Z2 = 0;
            end
        endcase
    end

    // State register (sequential logic)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule

// Testbench for Synchronous Design

module tb_synchronous_robot_control;

    reg clk;
    reg reset;
    reg S1, S2;
    wire Z1, Z2;

    // Instantiate the synchronous FSM
    synchronous_robot_control uut (
        .clk(clk),
        .reset(reset),
        .S1(S1),
        .S2(S2),
        .Z1(Z1),
        .Z2(Z2)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        S1 = 0; S2 = 0;
        #10 reset = 0;

        // Test different sensor inputs
        #10 S1 = 0; S2 = 1;  // Test state B
        #10 S1 = 1; S2 = 0;  // Test state C
        #10 S1 = 1; S2 = 1;  // Test state D
        #10 S1 = 0; S2 = 0;  // Test state A

        #10 $finish;
    end

endmodule
