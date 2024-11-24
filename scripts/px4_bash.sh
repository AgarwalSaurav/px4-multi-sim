#!/bin/bash

source .env
# Check if PX4_WS is set
if [ -z "$PX4_WS" ]; then
  echo "PX4_WS is not set. Please set it to the path of your PX4 workspace."
  exit 1
fi
CONTAINER_NAME=px4_bash

# Check if the container is running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  # if the container is running, attach to it
  docker exec -it $CONTAINER_NAME gosu user bash
else
  # if the container is stopped, start it
  if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
    # if the container is stopped, start it
    docker start $CONTAINER_NAME
  else
    # if the container does not exist, create it
    docker run -it --rm --privileged \
      --env=LOCAL_USER_ID="$(id -u)" \
      --env=ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
      -v ${PX4_WS}:/workspace/:rw \
      -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
      --net=host \
      --pid=host \
      --ipc=host \
      --name=$CONTAINER_NAME agarwalsaurav/px4-dev-ros2-humble bash
  fi
fi
