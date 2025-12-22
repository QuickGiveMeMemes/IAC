# syntax=docker/dockerfile:1.7

ARG CARLA_VERSION=0.9.15
ARG ROS_DISTRO=humble

FROM carlasim/carla:$CARLA_VERSION as carla
FROM amd64/ros:$ROS_DISTRO-ros-base

ARG ROS_DISTRO=humble
ENV ROS_DISTRO=$ROS_DISTRO
ENV DEBIAN_FRONTEND=noninteractive

# Install deps
RUN apt-get update && apt-get install -y    python3-pip \
                                            python3.10-venv \
                                            wget \
                                            ros-${ROS_DISTRO}-pcl-conversions \
                                            ros-${ROS_DISTRO}-cv-bridge \
                                            ros-${ROS_DISTRO}-derived-object-msgs \
    && rm -rf /var/lib/apt/lists/*


# Copying PythonAPI and installing Python3.10 egg and wheel
COPY --from=carla /home/carla/PythonAPI /opt/carla/PythonAPI
WORKDIR /opt/carla/PythonAPI/carla/dist 
RUN wget https://github.com/gezp/carla_ros/releases/download/carla-0.9.15-ubuntu-22.04/carla-0.9.15-cp310-cp310-linux_x86_64.whl && \
    pip3 install carla-0.9.15-cp310-cp310-linux_x86_64.whl

ENV EGG_PATH="/opt/carla/PythonAPI/carla/dist/carla-0.9.15-py3.10-linux-x86_64.egg"
RUN /bin/bash -c '\
    echo "export PYTHONPATH=/opt/carla/PythonAPI/carla:${EGG_PATH}}:\$PYTHONPATH" >> ~/.bashrc'
ENV PYTHONPATH=/opt/carla/PythonAPI/carla:${PYTHONPATH}


# Building ROS
RUN mkdir -p /opt/carla-ros-bridge/src
COPY requirements.txt /opt/carla-ros-bridge/src
WORKDIR /opt/carla-ros-bridge/src
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt


