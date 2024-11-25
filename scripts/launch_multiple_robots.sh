#!/bin/bash

source .env
chmod +x robots_execs.sh

CONTAINER_NAME=px4_robots
docker run -it --rm --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  --env=PX4_GZ_STANDALONE=1 \
  --env=PX4_SYS_AUTOSTART=4001 \
  --env=ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
  --env=PX4_GZ_MODEL=x500 \
  --net=host \
  --ipc=host \
  --pid=host \
  -v ./robots_execs.sh:/robots_execs.sh:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --name=$CONTAINER_NAME agarwalsaurav/px4-dev-ros2-humble /robots_execs.sh
  # --name=$CONTAINER_NAME agarwalsaurav/px4-dev-ros2-humble src/PX4-Autopilot/build/px4_sitl_default/bin/px4 -i $ROBOT_ID
