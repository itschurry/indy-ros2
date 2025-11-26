# Set the base image to Ubuntu 22.04
FROM ghcr.io/itschurry/ros:humble 

# Set environment variable to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install neuromeka Python package
RUN pip3 install neuromeka

# Install git for clone the ROS2 source code
RUN apt-get update && apt-get install -y git

# Add ROS 2 environment setup to .bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc \
    && echo "source /home/user/indy-ros2/install/setup.bash" >> /root/.bashrc \
    && echo "cd /home/user/indy-ros2" >> /root/.bashrc

# Use bash as the default shell
SHELL ["/bin/bash", "-c"]

# Set the default command to run when starting the container
CMD ["bash"]

