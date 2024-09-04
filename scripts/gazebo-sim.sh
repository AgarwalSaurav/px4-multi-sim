#!/bin/bash

# Check if PX4_WS is set
if [ -z "$PX4_WS" ]; then
  echo "PX4_WS is not set. Please set it to the path of your PX4 workspace."
  exit 1
fi
# enable access to xhost from the container
xhost +

docker run -it --rm --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  --device=/dev/dri/card2 \
  --gpus all \
  -v ${PX4_WS}:/workspace/:rw \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=:1 \
  --network host \
  --name=px4_gazebo_sim agarwalsaurav/px4-dev-ros2-humble python ./PX4-Autopilot/Tools/simulation/gz/simulation-gazebo --headless
