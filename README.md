# Single cycle and pipeline architecture MIPS processors
## Description
VHDL code and schematics/tables for **single cycle** and **pipeline** implementation (5 stages) of the MIPS processor.\
Contains example program (+description) included in instruction memory.\

## Technical details
Both implementations follow the Harvard architecture, thus there are separate memories for the instructions and the data.\
In the pipeline implementation, for easier understanding, the registers between different stages are broken down into separate registers for each intermediary signal.
There are also no mechanisms implemented for resolving hazards, thus the reordering of code and introduction of stalls were necessary with respect to the original (single cycle) code.
