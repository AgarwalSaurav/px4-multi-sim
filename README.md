# PX4 Multi-Vehicle Simulation using Docker containers

### Setup

```bash
docker pull agarwalsaurav/px4-dev-ros2-humble:latest
```

```bash
# Put this in .bashrc and open a new terminal
export PX4_WS=${HOME}/px4_ws    # Directory of your choice
```

For **main branch** of PX4-Autopilot
```bash
# Clone PX4-Autopilot (main branch)
mkdir -p ${PX4_WS}/src
git clone --recursive \
    https://github.com/PX4/PX4-Autopilot.git ${PX4_WS}/src/PX4-Autopilot
```

For **v1.14.0** of PX4-Autopilot
```bash
# Clone PX4-Autopilot
mkdir -p ${PX4_WS}/src
git clone https://github.com/PX4/PX4-Autopilot.git ${PX4_WS}/src/PX4-Autopilot
cd ${PX4_WS}/src/PX4-Autopilot
git checkout v1.14.0
cd ${PX4_WS}/src/PX4-Autopilot/Tools/simulation/gz/
wget https://raw.githubusercontent.com/PX4/PX4-gazebo-models/9e47793f2bc18aa7cde39b1fc1c4b7bbc67e04ba/simulation-gazebo
```

``` bash
# Clone simulator script files
git clone git@github.com:AgarwalSaurav/px4-multi-sim.git \
    ${PX4_WS}/src/px4-multi-sim
```

```bash
# Launch px4_bash to compile PX4-Autopilot
cd ${PX4_WS}/src/px4-multi-sim/scripts
bash px4_bash.sh
# You should now be in a shell
pip install symforce
cd src/PX4-Autopilot
make px4_sitl
```

```bash
# Launch xrce_agent on a new terminal
cd ${PX4_WS}/src/px4-multi-sim/scripts
bash xrce_agent.sh
```

```bash
# Launch gazebo_sim on a new terminal
xhost +
cd ${PX4_WS}/src/px4-multi-sim/scripts
bash gazebo_sim.sh
# Add --headless at the end of the command in the script for no GUI mode
```

```bash
# Edit robot configurations
cd ${PX4_WS}/src/px4-multi-sim/scripts
# Edit the file robots_execs.sh
# Change Pose and ID
```

```bash
# Launch multiple robots
cd ${PX4_WS}/src/px4-multi-sim/scripts
bash launch_multiple_robots.sh
# To stop the robot simulations
docker stop px4_robots
```


### Notes and links

https://docs.px4.io/main/en/sim_gazebo_gz/worlds.html
https://docs.px4.io/main/en/sim_gazebo_gz/#specify-world


https://docs.px4.io/main/en/sim_gazebo_gz/#headless-mode

##### simulation-gazebo args
https://github.com/PX4/PX4-gazebo-models/blob/main/simulation-gazebo
```python
    parser.add_argument('--world', help='World to run in Gazebo', required=False, default="default")
    parser.add_argument('--gz_partition', help='Gazebo partition to run in', required=False)
    parser.add_argument('--gz_ip', help='Outgoing network interface to use for traffic',required=False)
    parser.add_argument('--interactive',help='Run in interactive mode', required=False, default=False, action='store_true')
    parser.add_argument('--model_download_source', help='Path to directory containing model files', required=False, default=DEFAULT_DOWNLOAD_DIR)
    parser.add_argument('--model_store', help='Path to model storage directory', required=False, default="~/.simulation-gazebo")
    parser.add_argument('--overwrite', help='Overwrite existing model directories', required=False, default=False, action='store_true')
    parser.add_argument('--dryrun', help='Test in dryrun. Do not launch gazebo', required=False, default=False, action='store_true')
    parser.add_argument('--headless', help='Run Gazebo without GUI', required=False, default=False, action='store_true')
```

https://docs.px4.io/main/en/test_and_ci/docker.html#qgroundcontrol
