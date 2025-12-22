source /opt/ros/humble/setup.bash
rosdep update --rosdistro=humble
rosdep install --from-paths src --ignore-src -r
source /opt/ros/humble/setup.bash
colcon build \
    --packages-skip rviz_carla_plugin \
    --packages-skip-by-dep rviz_carla_plugin \
    --cmake-args \
        -DCMAKE_BUILD_TYPE=Release