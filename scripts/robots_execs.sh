#!/bin/bash
PX4_GZ_STANDALONE=1 PX4_GZ_MODEL_POSE="0,0" PX4_SYS_AUTOSTART=4001 PX4_SIM_MODEL=gz_x500 src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i 1 &
PX4_GZ_STANDALONE=1 PX4_GZ_MODEL_POSE="0,1" PX4_SYS_AUTOSTART=4001 PX4_SIM_MODEL=gz_x500 src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i 2 &
PX4_GZ_STANDALONE=1 PX4_GZ_MODEL_POSE="1,1" PX4_SYS_AUTOSTART=4001 PX4_SIM_MODEL=gz_x500 src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i 3
