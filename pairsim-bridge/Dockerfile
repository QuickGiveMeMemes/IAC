FROM ros:humble-ros-base

# Dockerfile for setting up the ROS2 TCP Endpoint node for Unity

# Set up ROS2 Environment
ENV ROS2_WS=/ros2_ws
RUN mkdir -p ${ROS2_WS}/src
WORKDIR ${ROS2_WS}/src

# Cloning and building tcp bridge
RUN git clone https://github.com/Unity-Technologies/ROS-TCP-Endpoint /ros2_ws/src/ros_tcp_endpoint -b ROS2v0.7.0
WORKDIR ${ROS2_WS}
RUN . /opt/ros/humble/setup.sh && colcon build

RUN echo "source ${ROS2_WS}/install/setup.bash" >> ~/.bashrc && \
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc