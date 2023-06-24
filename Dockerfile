# First, we will use the Ubuntu image
FROM ubuntu:22.04

# Next, we will define the maintainer of our image and its email
LABEL maintainer="Carlos Gonzalez" email="cgonv1993@gmail.com"

# We make our image non-interactive
ENV DEBIAN_FRONTEND noninteractive

# We update the whole system
RUN apt-get -y update && apt-get -y upgrade

# Install basics
RUN apt install -y \
git \
nano \
wget \
python3-pip \
xfce4-terminal \
terminator \
libgl1-mesa-dev \
libxcb-* \
libxkb*

# Install jupyter
RUN python3 -m pip install jupyterlab

# Go to /myyolov7 folder
WORKDIR /docker-yolov7

# Download yolov7 repo from GitHub
RUN git clone https://github.com/WongKinYiu/yolov7.git

# Copy labelimg from directory to container
COPY YoloLabel_v1.2.1 YoloLabel_v1.2.1

# Set the default command to start terminator
CMD ["terminator"]

#-------------------------------------------#

#--IF ERRORS, TRY:--#
# xhost + local:docker (in local terminal)
# build image again using --no-cache --> docker build --no-cache -t docker-yolov7_image .
