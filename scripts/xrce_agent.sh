#!/bin/bash

source .env
docker run -it --rm --init --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  --env=ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --network host \
  --name=px4_xrce_agent agarwalsaurav/px4-dev-ros2-humble MicroXRCEAgent udp4 -p 8888
