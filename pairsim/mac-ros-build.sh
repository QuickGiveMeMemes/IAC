#!/bin/bash

# 

echo "Installing homebrew dependencies..."
brew install asio assimp bison bullet console_bridge cppcheck \
   cunit eigen freetype graphviz opencv openssl orocos-kdl pcre poco \
   pyqt@5 python@3.10 qt@5 sip spdlog tinyxml2
  
# Note: osrf/simulation/tinyxml1 is listed as a dependency for ROS2 Humble,
# but the local ROS2 install is only for RViz/other viewers + cli, so it is unnecessary.

echo "Environment variable setup..."
echo "export OPENSSL_ROOT_DIR=$(brew --prefix openssl)" >> ~/.zshrc
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$(brew --prefix qt@5)
export PATH=$PATH:$(brew --prefix qt@5)/bin

echo "Installing python dependencies..."
python3.10 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -U \
  --config-settings="--global-option=build_ext" \
  --config-settings="--global-option=-I$(brew --prefix graphviz)/include/" \
  --config-settings="--global-option=-L$(brew --prefix graphviz)/lib/" \
  argcomplete catkin_pkg colcon-common-extensions coverage \
  cryptography empy flake8 flake8-blind-except==0.1.1 flake8-builtins \
  flake8-class-newline flake8-comprehensions flake8-deprecated \
  flake8-docstrings flake8-import-order flake8-quotes \
  importlib-metadata lark==1.1.1 lxml matplotlib mock mypy==0.931 netifaces \
  nose pep8 psutil pydocstyle pydot pygraphviz pyparsing==2.4.7 \
  pytest-mock rosdep rosdistro setuptools==59.6.0 vcstool

echo "Building ROS2 code in directory ~/ros2_humble/src ..."
mkdir -p ~/ros2_humble && cd ~/ros2_humble
rm -rf build install log src      # Cleaning up environment
mkdir src
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Applies PR#944 (2 commits)
cd ~/ros2_humble/src/ros2/rviz
git fetch origin pull/944/head:pr-944
git cherry-pick -x --strategy=recursive -X theirs \
  c77fe8d76326d99fb864c2273f910f96be44d5cb \
  9cd559afb72dc9a7f09082a4fe3e0afcbb3a6803

# curl -sSL \
#   https://raw.githubusercontent.com/IOES-Lab/ROS2_Jazzy_MacOS_Native_AppleSilicon/main/patches/rviz_ogre_vendor.patch \
#   | patch -p1 -Ns
# curl -sSL \
#   https://raw.githubusercontent.com/IOES-Lab/ROS2_Jazzy_MacOS_Native_AppleSilicon/main/patches/0001-pragma.patch \
#   | patch -p1 -Ns


cd ~/ros2_humble

# NOTE: If colcon build fails and the error is a rejected hunk in precompiledheaders, manually edit it in.
colcon build \
  --symlink-install \
  --packages-skip-by-dep python_qt_binding uncrustify uncrustify_vendor \
  --packages-skip fastrtps rmw_fastrtps_cpp rmw_fastrtps_dynamic_cpp fastrtps_vendor \
  --cmake-args \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
    -DBUILD_TESTING=OFF \
    -DTHIRDPARTY=FORCE \
    -DPython3_EXECUTABLE=$VIRTUAL_ENV/bin/python3 \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -Wno-dev