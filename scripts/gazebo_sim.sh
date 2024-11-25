#!/bin/bash

source .env
# enable access to xhost from the container
xhost +

docker run -it --rm --privileged \
  --env=LOCAL_USER_ID="$(id -u)" \
  --env=ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=:0 \
  --net=host \
  --ipc=host \
  --pid=host \
  --name=px4_gazebo_sim agarwalsaurav/px4-dev-ros2-humble python /opt/px4_ws/src/PX4-Autopilot/Tools/simulation/gz/simulation-gazebo --headless
