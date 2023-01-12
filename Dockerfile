FROM ros:melodic

RUN apt-get update && apt-get install -y build-essential ros-melodic-mavros ros-melodic-catkin ros-melodic-cv-bridge ros-melodic-image-transport unzip python-pip

RUN pip install numpy
RUN mkdir third_party
WORKDIR /third_party
RUN wget https://github.com/opencv/opencv/archive/3.4.9.zip && unzip 3.4.9.zip
WORKDIR /third_party/opencv-3.4.9
RUN mkdir build
WORKDIR /third_party/opencv-3.4.9/build
RUN cmake .. && make -j5 && make install

WORKDIR /
COPY ./spinnaker-1.27.0.48-Ubuntu18.04-arm64-pkg.tar.gz /third_party/spinnaker-1.27.0.48-Ubuntu18.04-arm64-pkg.tar.gz
WORKDIR /third_party
RUN tar -xzvf spinnaker-1.27.0.48-Ubuntu18.04-arm64-pkg.tar.gz
WORKDIR /third_party/spinnaker-1.27.0.48-arm64
COPY ./responses.txt ./responses.txt
RUN /bin/bash -c "cat responses.txt | bash install_spinnaker_arm.sh"

RUN groupadd flirimaging && usermod -aG flirimaging root
RUN /opt/ros/melodic/lib/mavros/install_geographiclib_datasets.sh
RUN apt-get install ros-melodic-compressed-image-transport

COPY ./catkin-workspace /opt/catkin-workspace
WORKDIR /opt/catkin-workspace
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"


COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
