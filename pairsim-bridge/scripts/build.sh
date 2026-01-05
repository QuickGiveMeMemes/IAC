#!/bin/bash
set -euxo pipefail

source /opt/ros/humble/setup.bash
colcon build \
    --cmake-args -DCMAKE_BUILD_TYPE=Release