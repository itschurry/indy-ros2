# Set the base image to Ubuntu 22.04
FROM ghcr.io/itschurry/ros:humble 

# Set environment variable to avoid prompts during package installation
LABEL authors="itschurry"
LABEL maintainer="cheolhee75@icloud.com"
ARG DEBIAN_FRONTEND=noninteractive

ARG PROJDIR="indy-ros2"   # Project directory, 적절한 이름으로 변경
ARG BUILD_TYPE
ENV BUILD_TYPE=${BUILD_TYPE}
# ----------------------------------------------------------------------------------------------
RUN id -u && id -g
ARG UID=1000
ARG GID=1000
ARG HOME=/home/appuser
ARG USER=appuser

RUN useradd -u $UID -d $HOME -m -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    usermod -aG sudo,plugdev $USER

USER $USER
WORKDIR $HOME
# ----------------------------------------------------------------------------------------------
# Install neuromeka Python package
RUN pip3 install neuromeka

# Add ROS 2 environment setup to .bashrc
RUN echo 'source ~/ros_settings.sh' >> $HOME/.bashrc
# ADD entrypoint.sh $HOME/entrypoint.sh
ADD ros_settings.sh $HOME/ros_settings.sh

# Use bash as the default shell
SHELL ["/bin/bash", "-c"]

# Set the default command to run when starting the container
CMD ["bash"]

