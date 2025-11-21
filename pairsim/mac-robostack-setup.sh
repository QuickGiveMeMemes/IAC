#!/bin/bash
# Make sure conda is already installed and sourced

conda create -n ros_env -c conda-forge -c robostack-humble ros-humble-desktop
conda activate ros_env
conda config --env --add channels robostack-humble

conda activate ros_env
conda install -c conda-forge compilers cmake pkg-config make ninja colcon-common-extensions catkin_tools rosdep ros-humble-rmw-cyclonedds-cpp



export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file://$PWD/cyclonedds_config.xml