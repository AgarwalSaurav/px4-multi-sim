#!/bin/bash

# Check if PX4_WS is set
if [ -z "$PX4_WS" ]; then
  echo "PX4_WS is not set. Please set it to the path of your PX4 workspace."
  exit 1
fi
docker run -it --rm --init --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  -v ${PX4_WS}:/workspace/:rw \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=:1 \
  --gpus all \
  --network host \
  --name=px4_xrce_agent agarwalsaurav/px4-dev-ros2-humble MicroXRCEAgent udp4 -p 8888
