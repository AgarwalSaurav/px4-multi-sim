#!/bin/bash

# Check if PX4_WS is set
if [ -z "$PX4_WS" ]; then
  echo "PX4_WS is not set. Please set it to the path of your PX4 workspace."
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
  -v ${PX4_WS}:/workspace/:rw \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --network host \
  --name=$CONTAINER_NAME agarwalsaurav/px4-dev-ros2-humble src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i $ROBOT_ID
