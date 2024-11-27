#!/bin/bash

export ROS_DOMAIN_ID=10

ORIG_INPUT_PARAMS="$@"
params="$(getopt -o d:n:xcbshr -l directory: -l name:help,create,xrce,bash,sim,headless,robots --name "$(basename "$0")" -- "$@")"

if [ $? -ne 0 ]
then
  echo "Parameter error"
  print_usage
fi


print_usage() {
    cat <<EOF
Usage: bash $0 [OPTIONS]

Options:
  -d, --directory <workspace directory>  Specify the workspace directory.
  -n, --name <container name>            Specify the container name.

  -c, --create                            Create a new container.
  -b, --bash                              Start an interactive bash shell.
  -x, --xrce                              Start MicroXRCEAgent.
  -s, --sim                               Start gazebo simulator.
      --headless                          Run in headless mode (valid only with -s|--sim).
  -r, --robots                            Launch multiple robots (see robots_execs.sh)

  -h, --help                              Show this help message and exit.

Note:
  - Only one of the following options can be specified: -x, -s, -r, -c, -b.
EOF
}

eval set -- "$params"
unset params

IMAGE_NAME=agarwalsaurav/px4-dev-ros2-humble:latest
docker pull ${IMAGE_NAME}
CONTAINER_NAME=px4_main
PX4_DIR=/opt/px4_ws/src/PX4-Autopilot
HEADLESS=""
chmod +x robots_execs.sh

while true; do
  case ${1} in
    -d|--directory) WS_DIR=("${2}");shift 2;;
    -n|--name) CONTAINER_NAME=("${2}");shift 2;;
    -b|--bash) BASH=true;shift;;
    -x|--xrce) XRCE=true;shift;;
    -s|--sim) SIM=true;shift;;
    -r|--robots) EXEC_MULTIPLE_ROBOTS=true;shift;;
    -c|--create) CREATE=true;shift;;
    --headless) HEADLESS="--headless";shift;;
    -h|--help) print_usage; exit 0;;
    --) shift;break;;
    *) print_usage
      exit 1 ;;
  esac
done

if [ -z ${WS_DIR} ]; then
  VOLUME_OPTION=""
else
  VOLUME_OPTION="-v ${WS_DIR}:/workspace:rw"
fi

create_container() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container already running. Exiting..."
    exit 0
  fi
  docker run -d -it --rm --init --privileged \
    --env=LOCAL_USER_ID="$(id -u)" \
    --env=ROS_DOMAIN_ID=${ROS_DOMAIN_ID} \
    --env=PX4_GZ_STANDALONE=1 \
    --env=PX4_SYS_AUTOSTART=4001 \
    --env=PX4_GZ_MODEL=x500 \
    --env=DISPLAY=${DISPLAY} \
    --net=host \
    --ipc=host \
    --pid=host \
    -v $(pwd):/px4_scripts:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    ${VOLUME_OPTION} \
    --name=${CONTAINER_NAME} ${IMAGE_NAME} bash
}
exec_xrce() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker exec -it ${CONTAINER_NAME} gosu user MicroXRCEAgent udp4 -p 8888
    exit 0
  else 
    echo "Container not running. Starting container..."
    create_container
    exec_xrce
  fi
}

exec_bash() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker exec -it ${CONTAINER_NAME} gosu user bash
    exit 0
  else 
    echo "Container not running. Start using --xrce."
    exit 1
  fi
}

exec_gazebo_sim() {
  xhost +
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker exec -it ${CONTAINER_NAME} gosu user python ${PX4_DIR}/Tools/simulation/gz/simulation-gazebo ${HEADLESS}
    exit 0
  else 
    echo "Container not running. Start using --xrce."
    exit 1
  fi
}

exec_multiple_robots() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker exec -it ${CONTAINER_NAME} gosu user bash /px4_scripts/robots_execs.sh
    exit 0
  else 
    echo "Container not running. Start using --xrce."
    exit 1
  fi
}

exec_single_robot() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    ROBOT_ID=$1
    POSE="$2,$3,0,0,0,0"
    docker exec -it ${CONTAINER_NAME} gosu user bash PX4_GZ_MODEL_POSE="$POSE" ${PX4_DIR}/build/px4_sitl_default/bin/px4 -i $ROBOT_ID
    exit 0
  else 
    echo "Container not running. Start using --xrce."
    exit 1
  fi
}

if [[ ${CREATE} == true ]]; then
  create_container
  exit 0
fi

if [[ ${BASH} == true ]]; then
  exec_bash
  exit 0
fi

if [[ ${XRCE} == true ]]; then
  exec_xrce
  exit 0
fi

if [[ ${SIM} == true ]]; then
  exec_gazebo_sim
  exit 0
fi

if [[ ${EXEC_MULTIPLE_ROBOTS} == true ]]; then
  exec_multiple_robots
  exit 0
fi
