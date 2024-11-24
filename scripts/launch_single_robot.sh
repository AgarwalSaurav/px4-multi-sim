#!/bin/bash

print_usage() {
  echo "Usage: launch_single_robot.sh <robot_id> <x> <y>"
  echo "  robot_id: ID of the robot to launch"
  echo "  x: x-coordinate of the robot"
  echo "  y: y-coordinate of the robot"
}
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  print_usage
  exit 0
fi
if [ "$#" -ne 3 ]; then
  echo "Error: Invalid number of arguments"
  print_usage
  exit 1
fi

ROBOT_ID=$1
CONTAINER_NAME=px4_robot_$ROBOT_ID
POSE="$2,$3"
echo "Launching robot $ROBOT_ID with pose $POSE"

docker run -d --rm --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  --env=PX4_GZ_STANDALONE=1 \
  --env=PX4_GZ_MODEL_POSE=$POSE \
  --env=PX4_SYS_AUTOSTART=4001 \
  --env=PX4_SIM_MODEL=gz_x500 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --network host \
  --name=$CONTAINER_NAME agarwalsaurav/px4-dev-ros2-humble /opt/px4_ws/src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i $ROBOT_ID
