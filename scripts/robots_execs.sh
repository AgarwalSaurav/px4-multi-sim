#!/bin/bash

# Set robot ids and launch x, y coordinates
# "id, x, y"
ids_poses=(
  "1 0 0"
  "2 0 10"
  "3 1 10"
)

for id_pose in "${ids_poses[@]}"; do
  read -r id x y <<< "$id_pose"

  PX4_GZ_MODEL_POSE="${x},${y},0,0,0,0" /opt/px4_ws/src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i $id > /dev/null &
done

wait
