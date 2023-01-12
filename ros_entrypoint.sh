#!/bin/bash
echo "Starting up......."
source /opt/catkin-workspace/devel/setup.bash && roslaunch localization_logger localization_logger.launch
