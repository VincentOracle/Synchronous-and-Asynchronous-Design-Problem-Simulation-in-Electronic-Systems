// Testbench for Asynchronous Robot Control FSM
module tb_asynchronous_robot_control;

    // Inputs
    reg Z;

    // Outputs
    wire left;
    wire right;

    // Instantiate the FSM module
    asynchronous_robot_control uut (
        .Z(Z),
        .left(left),
        .right(right)
    );

    // Test sequence
    initial begin
        // Initialize inputs
        Z = 1;  // Obstacle detected, continue rotating in the same direction

        // Monitor outputs
        $monitor("Time: %0d, Z = %b, Left = %b, Right = %b", $time, Z, left, right);

        // Test different inputs for the sensor
        #10 Z = 0;  // No obstacle, switch direction
        #10 Z = 1;  // Obstacle detected, continue
        #10 Z = 0;  // No obstacle, switch direction
        #10 Z = 1;  // Obstacle detected, continue
        #10 Z = 0;  // No obstacle, switch direction

        #50 $finish;  // End simulation
    end

endmodule
