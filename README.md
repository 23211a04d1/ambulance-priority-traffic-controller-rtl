# ambulance-priority-traffic-controller-rtl
Verilog RTL design of an intelligent traffic controller with ambulance-priority override, verified using Vivado behavioral simulation.

This project implements a smart traffic signal controller using Verilog RTL. The controller manages a four-way junction with time-based traffic phases and provides an ambulance-priority override that immediately forces the emergency lane to turn green. The design is verified through behavioral simulation in Vivado.

1. Features
-FSM-based traffic phase control
-Four main phases: NS Green, NS Yellow, EW Green, EW Yellow
-Ambulance override for both NS and EW roads
-Automatic recovery to normal cycle after emergency
-Time-controlled transitions using counters
-Fully synthesizable Verilog RTL
-Dedicated testbench for simulation and verification

2. How the Design Works

The controller operates as a finite state machine (FSM). Under normal conditions, the junction cycles through the following sequence:
-North-South Green
-North-South Yellow
-East-West Green
-East-West Yellow
-Repeat

Each phase runs for a predefined amount of time, determined by internal counters.
When an ambulance is detected on a road (either NS or EW), the controller immediately transitions into the corresponding ambulance state:
-NS_AMBULANCE
-EW_AMBULANCE

During ambulance mode:
The emergency lane stays green for a fixed number of cycles (AMB_TIME).
All other lanes remain red to ensure safe passage.
After the ambulance period expires, the controller transitions back into the normal traffic cycle.

3. FSM States
The following states are implemented in the RTL:
-NS_GREEN
-NS_YELLOW
-EW_GREEN
-EW_YELLOW
-NS_AMBULANCE
-EW_AMBULANCE

State transitions occur based on timers and emergency inputs.

4. Parameter Definitions
The design uses three timing parameters, defined in clock cycles:
-GREEN_TIME (10 cycles)
Duration for which NS or EW remains green during normal operation.
-YELLOW_TIME (4 cycles)
Duration of the yellow phase before switching to the opposite direction.
-AMB_TIME (15 cycles)
Duration for which the ambulance-priority green remains active.

These parameters can be modified as needed to represent real-world timing.
